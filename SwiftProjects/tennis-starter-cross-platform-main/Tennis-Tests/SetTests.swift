import XCTest

final class SetTests: XCTestCase {

    private var set: Set!
    
    override func setUp() {
        super.setUp()
        set = Set()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    private func winGameP1(_ set: Set) {
        for _ in 0..<4 { set.addPointToPlayer1() }
    }

    private func winGameP2(_ set: Set) {
        for _ in 0..<4 { set.addPointToPlayer2() }
    }
    
    private func reachSixAll(_ set: Set) {
        for _ in 0..<5 { winGameP1(set) } 
        for _ in 0..<5 { winGameP2(set) }
        winGameP1(set)
        winGameP2(set)
    }

    func testInitialState() {
        XCTAssertEqual(set.p1Games, 0)
        XCTAssertEqual(set.p2Games, 0)
        XCTAssertFalse(set.complete())
        XCTAssertFalse(set.player1Won())
        XCTAssertFalse(set.player2Won())
        XCTAssertFalse(set.isTieBreakActive())
        XCTAssertEqual(set.player1GameDisplay(), "0")
        XCTAssertEqual(set.player2GameDisplay(), "0")
    }

    func testGameRollsOverAfterWin() {
    
        winGameP1(set)
        XCTAssertEqual(set.p1Games, 1)
        XCTAssertEqual(set.p2Games, 0)
        XCTAssertEqual(set.player1GameDisplay(), "0")
        XCTAssertEqual(set.player2GameDisplay(), "0")
        XCTAssertFalse(set.complete())
    }

    func testSetWinSixZero() {
        for _ in 0..<6 { winGameP1(set) }
        XCTAssertTrue(set.complete())
        XCTAssertTrue(set.player1Won())
        XCTAssertFalse(set.player2Won())
        XCTAssertEqual(set.p1Games, 6)
        XCTAssertEqual(set.p2Games, 0)
    }

    func testSetNotWonAtSixFive() {
        for _ in 0..<5 { winGameP1(set) }
        for _ in 0..<5 { winGameP2(set) }
        winGameP1(set)
        XCTAssertFalse(set.complete())
        XCTAssertFalse(set.player1Won())
        XCTAssertFalse(set.player2Won())
        XCTAssertEqual(set.p1Games, 6)
        XCTAssertEqual(set.p2Games, 5)
    }

    func testSetWinSevenFive() {
        for _ in 0..<5 { winGameP1(set) }
        for _ in 0..<5 { winGameP2(set) }
        winGameP1(set)
        winGameP1(set)
        XCTAssertTrue(set.complete())
        XCTAssertTrue(set.player1Won())
        XCTAssertEqual(set.p1Games, 7)
        XCTAssertEqual(set.p2Games, 5)
    }

    func testTieBreakStartsAtSixAll() {
        reachSixAll(set)
        XCTAssertEqual(set.p1Games, 6)
        XCTAssertEqual(set.p2Games, 6)
        XCTAssertTrue(set.isTieBreakActive())
        XCTAssertFalse(set.complete())
        XCTAssertEqual(set.player1GameDisplay(), "0")
        XCTAssertEqual(set.player2GameDisplay(), "0")
    }

    func testTieBreakWinMakesSetSevenSixForP1() {
        reachSixAll(set)
        for _ in 0..<7 { set.addPointToPlayer1() }
        XCTAssertTrue(set.complete())
        XCTAssertTrue(set.player1Won())
        XCTAssertEqual(set.p1Games, 7)
        XCTAssertEqual(set.p2Games, 6)
        XCTAssertFalse(set.isTieBreakActive())
    }

    func testTieBreakWinMakesSetSevenSixForP2() {
        reachSixAll(set)
        for _ in 0..<7 { set.addPointToPlayer2() }
        XCTAssertTrue(set.complete())
        XCTAssertTrue(set.player2Won())
        XCTAssertEqual(set.p1Games, 6)
        XCTAssertEqual(set.p2Games, 7)
        XCTAssertFalse(set.isTieBreakActive())
    }

    func testTieBreakRequiresTwoPointLead() {
        reachSixAll(set)
        for _ in 0..<6 { set.addPointToPlayer1() }
        for _ in 0..<6 { set.addPointToPlayer2() }
        XCTAssertFalse(set.complete())
        set.addPointToPlayer1()
        XCTAssertFalse(set.complete())
        set.addPointToPlayer1() 
        XCTAssertTrue(set.complete())
        XCTAssertTrue(set.player1Won())
        XCTAssertEqual(set.p1Games, 7)
        XCTAssertEqual(set.p2Games, 6)
    }

    func testNoFurtherPointsAfterSetComplete() {
        for _ in 0..<6 { winGameP1(set) }
        XCTAssertTrue(set.complete())
        let p1Games = set.p1Games
        let p2Games = set.p2Games
        let p1Display = set.player1GameDisplay()
        let p2Display = set.player2GameDisplay()
        for _ in 0..<10 {
            set.addPointToPlayer1()
            set.addPointToPlayer2()
        }
        XCTAssertEqual(set.p1Games, p1Games)
        XCTAssertEqual(set.p2Games, p2Games)
        XCTAssertEqual(set.player1GameDisplay(), p1Display)
        XCTAssertEqual(set.player2GameDisplay(), p2Display)
    }
}
