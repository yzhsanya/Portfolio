import XCTest

final class MatchTests: XCTestCase {

    private func winGameP1(_ set: Set) {
        for _ in 0..<4 { set.addPointToPlayer1() }
    }

    private func winGameP2(_ set: Set) {
        for _ in 0..<4 { set.addPointToPlayer2() }
    }

    private func winSetP1(_ match: Match, gamesLostByP2: Int = 0) {
        for _ in 0..<gamesLostByP2 { winGameP2(match.currentSet) }
        for _ in 0..<6 { match.addPointToPlayer1(); match.addPointToPlayer1(); match.addPointToPlayer1(); match.addPointToPlayer1() }
    }

    private func winSetP2(_ match: Match, gamesLostByP1: Int = 0) {
        for _ in 0..<gamesLostByP1 { winGameP1(match.currentSet) }
        for _ in 0..<6 { match.addPointToPlayer2(); match.addPointToPlayer2(); match.addPointToPlayer2(); match.addPointToPlayer2() }
    }

    private func winGameForPlayer1InMatch(_ match: Match) {
        for _ in 0..<4 { match.addPointToPlayer1() }
    }

    private func winGameForPlayer2InMatch(_ match: Match) {
        for _ in 0..<4 { match.addPointToPlayer2() }
    }

    private func winSetForPlayer1(_ match: Match) {
        for _ in 0..<6 { winGameForPlayer1InMatch(match) }
    }

    private func winSetForPlayer2(_ match: Match) {
        for _ in 0..<6 { winGameForPlayer2InMatch(match) }
    }

    private func reachTwelveAllInFinalSet(_ match: Match) {
        for _ in 0..<2 { winSetForPlayer1(match) }
        for _ in 0..<2 { winSetForPlayer2(match) }

        for _ in 0..<5 { winGameForPlayer1InMatch(match) }
        for _ in 0..<5 { winGameForPlayer2InMatch(match) }

        winGameForPlayer1InMatch(match)
        winGameForPlayer2InMatch(match)
        winGameForPlayer1InMatch(match)
        winGameForPlayer2InMatch(match)
        winGameForPlayer1InMatch(match)
        winGameForPlayer2InMatch(match)
        winGameForPlayer1InMatch(match)
        winGameForPlayer2InMatch(match)
        winGameForPlayer1InMatch(match)
        winGameForPlayer2InMatch(match)
        winGameForPlayer1InMatch(match)
        winGameForPlayer2InMatch(match)
        winGameForPlayer1InMatch(match)
        winGameForPlayer2InMatch(match) 
    }

    func testInitialMatchState() {
        let match = Match()

        XCTAssertEqual(match.p1Sets, 0)
        XCTAssertEqual(match.p2Sets, 0)
        XCTAssertFalse(match.complete())
        XCTAssertFalse(match.player1Won())
        XCTAssertFalse(match.player2Won())
        XCTAssertEqual(match.previousSetsForPlayer1(), "-")
        XCTAssertEqual(match.previousSetsForPlayer2(), "-")
        XCTAssertEqual(match.currentSet.p1Games, 0)
        XCTAssertEqual(match.currentSet.p2Games, 0)
    }

    func testPlayer1WinsMatchInStraightSets() {
        let match = Match()

        winSetForPlayer1(match)
        winSetForPlayer1(match)
        winSetForPlayer1(match)

        XCTAssertTrue(match.complete())
        XCTAssertTrue(match.player1Won())
        XCTAssertFalse(match.player2Won())
        XCTAssertEqual(match.p1Sets, 3)
        XCTAssertEqual(match.p2Sets, 0)
        XCTAssertEqual(match.previousSetsForPlayer1(), "6 6 6")
        XCTAssertEqual(match.previousSetsForPlayer2(), "0 0 0")
    }

    func testPlayer2WinsMatchInFiveSets() {
        let match = Match()

        winSetForPlayer1(match)
        winSetForPlayer2(match)
        winSetForPlayer1(match)
        winSetForPlayer2(match)
        winSetForPlayer2(match)

        XCTAssertTrue(match.complete())
        XCTAssertFalse(match.player1Won())
        XCTAssertTrue(match.player2Won())
        XCTAssertEqual(match.p1Sets, 2)
        XCTAssertEqual(match.p2Sets, 3)
    }

    func testNewSetStartsAfterCompletedSet() {
        let match = Match()

        winSetForPlayer1(match)

        XCTAssertEqual(match.p1Sets, 1)
        XCTAssertEqual(match.p2Sets, 0)
        XCTAssertEqual(match.currentSet.p1Games, 0)
        XCTAssertEqual(match.currentSet.p2Games, 0)
        XCTAssertEqual(match.currentSet.player1GameDisplay(), "0")
        XCTAssertEqual(match.currentSet.player2GameDisplay(), "0")
    }

    func testNoFurtherPointsAfterMatchComplete() {
        let match = Match()

        winSetForPlayer1(match)
        winSetForPlayer1(match)
        winSetForPlayer1(match)

        XCTAssertTrue(match.complete())

        let previousP1Sets = match.p1Sets
        let previousP2Sets = match.p2Sets
        let prevSetsP1 = match.previousSetsForPlayer1()
        let prevSetsP2 = match.previousSetsForPlayer2()

        for _ in 0..<20 {
            match.addPointToPlayer1()
            match.addPointToPlayer2()
        }

        XCTAssertEqual(match.p1Sets, previousP1Sets)
        XCTAssertEqual(match.p2Sets, previousP2Sets)
        XCTAssertEqual(match.previousSetsForPlayer1(), prevSetsP1)
        XCTAssertEqual(match.previousSetsForPlayer2(), prevSetsP2)
    }

    func testFinalSetDoesNotTieBreakAtSixAll() {
        let match = Match()

        winSetForPlayer1(match)
        winSetForPlayer2(match)
        winSetForPlayer1(match)
        winSetForPlayer2(match)

        for _ in 0..<5 { winGameForPlayer1InMatch(match) }
        for _ in 0..<5 { winGameForPlayer2InMatch(match) }
        winGameForPlayer1InMatch(match)
        winGameForPlayer2InMatch(match)

        XCTAssertEqual(match.currentSet.p1Games, 6)
        XCTAssertEqual(match.currentSet.p2Games, 6)
        XCTAssertFalse(match.currentSet.isTieBreakActive())
        XCTAssertFalse(match.currentSet.complete())
    }

    func testFinalSetTieBreakStartsAtTwelveAll() {
        let match = Match()

        reachTwelveAllInFinalSet(match)

        XCTAssertEqual(match.currentSet.p1Games, 12)
        XCTAssertEqual(match.currentSet.p2Games, 12)
        XCTAssertTrue(match.currentSet.isTieBreakActive())
        XCTAssertFalse(match.currentSet.complete())
    }
}
