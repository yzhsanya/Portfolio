import Foundation

final class TieBreak: ObservableObject {

    @Published private(set) var p1Points = 0
    @Published private(set) var p2Points = 0

    func addPointToPlayer1() {
        guard !complete() else { return }
        p1Points += 1
    }

    func addPointToPlayer2() {
        guard !complete() else { return }
        p2Points += 1
    }

    func player1Won() -> Bool { hasWon(points: p1Points, opponent: p2Points) }
    func player2Won() -> Bool { hasWon(points: p2Points, opponent: p1Points) }
    func complete() -> Bool { player1Won() || player2Won() }

    func player1Score() -> String { complete() ? "" : "\(p1Points)" }
    func player2Score() -> String { complete() ? "" : "\(p2Points)" }

    func player1WouldWinNextPoint() -> Bool { !complete() && hasWon(points: p1Points + 1, opponent: p2Points) }
    func player2WouldWinNextPoint() -> Bool { !complete() && hasWon(points: p2Points + 1, opponent: p1Points) }

    private func hasWon(points: Int, opponent: Int) -> Bool {
        points >= 7 && (points - opponent) >= 2
    }
}

