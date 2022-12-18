import AdventOfCode_2022
import XCTest

final class TestDay13: XCTestCase {

    let data = """
               [1,1,3,1,1]
               [1,1,5,1,1]

               [[1],[2,3,4]]
               [[1],4]

               [9]
               [[8,7,6]]

               [[4,4],4,4]
               [[4,4],4,4,4]

               [7,7,7,7]
               [7,7,7]

               []
               [3]

               [[[]]]
               [[]]

               [1,[2,[3,[4,[5,6,7]]]],8,9]
               [1,[2,[3,[4,[5,6,0]]]],8,9]
               """

    func testParse() {
        testParseIndex_exampleOne()
        testParseIndex_exampleTwo()
        testParseIndex_exampleThree()
        testParseIndex_exampleFour()
        testParseIndex_exampleFive()
        testParseIndex_exampleSix()
        testParseIndex_exampleSeven()
        testParseIndex_exampleEight()
    }

    func testParseIndex_exampleOne() {
        /*
         == Pair 1 ==
         - Compare [1,1,3,1,1] vs [1,1,5,1,1]
           - Compare 1 vs 1
           - Compare 1 vs 1
           - Compare 3 vs 5
             - Left side is smaller, so inputs are in the right order
         */
        parseIndex(index: 0)
    }

    func testParseIndex_exampleTwo() {
        /*
         == Pair 2 ==
         - Compare [[1],[2,3,4]] vs [[1],4]
           - Compare [1] vs [1]
             - Compare 1 vs 1
           - Compare [2,3,4] vs 4
             - Mixed types; convert right to [4] and retry comparison
             - Compare [2,3,4] vs [4]
               - Compare 2 vs 4
                 - Left side is smaller, so inputs are in the right order
         */
        parseIndex(index: 1)
    }

    func testParseIndex_exampleThree() {
        /*
         == Pair 3 ==
         - Compare [9] vs [[8,7,6]]
           - Compare 9 vs [8,7,6]
             - Mixed types; convert left to [9] and retry comparison
             - Compare [9] vs [8,7,6]
               - Compare 9 vs 8
                 - Right side is smaller, so inputs are not in the right order
         */
        parseIndex(index: 2)
    }

    func testParseIndex_exampleFour() {
        /*- Compare [[4,4],4,4] vs [[4,4],4,4,4]
         - Compare [4,4] vs [4,4]
           - Compare 4 vs 4
           - Compare 4 vs 4
         - Compare 4 vs 4
         - Compare 4 vs 4
         - Left side ran out of items, so inputs are in the right order
         */
        parseIndex(index: 3)
    }

    func testParseIndex_exampleFive() {
        /*
         - Compare [7,7,7,7] vs [7,7,7]
           - Compare 7 vs 7
           - Compare 7 vs 7
           - Compare 7 vs 7
           - Right side ran out of items, so inputs are not in the right order
         */
        parseIndex(index: 4)
    }

    func testParseIndex_exampleSix() {
        /*
         - Compare [] vs [3]
           - Left side ran out of items, so inputs are in the right order
         */
        parseIndex(index: 5)
    }

    func testParseIndex_exampleSeven() {
        /*
         - Compare [[[]]] vs [[]]
           - Compare [[]] vs []
             - Right side ran out of items, so inputs are not in the right order
         */
        parseIndex(index: 6)
    }

    func testParseIndex_exampleEight() {
        /*
         - Compare [1,[2,[3,[4,[5,6,7]]]],8,9] vs [1,[2,[3,[4,[5,6,0]]]],8,9]
           - Compare 1 vs 1
           - Compare [2,[3,[4,[5,6,7]]]] vs [2,[3,[4,[5,6,0]]]]
             - Compare 2 vs 2
             - Compare [3,[4,[5,6,7]]] vs [3,[4,[5,6,0]]]
               - Compare 3 vs 3
               - Compare [4,[5,6,7]] vs [4,[5,6,0]]
                 - Compare 4 vs 4
                 - Compare [5,6,7] vs [5,6,0]
                   - Compare 5 vs 5
                   - Compare 6 vs 6
                   - Compare 7 vs 0
                     - Right side is smaller, so inputs are not in the right order
         */
        parseIndex(index: 7)
    }

    func testParseIndex_exampleOne(file: StaticString = #filePath, line: UInt = #line) {
        parseIndex(index: 0, file: file, line: line)
    }

    func testParseIndex_exampleTwo(file: StaticString = #filePath, line: UInt = #line) {
        parseIndex(index: 1, file: file, line: line)
    }

    func testParseIndex_exampleThree(file: StaticString = #filePath, line: UInt = #line) {
        parseIndex(index: 2, file: file, line: line)
    }

    func testParseIndex_exampleFour(file: StaticString = #filePath, line: UInt = #line) {
        parseIndex(index: 3, file: file, line: line)
    }

    func testParseIndex_exampleFive(file: StaticString = #filePath, line: UInt = #line) {
        parseIndex(index: 4, file: file, line: line)
    }

    func testParseIndex_exampleSix(file: StaticString = #filePath, line: UInt = #line) {
        parseIndex(index: 5, file: file, line: line)
    }

    func testParseIndex_exampleSeven(file: StaticString = #filePath, line: UInt = #line) {
        parseIndex(index: 6, file: file, line: line)
    }

    func testParseIndex_exampleEight(file: StaticString = #filePath, line: UInt = #line) {
        parseIndex(index: 7, file: file, line: line)
    }

    func parseIndex(index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let expected = [true, true, false, true, false, true, false, false]
        let result = Day13.testInput(input: data, index: index)
        let expectedValue = expected[index]
        XCTAssertEqual(result, expectedValue, "Failed: \(index)", file: file, line: line)
    }


    func testPart1_intro() {
        let result = Day13.partOne(input: data)

        XCTAssertEqual(result, 13)
    }

    func testPart1_data() {
        let data = loadTest(filename: "Day13")

        let result = Day13.partOne(input: data)

        XCTAssertNotEqual(result, 6227)
        XCTAssertNotEqual(result, 6082)
        XCTAssertNotEqual(result, 4727)
        XCTAssertEqual(result, 0)
    }

    func testPart2_intro() {
        let data = """
                   """.components(separatedBy: "\n")

        let result = Day13.partTwo(input: data)

        XCTAssertEqual(result, 0)
    }

    func testPart2_data() {
        let data = loadTestData(filename: "Day13")

        let result = Day13.partTwo(input: data)

        XCTAssertEqual(result, 0)
    }
}
