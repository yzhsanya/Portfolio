import pandas as pd
import numpy as np

from sklearn.model_selection import train_test_split, StratifiedKFold, cross_validate
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.pipeline import Pipeline
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import confusion_matrix, classification_report, cohen_kappa_score

DATA_PATH = "synthetic_mental_health_dataset.csv"


def build_mental_health_status(df: pd.DataFrame) -> pd.Series:
    def label(row):
        mood = row["mood_score"]
        stress = row["stress_level"]
        if mood >= 8 and stress <= 2:
            return "Good"
        if mood < 5 or stress > 4:
            return "Poor"
        return "Moderate"

    return df.apply(label, axis=1)


def main():
    df = pd.read_csv(DATA_PATH)

    df["mental_health_status"] = build_mental_health_status(df)

    X = df.drop(columns=["mental_health_status", "mood_score", "stress_level"])
    y = df["mental_health_status"]

    cat_cols = ["diet_quality", "weather"]
    num_cols = [c for c in X.columns if c not in cat_cols]

    preprocess_lr = ColumnTransformer(
        transformers=[
            ("num", Pipeline([("scaler", StandardScaler())]), num_cols),
            ("cat", OneHotEncoder(handle_unknown="ignore"), cat_cols),
        ]
    )

    preprocess_tree = ColumnTransformer(
        transformers=[
            ("num", "passthrough", num_cols),
            ("cat", OneHotEncoder(handle_unknown="ignore"), cat_cols),
        ]
    )

    lr_model = Pipeline(
        steps=[
            ("prep", preprocess_lr),
            ("clf", LogisticRegression(max_iter=2000, solver="lbfgs")),
        ]
    )

    rf_model = Pipeline(
        steps=[
            ("prep", preprocess_tree),
            ("clf", RandomForestClassifier(n_estimators=300, random_state=42)),
        ]
    )

    cv = StratifiedKFold(n_splits=10, shuffle=True, random_state=42)
    scoring = {
        "accuracy": "accuracy",
        "precision_macro": "precision_macro",
        "recall_macro": "recall_macro",
        "f1_macro": "f1_macro",
    }

    lr_cv = cross_validate(lr_model, X, y, cv=cv, scoring=scoring)
    rf_cv = cross_validate(rf_model, X, y, cv=cv, scoring=scoring)

    def summarize(name, res):
        print(f"\n{name} (10-fold CV)")
        for k, v in res.items():
            if k.startswith("test_"):
                print(f"{k.replace('test_', '')}: {np.mean(v):.3f} ± {np.std(v):.3f}")

    summarize("Logistic Regression", lr_cv)
    summarize("Random Forest", rf_cv)

    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, stratify=y, random_state=42
    )

    lr_model.fit(X_train, y_train)
    rf_model.fit(X_train, y_train)

    labels = ["Good", "Moderate", "Poor"]

    pred_lr = lr_model.predict(X_test)
    pred_rf = rf_model.predict(X_test)

    print("\nLogistic Regression (hold-out test)")
    print(confusion_matrix(y_test, pred_lr, labels=labels))
    print(classification_report(y_test, pred_lr, digits=3))
    print("kappa:", cohen_kappa_score(y_test, pred_lr))

    print("\nRandom Forest (hold-out test)")
    print(confusion_matrix(y_test, pred_rf, labels=labels))
    print(classification_report(y_test, pred_rf, digits=3))
    print("kappa:", cohen_kappa_score(y_test, pred_rf))

    ohe = rf_model.named_steps["prep"].named_transformers_["cat"]
    feature_names = num_cols + list(ohe.get_feature_names_out(cat_cols))
    importances = rf_model.named_steps["clf"].feature_importances_
    top = sorted(zip(feature_names, importances), key=lambda x: x[1], reverse=True)[:10]

    print("\nTop 10 RF feature importances:")
    for name, val in top:
        print(f"{name}: {val:.4f}")


if __name__ == "__main__":
    main()