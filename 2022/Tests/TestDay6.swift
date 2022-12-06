import AdventOfCode_2022
import XCTest

final class TestDay6: XCTestCase {

    func testPart1_intro() {
        let testData: [
            (data: String, expected: Int)] = [
                ("mjqjpqmgbljsphdztnvjfqwrcgsmlb", 7),
                ("bvwbjplbgvbhsrlpgdmjqwftvncz", 5),
                ("nppdvjthqldpwncqszvftbrmjlhg", 6),
                ("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", 10),
                ("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", 11),
            ]

        for data in testData {
            let result = Day6.partOne(input: data.data)
            XCTAssertEqual(result, data.expected, data.data)
        }
    }

    func testPart1_data() {
        let data = loadTest(filename: "Day6")

        let result = Day6.partOne(input: data)

        XCTAssertEqual(result, 1651)
    }

    func testPart2_intro() {
        let testData: [
            (data: String, expected: Int)] = [
                ("mjqjpqmgbljsphdztnvjfqwrcgsmlb", 19),
                ("bvwbjplbgvbhsrlpgdmjqwftvncz", 23),
                ("nppdvjthqldpwncqszvftbrmjlhg", 23),
                ("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", 29),
                ("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", 26),
            ]

        for data in testData {
            let result = Day6.partTwo(input: data.data)
            XCTAssertEqual(result, data.expected, data.data)
        }
    }

    func testPart2_data() {
        let data = loadTest(filename: "Day6")

        let result = Day6.partTwo(input: data)

        XCTAssertEqual(result, 3837)
    }
}
