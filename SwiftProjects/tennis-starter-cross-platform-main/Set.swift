import Foundation

final class Set: ObservableObject {

    @Published private(set) var p1Games = 0
    @Published private(set) var p2Games = 0

    private(set) var currentGame = Game()
    private(set) var tieBreak: TieBreak? = nil

    private let tieBreakAtGames: Int

    init(tieBreakAtGames: Int = 6) {
        self.tieBreakAtGames = tieBreakAtGames
    }

    func addPointToPlayer1() {
        addPoint(
            tbAdd: { $0.addPointToPlayer1() },
            gameAdd: { $0.addPointToPlayer1() }
        )
    }

    func addPointToPlayer2() {
        addPoint(
            tbAdd: { $0.addPointToPlayer2() },
            gameAdd: { $0.addPointToPlayer2() }
        )
    }

    private func addPoint(
        tbAdd: (TieBreak) -> Void,
        gameAdd: (Game) -> Void
    ) {
        if complete() { return }

        if let tb = tieBreak {
            tbAdd(tb)
            if tb.complete() { finishTieBreak() }
            return
        }

        gameAdd(currentGame)
        if currentGame.complete() {
            finishGame(winnerIsP1: currentGame.player1Won())
        }
    }

    func player1Won() -> Bool { computeSetWinner(p1: p1Games, p2: p2Games) == 1 }
    func player2Won() -> Bool { computeSetWinner(p1: p1Games, p2: p2Games) == 2 }
    func complete() -> Bool { computeSetWinner(p1: p1Games, p2: p2Games) != 0 }

    func player1GameDisplay() -> String {
        if let tb = tieBreak { return tb.player1Score() }
        return currentGame.player1Score()
    }

    func player2GameDisplay() -> String {
        if let tb = tieBreak { return tb.player2Score() }
        return currentGame.player2Score()
    }

    func isTieBreakActive() -> Bool { tieBreak != nil }

    private func finishGame(winnerIsP1: Bool) {
        if winnerIsP1 {
            p1Games += 1
        } else {
            p2Games += 1
        }

        if p1Games == tieBreakAtGames && p2Games == tieBreakAtGames {
            tieBreak = TieBreak()
            currentGame = Game()
            return
        }

        if !complete() {
            currentGame = Game()
        }
    }

    private func finishTieBreak() {
        guard let tb = tieBreak else { return }

        if tb.player1Won() {
            p1Games += 1
        } else {
            p2Games += 1
        }

        tieBreak = nil
        currentGame = Game()
    }

    func player1HasGamePoint() -> Bool {
        if complete() { return false }
        if let tb = tieBreak { return tb.player1WouldWinNextPoint() }
        return currentGame.gamePointsForPlayer1() > 0
    }

    func player2HasGamePoint() -> Bool {
        if complete() { return false }
        if let tb = tieBreak { return tb.player2WouldWinNextPoint() }
        return currentGame.gamePointsForPlayer2() > 0
    }

    func player1HasSetPoint() -> Bool {
        if complete() { return false }
        if let tb = tieBreak { return tb.player1WouldWinNextPoint() }
        guard currentGame.gamePointsForPlayer1() > 0 else { return false }
        return computeSetWinner(p1: p1Games + 1, p2: p2Games) == 1
    }

    func player2HasSetPoint() -> Bool {
        if complete() { return false }
        if let tb = tieBreak { return tb.player2WouldWinNextPoint() }
        guard currentGame.gamePointsForPlayer2() > 0 else { return false }
        return computeSetWinner(p1: p1Games, p2: p2Games + 1) == 2
    }

    private func computeSetWinner(p1: Int, p2: Int) -> Int {
        let diff = p1 - p2
        if abs(diff) >= 2 {
            if p1 >= 6 { return 1 }
            if p2 >= 6 { return 2 }
        }
        if p1 == tieBreakAtGames + 1 && p2 == tieBreakAtGames { return 1 }
        if p2 == tieBreakAtGames + 1 && p1 == tieBreakAtGames { return 2 }
        return 0
    }
}
