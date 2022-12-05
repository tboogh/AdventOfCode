import AdventOfCode_2022
import XCTest

final class TestDay5: XCTestCase {

    func testPart1_intro() {
        let data = """
                       [D]
                   [N] [C]
                   [Z] [M] [P]
                    1   2   3

                   move 1 from 2 to 1
                   move 3 from 1 to 3
                   move 2 from 2 to 1
                   move 1 from 1 to 2
                   """

        let result = Day5.partOne(input: data)

        XCTAssertEqual(result, "CMZ")
    }

    func testPart1_data() {
        let data = loadTest(filename: "Day5")

        let result = Day5.partOne(input: data)

        XCTAssertEqual(result, "VGBBJCRMN")
    }

    func testPart2_intro() {
        let data = """
                       [D]
                   [N] [C]
                   [Z] [M] [P]
                    1   2   3

                   move 1 from 2 to 1
                   move 3 from 1 to 3
                   move 2 from 2 to 1
                   move 1 from 1 to 2
                   """

        let result = Day5.partTwo(input: data)

        XCTAssertEqual(result, "MCD")
    }

    func testPart2_data() {
        let data = loadTest(filename: "Day5")

        let result = Day5.partTwo(input: data)

        XCTAssertEqual(result, "LBBVJBRMH")
    }
}
