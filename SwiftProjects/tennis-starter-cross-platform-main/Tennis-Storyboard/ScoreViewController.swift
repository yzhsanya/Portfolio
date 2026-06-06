import UIKit

class ScoreViewController: UIViewController {

    @IBOutlet weak var p1NameLabel: UILabel!
    @IBOutlet weak var p2NameLabel: UILabel!

    @IBOutlet weak var p1PointsLabel: UILabel!
    @IBOutlet weak var p2PointsLabel: UILabel!

    @IBOutlet weak var p1GamesLabel: UILabel!
    @IBOutlet weak var p2GamesLabel: UILabel!

    @IBOutlet weak var p1SetsLabel: UILabel!
    @IBOutlet weak var p2SetsLabel: UILabel!

    @IBOutlet weak var p1PreviousSetsLabel: UILabel!
    @IBOutlet weak var p2PreviousSetsLabel: UILabel!

    @IBOutlet weak var player1Button: UIButton!
    @IBOutlet weak var player2Button: UIButton!

    private var match = Match()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    @IBAction func p1AddPoint(_ sender: UIButton) {
        let snapshot = match.uiSnapshot()
        match.addPointToPlayer1()
        notifyIfNeeded(before: snapshot, winnerIfGame: "Player 1")
        updateUI()
    }

    @IBAction func p2AddPoint(_ sender: UIButton) {
        let snapshot = match.uiSnapshot()
        match.addPointToPlayer2()
        notifyIfNeeded(before: snapshot, winnerIfGame: "Player 2")
        updateUI()
    }

    @IBAction func restart(_ sender: Any) {
        match.reset()
        updateUI()
    }

    private func updateUI() {
        p1PreviousSetsLabel.text = match.previousSetsForPlayer1()
        p2PreviousSetsLabel.text = match.previousSetsForPlayer2()

        p1SetsLabel.text   = "\(match.p1Sets)"
        p2SetsLabel.text   = "\(match.p2Sets)"
        p1GamesLabel.text  = "\(match.currentSet.p1Games)"
        p2GamesLabel.text  = "\(match.currentSet.p2Games)"
        p1PointsLabel.text = match.currentSet.player1GameDisplay()
        p2PointsLabel.text = match.currentSet.player2GameDisplay()

        player1Button.isEnabled = !match.complete()
        player2Button.isEnabled = !match.complete()

        resetHighlights()
        applyPointHighlights()
        applyServingHighlight()
    }

    private func resetHighlights() {
        [p1NameLabel, p2NameLabel,
         p1SetsLabel, p2SetsLabel,
         p1GamesLabel, p2GamesLabel,
         p1PointsLabel, p2PointsLabel].forEach { $0?.backgroundColor = .clear }
    }

    private func applyPointHighlights() {
        if match.player1HasMatchPoint() { p1SetsLabel.backgroundColor   = .green }
        if match.player2HasMatchPoint() { p2SetsLabel.backgroundColor   = .green }
        if match.player1HasSetPoint()   { p1GamesLabel.backgroundColor  = .green }
        if match.player2HasSetPoint()   { p2GamesLabel.backgroundColor  = .green }
        if match.player1HasGamePoint()  { p1PointsLabel.backgroundColor = .green }
        if match.player2HasGamePoint()  { p2PointsLabel.backgroundColor = .green }
    }

    private func applyServingHighlight() {
        if match.complete() { return }
        if match.player1Serves() {
            p1NameLabel.backgroundColor = .purple
        } else {
            p2NameLabel.backgroundColor = .purple
        }
    }

    private func notifyIfNeeded(before: Match.Snapshot, winnerIfGame: String) {
        if !before.matchComplete && match.complete() {
            let winner = match.player1Won() ? "Player 1" : "Player 2"
            showAlert(title: "Match Over!", message: "\(winner) wins the match!")
        } else if match.p1Sets > before.p1Sets {
            showAlert(title: "Set Won!", message: "Player 1 wins the set!")
        } else if match.p2Sets > before.p2Sets {
            showAlert(title: "Set Won!", message: "Player 2 wins the set!")
        } else if match.currentSet.p1Games > before.currentSetP1Games {
            showAlert(title: "Game!", message: "Player 1 wins the game!")
        } else if match.currentSet.p2Games > before.currentSetP2Games {
            showAlert(title: "Game!", message: "Player 2 wins the game!")
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
