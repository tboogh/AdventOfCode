import AdventOfCode_2022
import XCTest

final class TestDay15: XCTestCase {

    let data = """
               Sensor at x=2, y=18: closest beacon is at x=-2, y=15
               Sensor at x=9, y=16: closest beacon is at x=10, y=16
               Sensor at x=13, y=2: closest beacon is at x=15, y=3
               Sensor at x=12, y=14: closest beacon is at x=10, y=16
               Sensor at x=10, y=20: closest beacon is at x=10, y=16
               Sensor at x=14, y=17: closest beacon is at x=10, y=16
               Sensor at x=8, y=7: closest beacon is at x=2, y=10
               Sensor at x=2, y=0: closest beacon is at x=2, y=10
               Sensor at x=0, y=11: closest beacon is at x=2, y=10
               Sensor at x=20, y=14: closest beacon is at x=25, y=17
               Sensor at x=17, y=20: closest beacon is at x=21, y=22
               Sensor at x=16, y=7: closest beacon is at x=15, y=3
               Sensor at x=14, y=3: closest beacon is at x=15, y=3
               Sensor at x=20, y=1: closest beacon is at x=15, y=3
               """

    func testPart1_intro() {
        let result = Day15.partOne(input: data, row: 10)

        XCTAssertEqual(result, 26)
    }

    func testPart1_data() {
        let data = loadTest(filename: "Day15")

        let result = Day15.partOne(input: data, row: 2000000)

        XCTAssertEqual(result, 5525990)
    }

    func testPart2_intro() {
        let result = Day15.partTwo(input: data)

        XCTAssertEqual(result, 0)
    }

    func testPart2_data() {
        let data = loadTest(filename: "Day15")

        let result = Day15.partTwo(input: data)

        XCTAssertEqual(result, 0)
    }
}
