import XCTest
@testable import AdventOfCode_2021

final class TestDay1: XCTestCase {
    func testExamplePartOne() {
        let content = [
            199,
            200,
            208,
            210,
            200,
            207,
            240,
            269,
            260,
            263
        ]
        let day1 = DayOne()
        let result = day1.partOne(input: content)
        XCTAssertEqual(result, 7)
    }
    
    func testComputePartOne() {
        let testContent = loadTestData(filename: "Day1-1")
        let testData = testContent.compactMap { Int($0) }
        let day1 = DayOne()
        let result = day1.partOne(input: testData)
        XCTAssertEqual(result, 1548)
    }
    
    func testExamplePartTwo() {
        let content = [
            199,
            200,
            208,
            210,
            200,
            207,
            240,
            269,
            260,
            263
        ]
        let day1 = DayOne()
        let result = day1.partTwo(input: content)
        XCTAssertEqual(result, 5)
    }
    
    func testComputePartTwo() {
        let testContent = loadTestData(filename: "Day1-1")
        let testData = testContent.compactMap { Int($0) }
        let day1 = DayOne()
        let result = day1.partTwo(input: testData)
        XCTAssertEqual(result, 1589)
    }
}

