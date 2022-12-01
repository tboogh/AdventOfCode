import XCTest
@testable import AdventOfCode_2021

final class TestDay_7: XCTestCase {

    func testExamplePartOne() {
        let input = "16,1,2,0,4,2,7,1,2,14"
        let day = Day_7()
        let result = day.partOne(input: input)
        XCTAssertEqual(result, 37)
    }

    func testComputePartOne() {
        let input = loadTest(filename: "Day7").trimmingCharacters(in: .newlines)
        let day = Day_7()
        let result = day.partOne(input: input)
        XCTAssertEqual(result, 337488)
    }

    func testExamplePartTwo() {
        let input = "16,1,2,0,4,2,7,1,2,14"
        let day = Day_7()
        let result = day.partTwo(input: input)
        XCTAssertEqual(result, 168)
    }

    func testComputePartTwo() {
        let input = loadTest(filename: "Day7").trimmingCharacters(in: .newlines)
        let day = Day_7()
        let result = day.partTwo(input: input)
        XCTAssertEqual(result, 89647695)
    }
}

