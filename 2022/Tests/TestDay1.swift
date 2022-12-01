import AdventOfCode_2022
import XCTest

final class TestDay1: XCTestCase {

    func testPart1_intro() {
        let data = """
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
"""

        let day1 = Day1()
        let result = day1.part1(input: data)
        XCTAssertEqual(result, 24000)
    }

    func testPart1_data() {
        let day1 = Day1()
        let data = loadTest(filename: "Day1")
        let result = day1.part1(input: data)
        XCTAssertEqual(result, 70374)
    }

    func testPart2_intro() {
        let data = """
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
"""

        let day1 = Day1()
        let result = day1.part2(input: data)
        XCTAssertEqual(result, 45000)
    }

    func testPart2_data() {
        let day1 = Day1()
        let data = loadTest(filename: "Day1")
        let result = day1.part2(input: data)
        XCTAssertEqual(result, 204610)
    }
}
