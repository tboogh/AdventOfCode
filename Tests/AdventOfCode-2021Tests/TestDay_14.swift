import XCTest
@testable import AdventOfCode_2021

final class TestDay_14: XCTestCase {

    func testExamplePartOne() {
        let input = """
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
"""
        let day = Day_14()
        let result = day.partOne(input: input)
        XCTAssertEqual(result, 1588)
    }

    func testComputePartOne() {
        let input = loadTest(filename: "Day14")
        let day = Day_14()
        let result = day.partOne(input: input)
        XCTAssertEqual(result, 2768)
    }

    func testExamplePartTwo() {
        let input = """
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
"""
        let day = Day_14()
        let result = day.partTwo(input: input)
        XCTAssertEqual(result, 2188189693529)
    }

    func testComputePartTwo() {

    }
}

