import XCTest
@testable import AdventOfCode_2021

final class TestDay_3: XCTestCase {

    func testExamplePartOne() {
        let input = [
            "00100",
            "11110",
            "10110",
            "10111",
            "10101",
            "01111",
            "00111",
            "11100",
            "10000",
            "11001",
            "00010",
            "01010"
        ]
        let day = Day_3()
        let result = day.partOne(input: input)
        XCTAssertEqual(result, 198)
    }

    func testComputePartOne() {
        let input = loadTestData(filename: "Day3")
        let day = Day_3()
        let result = day.partOne(input: input)
        XCTAssertEqual(result, 1071734)
    }

    func testExamplePartTwo() {

    }

    func testComputePartTwo() {

    }
}

