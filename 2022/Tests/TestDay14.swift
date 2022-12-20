import AdventOfCode_2022
import XCTest

final class TestDay14: XCTestCase {
    let sampleData = """
498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9
"""

    func testPart1_intro() {
        let result = Day14.partOne(input: sampleData)

        XCTAssertEqual(result, 24)
    }

    func testPart1_data() {
        let data = loadTest(filename: "Day14")

        let result = Day14.partOne(input: data)

        XCTAssertEqual(result, 719)
    }

    func testPart2_intro() {
        let result = Day14.partTwo(input: sampleData)

        XCTAssertEqual(result, 93)
    }

    func testPart2_data() {
        let data = loadTest(filename: "Day14")

        let result = Day14.partTwo(input: data)

        XCTAssertEqual(result, 23390)
    }
}
