import AdventOfCode_2022
import XCTest

final class TestDay9: XCTestCase {

    func testPart1_intro() {
        let data = """
                   R 4
                   U 4
                   L 3
                   D 1
                   R 4
                   D 1
                   L 5
                   R 2
                   """.components(separatedBy: "\n")

        let result = Day9.partOne(input: data, printPositions: true)

        XCTAssertEqual(result, 13)
    }

    func testPart1_data() {
        let data = loadTestData(filename: "Day9")

        let result = Day9.partOne(input: data)

        XCTAssertEqual(result, 6354)
    }

    func testPart2_intro() {
        let data = """
                   R 5
                   U 8
                   L 8
                   D 3
                   R 17
                   D 10
                   L 25
                   U 20
                   """.components(separatedBy: "\n")

        let result = Day9.partTwo(input: data, printPositions: true)

        XCTAssertEqual(result, 36)
    }

    func testPart2_data() {
        let data = loadTestData(filename: "Day9")

        let result = Day9.partTwo(input: data)

        XCTAssertEqual(result, 2651)
    }
}
