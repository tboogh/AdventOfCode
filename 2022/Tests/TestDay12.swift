import AdventOfCode_2022
import XCTest

final class TestDay12: XCTestCase {

    func testPart1_intro() {
        let data = """
                   Sabqponm
                   abcryxxl
                   accszExk
                   acctuvwj
                   abdefghi
                   """.components(separatedBy: "\n")
        let result = Day12.partOne(input: data)
        XCTAssertEqual(result, 31)
    }
    
    func testPart1_data() {
        let data = loadTestData(filename: "Day12")
        let result = Day12.partOne(input: data)

        XCTAssertEqual(result, 517)
    }

    func testPart2_intro() {
        let data = """
                   Sabqponm
                   abcryxxl
                   accszExk
                   acctuvwj
                   abdefghi
                   """.components(separatedBy: "\n")

        let result = Day12.partTwo(input: data)

        XCTAssertEqual(result, 29)
    }

    func testPart2_data() {
        let data = loadTestData(filename: "Day12")

        let result = Day12.partTwo(input: data)

        XCTAssertEqual(result, 512)
    }
}
