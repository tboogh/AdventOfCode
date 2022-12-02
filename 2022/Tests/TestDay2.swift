import AdventOfCode_2022
import XCTest

final class TestDay2: XCTestCase {

    func testPart1_intro() {
        let data = """
                    A Y
                    B X
                    C Z
                    """.components(separatedBy: "\n").filter { !$0.isEmpty }

        let game = Day2.Game()
        let rounds = game.roundsForInput(input: data)
        let result = game.totalScoreForRounds(rounds: rounds, rules: game.moveBeatsMoveRules)
        XCTAssertEqual(result, 15)
    }

    func testPart1_data() {
        let data = loadTestData(filename: "Day2")

        let game = Day2.Game()
        let rounds = game.roundsForInput(input: data)
        let result = game.totalScoreForRounds(rounds: rounds, rules: game.moveBeatsMoveRules)
        XCTAssertEqual(result, 13809)
    }

    func testPart2_intro() {
        let data = """
                    A Y
                    B X
                    C Z
                    """.components(separatedBy: "\n").filter { !$0.isEmpty }

        let game = Day2.Game()
        let rounds = game.roundForInput2(input: data)
        let result = game.totalScoreForRounds(rounds: rounds, rules: game.moveBeatsMoveRules)
        XCTAssertEqual(result, 12)
    }

    func testPart2_data() {
        let data = loadTestData(filename: "Day2")

        let game = Day2.Game()
        let rounds = game.roundForInput2(input: data)
        let result = game.totalScoreForRounds(rounds: rounds, rules: game.moveBeatsMoveRules)
        XCTAssertEqual(result, 12316)
    }
}
