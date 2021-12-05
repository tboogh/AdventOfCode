import XCTest
@testable import AdventOfCode_2021

final class TestDay_5: XCTestCase {

    func testExamplePartOne() {
        let input = """
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
"""
    
        let day = Day_5(input: input)
        let result = day.partOne()
        XCTAssertEqual(result, 5)
    }

    func testComputePartOne() {
        let input = loadTest(filename: "Day5")
        let day = Day_5(input: input)
        let result = day.partOne()
        XCTAssertEqual(result, 4873)
    }

    func testExamplePartTwo() {

    }

    func testComputePartTwo() {

    }
}

