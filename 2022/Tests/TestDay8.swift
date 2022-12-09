import AdventOfCode_2022
import XCTest

final class TestDay8: XCTestCase {

    func testPart1_intro() {
        let data = """
                   30373
                   25512
                   65332
                   33549
                   35390
                   """.components(separatedBy: "\n")
        let result = Day8.partOne(input: data)

        XCTAssertEqual(result, 21)
    }

    func testPart1_data() {
        let data = loadTestData(filename: "Day8")

        let result = Day8.partOne(input: data)

        XCTAssertEqual(result, 1798)
    }

    func testPart2_intro() {
        let data = """
                   30373
                   25512
                   65332
                   33549
                   35390
                   """.components(separatedBy: "\n")

        let result = Day8.partTwo(input: data)

        XCTAssertEqual(result, 8)
    }

    func testPart2_data() {
        let data = loadTestData(filename: "Day8")

        let result = Day8.partTwo(input: data)

        XCTAssertEqual(result, 259308)
    }
}
