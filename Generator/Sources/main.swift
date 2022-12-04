import Swift
import Foundation
import CommandLineKit

var flags = Flags()
let path = flags.string("p", "path", description: "Path to the year folder to generate new day")
let day = flags.int("d", "day", description: "Day to generate")

if let failure = flags.parsingFailure() {
  print(failure)
  exit(1)
}

let date = Date()
let dateComponents = Calendar.current.dateComponents([.year, .day], from: date)
let pathValue = path.value ?? "\(dateComponents.year!)"
let dayValue = day.value ?? dateComponents.day!

let dayName = "Day\(dayValue)"
let currentPath = URL(filePath: ".")
let sourcePath = currentPath.appending(components: "\(pathValue)", "Sources")
let sourceDayPath = sourcePath.appending(components: "\(dayName).swift")
let testPath = currentPath.appending(components: "\(pathValue)", "Tests")
let testDayPath = testPath.appending(components: "Test\(dayName).swift")
let testDataPath = currentPath.appending(components: "\(pathValue)", "Tests", "Data")
let testDataDayPath = testDataPath.appending(components: "\(dayName).txt")

let dayTemplate = """
import AdventOfCodeCommon
import Foundation

public struct #DAY# {

    public static func partOne(input: [String]) -> Int {
        return -1
    }

    public static func partTwo(input: [String]) -> Int {
        return -1
    }
}
"""

let testTemplate = """
import AdventOfCode_2022
import XCTest

final class Test#DAY#: XCTestCase {

    func testPart1_intro() {
        let data = \"\"\"
                   \"\"\".components(separatedBy: "\\n")

        let result = #DAY#.partOne(input: data)

        XCTAssertEqual(result, 0)
    }

    func testPart1_data() {
        let data = loadTestData(filename: "#DAY#")

        let result = #DAY#.partOne(input: data)

        XCTAssertEqual(result, 0)
    }

    func testPart2_intro() {
        let data = \"\"\"
                   \"\"\".components(separatedBy: "\\n")

        let result = #DAY#.partTwo(input: data)

        XCTAssertEqual(result, 0)
    }

    func testPart2_data() {
        let data = loadTestData(filename: "#DAY#")

        let result = #DAY#.partTwo(input: data)

        XCTAssertEqual(result, 0)
    }
}
"""

let dayOutput = dayTemplate.replacingOccurrences(of: "#DAY#", with: dayName)
let testOutput = testTemplate.replacingOccurrences(of: "#DAY#", with: dayName)

try FileManager.default.createDirectory(at: sourcePath, withIntermediateDirectories: true)
try FileManager.default.createDirectory(at: testPath, withIntermediateDirectories: true)
try FileManager.default.createDirectory(at: testDataPath, withIntermediateDirectories: true)

if !FileManager.default.fileExists(atPath: sourceDayPath.relativePath) {
    let sourceResult = FileManager.default.createFile(atPath: sourceDayPath.relativePath, contents: dayOutput.data(using: .utf8))
    if !sourceResult {
        print("Failed to create source file at \(sourceDayPath.relativePath)")
    }
}
if !FileManager.default.fileExists(atPath: testDayPath.relativePath) {
    let testResult = FileManager.default.createFile(atPath: testDayPath.relativePath, contents: testOutput.data(using: .utf8))
    if !testResult {
        print("Failed to create source file at \(testDayPath.relativePath)")
    }
}
if !FileManager.default.fileExists(atPath: testDataDayPath.relativePath) {
    let testDataResult = FileManager.default.createFile(atPath: testDataDayPath.relativePath, contents: "".data(using: .utf8))
    if !testDataResult {
        print("Failed to create source file at \(testDataDayPath.relativePath)")
    }
}
