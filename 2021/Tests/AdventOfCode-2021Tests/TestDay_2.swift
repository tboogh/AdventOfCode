import XCTest
@testable import AdventOfCode_2021

final class TestDay_2: XCTestCase {
    func testExamplePartOne() {
        let input = [
            "forward 5",
            "down 5",
            "forward 8",
            "up 3",
            "down 8",
            "forward 2"
        ]

        let day = Day_2()
        let result = day.partOne(input: input)
        XCTAssertEqual(result, 150)
    }

    func testComputePartOne() {
        let input = loadTestData(filename: "Day2")

        let day = Day_2()
        let result = day.partOne(input: input)
        XCTAssertEqual(result, 1561344)
    }

    func testExamplePartTwo() {
        let input = [
            "forward 5",
            "down 5",
            "forward 8",
            "up 3",
            "down 8",
            "forward 2"
        ]

        let day = Day_2()
        let result = day.partTwo(input: input)
        XCTAssertEqual(result, 900)
    }

    func testComputePartTwo() {
        let input = loadTestData(filename: "Day2")

        let day = Day_2()
        let result = day.partTwo(input: input)
        XCTAssertEqual(result, 1848454425)
    }
}

