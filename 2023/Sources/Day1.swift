import AdventOfCodeCommon
import Foundation

public struct Day1 {

    public static func partOne(input: [String]) -> Int {
        let numbersInInput = input.map {
            $0.filter { $0.isNumber }.map { Int(String($0)) ?? 0 }
        }.map {
            guard
                let start = $0.first,
                let end = $0.last
            else { return 0 }
            let result = start * 10 + end
            return result
        }
        let result = numbersInInput.reduce(0, +)
        return result
    }

    public static func partTwo(input: [String]) -> Int {
        var result = 0
        for line in input {
            let number = number(for: line)
            result += number
        }

        return result
    }

    private static func number(for line: String) -> Int {
        let textNumberMap = [
            "one": 1,
            "two": 2,
            "three": 3,
            "four": 4,
            "five": 5,
            "six": 6,
            "seven": 7,
            "eight": 8,
            "nine": 9
        ]

        var ranges = [(String.Index, Int)]()
        for key in textNumberMap.keys {
            let keyRanges = line.ranges(of: key)
            let number = textNumberMap[key]!
            for keyRange in keyRanges {
                ranges.append((keyRange.lowerBound, number))
            }
        }
        if let firstNumberIndex = line.firstIndex(where: { $0.isNumber }),
           let number = Int(String(line[firstNumberIndex])) {
            ranges.append((firstNumberIndex, number))
        }
        if let lastNumberIndex = line.lastIndex(where: { $0.isNumber }),
           let number = Int(String(line[lastNumberIndex])) {
            ranges.append((lastNumberIndex, number))
        }

        let firsts = ranges.sorted(by: { $0.0 < $1.0 })
        if let first = firsts.first?.1,
           let last = firsts.last?.1 {
            let result = first * 10 + last
            print("zzz \(line) => (\(first), \(last))")
            return result
        }
        return 0
    }
}
