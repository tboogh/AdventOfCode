import XCTest
@testable import AdventOfCode_2021

final class TestDay_9: XCTestCase {

    func testExamplePartOne() {
        let input = """
2199943210
3987894921
9856789892
8767896789
9899965678

"""
        let day = Day_9()
        let result = day.partOne(input: input)
        XCTAssertEqual(result, 15)
    }

    func testComputePartOne() {
        let input = loadTest(filename: "Day9")
        let day = Day_9()
        let result = day.partOne(input: input)
        XCTAssertEqual(result, 539)
    }

    func testExamplePartTwo() {
        let input = """
2199943210
3987894921
9856789892
8767896789
9899965678

"""
        let day = Day_9()
        let result = day.partTwo(input: input)
        XCTAssertEqual(result, 1134)
    }

    func testComputePartTwo() {
        let input = loadTest(filename: "Day9")
        let day = Day_9()
        let result = day.partTwo(input: input)
        XCTAssertEqual(result, 736920)
    }
}

