import XCTest
@testable import AdventOfCode_2021

final class TestDay_Template: XCTestCase {

    func testExamplePartOne() {
        let input = """
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
"""
        let day = Day_10()
        let result = day.partOne(input: input)
        XCTAssertEqual(result, 26397)
    }

    func testClosedChunk(){
        let chunk = "([])"
        let node = Day10Parser.parse(input: chunk)
    }

    func testCorruptyChuncks() {
        let chunks = ["(]",
                    "{()()()>",
                    "(((()))}",
                    "<([]){()}[{}])"]
        for chunk in chunks {
            let result = Day10Parser.parse(input: chunk)
            let corrupt = result.corruptNodes
            print(result)
        }
    }

    func testComputePartOne() {
        let input = loadTest(filename: "Day10")
        let day = Day_10()
        let result = day.partOne(input: input)
        XCTAssertEqual(result, 316851)
    }

    func testExamplePartTwo() {
        let input = """
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
"""
        let day = Day_10()
        let result = day.partTwo(input: input)
        XCTAssertEqual(result, 0)
    }

    func testComputePartTwo() {
        let input = loadTest(filename: "Day10")
        let day = Day_10()
        let result = day.partTwo(input: input)
        XCTAssertEqual(result, 2182912364)
    }
}

