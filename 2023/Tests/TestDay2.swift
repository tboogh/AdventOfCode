import AdventOfCode_2023
import XCTest

final class TestDay2: XCTestCase {

    func testPart1_intro() {
        let data = """
                   Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
                   Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
                   Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
                   Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
                   Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
                   """.components(separatedBy: "\n")

        let result = Day2.partOne(input: data)

        XCTAssertEqual(result, 8)
    }

    func testPart1_data() {
        let data = loadTestData(filename: "Day2")

        let result = Day2.partOne(input: data)

        XCTAssertEqual(result, 2268)
    }

    func testPart2_intro() {
        let data = """
                   Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
                   Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
                   Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
                   Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
                   Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
                   """.components(separatedBy: "\n")

        let result = Day2.partTwo(input: data)

        XCTAssertEqual(result, 2286)
    }

    func testPart2_data() {
        let data = loadTestData(filename: "Day2")

        let result = Day2.partTwo(input: data)

        XCTAssertEqual(result, 63542)
    }
}
