import XCTest
@testable import AdventOfCode_2021

final class TestDay_11: XCTestCase {

    func testPartOne() {
        let input = """
11111
19991
19191
19991
11111
"""
        let day = Day_11()
        let result = day.partOne(input: input)
        XCTAssertEqual(result, 0)
    }

    func testExamplePartOne() {
        let input = """
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
"""
        let day = Day_11()
        let result = day.partOne(input: input, iterations: 100)
        XCTAssertEqual(result, 1656)
    }

    func testComputePartOne() {
        let input = loadTest(filename: "Day11")
        let day = Day_11()
        let result = day.partOne(input: input, iterations: 100)
        XCTAssertEqual(result, 1673)
    }

    func testExamplePartTwo() {
        let input = """
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
"""
        let day = Day_11()
        let result = day.partTwo(input: input)
        XCTAssertEqual(result, 195)
    }

    func testComputePartTwo() {
        let input = loadTest(filename: "Day11")
        let day = Day_11()
        let result = day.partTwo(input: input)
        XCTAssertEqual(result, 279)
    }
}

