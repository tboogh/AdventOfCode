import AdventOfCode_2023
import XCTest

final class TestDay1: XCTestCase {

    func testPart1_intro() {
        let data = """
                   1abc2
                   pqr3stu8vwx
                   a1b2c3d4e5f
                   treb7uchet
                   """.components(separatedBy: "\n")

        let result = Day1.partOne(input: data)

        XCTAssertEqual(result, 142)
    }

    func testPart1_data() {
        let data = loadTestData(filename: "Day1")

        let result = Day1.partOne(input: data)

        XCTAssertEqual(result, 54877)
    }

    func testPart2_intro() {
        let data = """
                   two1nine
                   eightwothree
                   abcone2threexyz
                   xtwone3four
                   4nineeightseven2
                   zoneight234
                   7pqrstsixteen
                   """.components(separatedBy: "\n")

        let result = Day1.partTwo(input: data)

        XCTAssertEqual(result, 281)
    }

    func testPart2_errror() {
        let data = "vtrbqpv9sevenone1qlvmzkthnnsevenseven".components(separatedBy: "\n")
        let result = Day1.partTwo(input: data)

        XCTAssertEqual(result, 97)
    }

    func testPart2_data() {
        let data = loadTestData(filename: "Day1")
        let result = Day1.partTwo(input: data)

        XCTAssertEqual(result, 54100)
    }
}
