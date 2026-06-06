import Foundation

final class Match: ObservableObject {

    @Published private(set) var p1Sets = 0
    @Published private(set) var p2Sets = 0

    private(set) var previousSetScores: [(Int, Int)] = []
    private(set) var currentSet = Set()

    struct Snapshot {
        let p1Sets: Int
        let p2Sets: Int
        let currentSetP1Games: Int
        let currentSetP2Games: Int
        let matchComplete: Bool
    }

    func uiSnapshot() -> Snapshot {
        Snapshot(
            p1Sets: p1Sets,
            p2Sets: p2Sets,
            currentSetP1Games: currentSet.p1Games,
            currentSetP2Games: currentSet.p2Games,
            matchComplete: complete()
        )
    }

    func addPointToPlayer1() {
        if complete() { return }
        objectWillChange.send()
        currentSet.addPointToPlayer1()

        if currentSet.complete() {
            finishCurrentSet()
        }
    }

    func addPointToPlayer2() {
        if complete() { return }
        objectWillChange.send()
        currentSet.addPointToPlayer2()

        if currentSet.complete() {
            finishCurrentSet()
        }
    }

    func reset() {
        objectWillChange.send()
        p1Sets = 0
        p2Sets = 0
        previousSetScores = []
        currentSet = Set()
    }

    func player1Won() -> Bool { p1Sets == 3 }
    func player2Won() -> Bool { p2Sets == 3 }
    func complete() -> Bool { player1Won() || player2Won() }

    func player1HasGamePoint() -> Bool { !complete() && currentSet.player1HasGamePoint() }
    func player2HasGamePoint() -> Bool { !complete() && currentSet.player2HasGamePoint() }
    func player1HasSetPoint()  -> Bool { !complete() && currentSet.player1HasSetPoint() }
    func player2HasSetPoint()  -> Bool { !complete() && currentSet.player2HasSetPoint() }

    func player1HasMatchPoint() -> Bool { !complete() && p1Sets == 2 && currentSet.player1HasSetPoint() }
    func player2HasMatchPoint() -> Bool { !complete() && p2Sets == 2 && currentSet.player2HasSetPoint() }
    func player1Serves() -> Bool {
        let gamesPlayed =
        previousSetScores.reduce(0) { $0 + $1.0 + $1.1 }
                        + currentSet.p1Games + currentSet.p2Games
        let p1IsInitialServer = gamesPlayed % 2 == 0

        guard currentSet.isTieBreakActive(), let tb = currentSet.tieBreak else {
            return p1IsInitialServer
        }

        let pointsPlayed = tb.p1Points + tb.p2Points
        if pointsPlayed == 0 { return p1IsInitialServer }
        let blockIndex = (pointsPlayed - 1) / 2
        return blockIndex % 2 == 0 ? !p1IsInitialServer : p1IsInitialServer
    }

    func previousSetsForPlayer1() -> String {
        if previousSetScores.isEmpty { return "-" }
        return previousSetScores.map { String($0.0) }.joined(separator: " ")
    }

    func previousSetsForPlayer2() -> String {
        if previousSetScores.isEmpty { return "-" }
        return previousSetScores.map { String($0.1) }.joined(separator: " ")
    }

    private func finishCurrentSet() {
        previousSetScores.append((currentSet.p1Games, currentSet.p2Games))

        if currentSet.player1Won() {
            p1Sets += 1
        } else if currentSet.player2Won() {
            p2Sets += 1
        }

        if !complete() {
            currentSet = nextSet()
        }
    }

    private func nextSet() -> Set {
        let setsPlayed = p1Sets + p2Sets
        let isFinalSet = setsPlayed == 4
        return isFinalSet ? Set(tieBreakAtGames: 12) : Set()
    }
}
