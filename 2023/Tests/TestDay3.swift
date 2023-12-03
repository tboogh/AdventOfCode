import AdventOfCode_2023
import XCTest

final class TestDay3: XCTestCase {

    func testPart1_intro() {
        let data = """
                   467..114..
                   ...*......
                   ..35...633
                   .........#
                   617*......
                   .....+.58.
                   ..592.....
                   ......755.
                   ...$.*....
                   .664.598..
                   """.components(separatedBy: "\n")

        let result = Day3.partOne(input: data)

        XCTAssertEqual(result, 4361)
    }

    func testPart1_data() {
        let data = loadTestData(filename: "Day3")

        let result = Day3.partOne(input: data)

        XCTAssertNotEqual(result, 9743964)
        XCTAssertNotEqual(result, 517866)
        XCTAssertEqual(result, 520135)
    }

    func testPart2_intro() {
        let data = """
                   467..114..
                   ...*......
                   ..35...633
                   .........#
                   617*......
                   .....+.58.
                   ..592.....
                   ......755.
                   ...$.*....
                   .664.598..
                   """.components(separatedBy: "\n")

        let result = Day3.partTwo(input: data)

        XCTAssertEqual(result, 467835)
    }

    func testPart2_data() {
        let data = loadTestData(filename: "Day3")

        let result = Day3.partTwo(input: data)

        XCTAssertEqual(result, 72514855)
    }
}
