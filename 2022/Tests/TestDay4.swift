import AdventOfCode_2022
import XCTest

final class TestDay4: XCTestCase {

    func testPart1_intro() {
        let data = """
                    2-4,6-8
                    2-3,4-5
                    5-7,7-9
                    2-8,3-7
                    6-6,4-6
                    2-6,4-8
                    """.components(separatedBy: "\n")

        let result = Day4.partOne(input: data)

        XCTAssertEqual(result, 2)
    }

    func testPart1_data() {
        let data = loadTestData(filename: "Day4")

        let result = Day4.partOne(input: data)

        XCTAssertEqual(result, 605)
    }

    func testPart2_intro() {
        let data = """
                    2-4,6-8
                    2-3,4-5
                    5-7,7-9
                    2-8,3-7
                    6-6,4-6
                    2-6,4-8
                    """.components(separatedBy: "\n")

        let result = Day4.partTwo(input: data)

        XCTAssertEqual(result, 4)
    }

    func testPart2_data() {
        let data = loadTestData(filename: "Day4")

        let result = Day4.partTwo(input: data)

        XCTAssertEqual(result, 914)
    }
}
