import XCTest
@testable import AdventOfCode_2021

final class TestDay_6: XCTestCase {

    func testExamplePartOne() {
        let input = "3,4,3,1,2"
        let day = Day_6()
        let result = day.partOne(input: input, days: 80)
        XCTAssertEqual(result, 5934)
    }

    func testComputePartOne() {
        let input = loadTest(filename: "Day6").trimmingCharacters(in: .newlines)
        let day = Day_6()
        let result = day.partTwo(input: input, days: 80)
        XCTAssertEqual(result, 361169)
    }

    func testExamplePartTwo() {
        let input = "3,4,3,1,2"
        let day = Day_6()
        let result = day.partTwo(input: input, days: 4)
        XCTAssertEqual(result, 9)
    }

    func testComputePartTwo() {
        let input = loadTest(filename: "Day6").trimmingCharacters(in: .newlines)
        let day = Day_6()
        let result = day.partTwo(input: input, days: 256)
        XCTAssertEqual(result, 1634946868992)
    }
}

