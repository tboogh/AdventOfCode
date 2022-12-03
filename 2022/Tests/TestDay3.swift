import AdventOfCode_2022
import XCTest

final class TestDay3: XCTestCase {

    func testPart1_intro() {
        let data = """
                    vJrwpWtwJgWrhcsFMMfFFhFp
                    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
                    PmmdzqPrVvPwwTWBwg
                    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
                    ttgJtRGJQctTZtZT
                    CrZsJsPPZsGzwwsLwLmpwMDw
                    """.components(separatedBy: "\n")

        let result = Day3.partOne(input: data)

        XCTAssertEqual(result, 157)
    }

    func testPart1_data() {
        let data = loadTestData(filename: "Day3")

        let result = Day3.partOne(input: data)

        XCTAssertEqual(result, 7716)
    }

    func testPart2_intro() {
        let data = """
                    vJrwpWtwJgWrhcsFMMfFFhFp
                    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
                    PmmdzqPrVvPwwTWBwg
                    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
                    ttgJtRGJQctTZtZT
                    CrZsJsPPZsGzwwsLwLmpwMDw
                    """.components(separatedBy: "\n")

        let result = Day3.partTwo(input: data)

        XCTAssertEqual(result, 70)
    }

    func testPart2_data() {
        let data = loadTestData(filename: "Day3")

        let result = Day3.partTwo(input: data)

        XCTAssertEqual(result, 2973)
    }
}
