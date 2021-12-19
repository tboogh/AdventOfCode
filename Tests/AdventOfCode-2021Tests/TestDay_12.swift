import XCTest
@testable import AdventOfCode_2021

final class TestDay_12: XCTestCase {

    func testExamplePartOne() {
        let input = """
start-A
start-b
A-c
A-b
b-d
A-end
b-end
"""
        let day = Day_12()
        let result = day.partOne(input: input)
        XCTAssertEqual(result, 10)
    }

    func testExampleAdvancedPartOne() {
        let input = """
dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc
"""
        let day = Day_12()
        let result = day.partOne(input: input)
        XCTAssertEqual(result, 19)
    }

    func testComputePartOne() {

    }

    func testExamplePartTwo() {

    }

    func testComputePartTwo() {

    }
}

