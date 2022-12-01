import XCTest
@testable import AdventOfCode_2021

final class TestDay_8: XCTestCase {

    func testExamplePartOne() {
        let input = """
be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
"""
        let day = Day_8()
        let result = day.partOne(input: input)
        XCTAssertEqual(result, 26)
    }

    func testComputePartOne() {
        let input = loadTest(filename: "Day8").trimmingCharacters(in: .newlines)
        let day = Day_8()
        let result = day.partOne(input: input)
        XCTAssertEqual(result, 543)
    }

    func testExamplePartTwo() {
        let input = """
acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf
"""
        let day = Day_8()
        let result = day.partTwo(input: input)
        XCTAssertEqual(result, 5353)
    }

    func testFailingPartTwo() {
        let input = """
bgafcde gfcd agc ebdgac adfceb bafeg efgca cgdfae cg ecadf | fabgced gc agc cdfg
"""
        let day = Day_8()
        let result = day.partTwo(input: input)
        XCTAssertEqual(result, 8174)
    }

    func testComputePartTwo() {
        let input = loadTest(filename: "Day8").trimmingCharacters(in: .newlines)
        let day = Day_8()
        let result = day.partTwo(input: input)
        // too low 461738
        XCTAssertEqual(result, 994266)
    }
}

