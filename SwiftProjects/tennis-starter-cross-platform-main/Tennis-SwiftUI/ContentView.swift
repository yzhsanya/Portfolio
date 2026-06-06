import SwiftUI

struct ContentView: View {
    @StateObject private var match = Match()

    var body: some View {
        VStack {
            HStack {
                Button("Restart") {
                    match.reset()
                }.padding()
                Spacer()
            }
            TennisScoreboardView(match: match)
        }
    }
}

struct TennisScoreboardView: View {
    @ObservedObject var match: Match

    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Text("Set Scores")
                    .frame(width: 100, alignment: .center)
                Text("Player")
                    .frame(width: 80, alignment: .leading)
                Text("Sets")
                    .frame(width: 50, alignment: .center)
                Text("Games")
                    .frame(width: 60, alignment: .center)
                Text("Points")
                    .frame(width: 60, alignment: .center)
            }

            // Player 1 Row
            HStack {
                Text(match.previousSetsForPlayer1())
                    .frame(width: 100, alignment: .center)
                Text("Player 1")
                    .frame(width: 80, alignment: .center)
                    .background(servingBackground(forP1: true))
                Text("\(match.p1Sets)")
                    .frame(width: 50, alignment: .center)
                    .background(match.player1HasMatchPoint() ? Color.green : Color.clear)
                Text("\(match.currentSet.p1Games)")
                    .frame(width: 60, alignment: .center)
                    .background(match.player1HasSetPoint() ? Color.green : Color.clear)
                Text(match.currentSet.player1GameDisplay())
                    .frame(width: 60, alignment: .center)
                    .background(match.player1HasGamePoint() ? Color.green : Color.clear)
            }

            // Player 2 Row
            HStack {
                Text(match.previousSetsForPlayer2())
                    .frame(width: 100, alignment: .center)
                Text("Player 2")
                    .frame(width: 80, alignment: .center)
                    .background(servingBackground(forP1: false))
                Text("\(match.p2Sets)")
                    .frame(width: 50, alignment: .center)
                    .background(match.player2HasMatchPoint() ? Color.green : Color.clear)
                Text("\(match.currentSet.p2Games)")
                    .frame(width: 60, alignment: .center)
                    .background(match.player2HasSetPoint() ? Color.green : Color.clear)
                Text(match.currentSet.player2GameDisplay())
                    .frame(width: 60, alignment: .center)
                    .background(match.player2HasGamePoint() ? Color.green : Color.clear)
            }
        }
        .padding()

        Spacer()

        HStack {
            Button("Player 1") {
                addPoint(for: 1)
            }
            .padding(.leading, 32.0)
            .buttonStyle(.borderedProminent)
            .disabled(match.complete())

            Spacer()

            Button("Player 2") {
                addPoint(for: 2)
            }
            .padding(.trailing, 32.0)
            .buttonStyle(.borderedProminent)
            .disabled(match.complete())
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }

    private func servingBackground(forP1: Bool) -> Color {
        guard !match.complete() else { return .clear }
        return (match.player1Serves() == forP1) ? .purple : .clear
    }

    

    private func addPoint(for player: Int) {
        let snapshot = match.uiSnapshot()
        if player == 1 { match.addPointToPlayer1() } else { match.addPointToPlayer2() }
        checkForAlert(before: snapshot)
    }

    private func checkForAlert(before: Match.Snapshot) {
        if !before.matchComplete && match.complete() {
            alertTitle   = "Match Over!"
            alertMessage = "\(match.player1Won() ? "Player 1" : "Player 2") wins the match!"
            showAlert    = true
        } else if match.p1Sets > before.p1Sets {
            alertTitle   = "Set Won!"
            alertMessage = "Player 1 wins the set!"
            showAlert    = true
        } else if match.p2Sets > before.p2Sets {
            alertTitle   = "Set Won!"
            alertMessage = "Player 2 wins the set!"
            showAlert    = true
        } else if match.currentSet.p1Games > before.currentSetP1Games {
            alertTitle   = "Game!"
            alertMessage = "Player 1 wins the game!"
            showAlert    = true
        } else if match.currentSet.p2Games > before.currentSetP2Games {
            alertTitle   = "Game!"
            alertMessage = "Player 2 wins the game!"
            showAlert    = true
        }
    }
}

#Preview {
    ContentView()
}

#Preview("Scoreboard") {
    TennisScoreboardView(match: Match())
}
