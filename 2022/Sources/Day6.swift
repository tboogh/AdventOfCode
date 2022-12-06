import AdventOfCodeCommon
import Foundation

public struct Day6 {

    public static func partOne(input: String) -> Int {
        let result = Array(input).findFirstUniqueString(length: 4)
        return result
    }

    public static func partTwo(input: String) -> Int {
        let result = Array(input).findFirstUniqueString(length: 14)
        return result
    }
}

extension Array where Element == Character {

    func findFirstUniqueString(length: Int) -> Int {
        for index in 0..<count-length {
            let values = self.dropFirst(index).prefix(length)
            let currentSet = Set<Character>(values)
            if currentSet.count == length {
                return index + length
            }
        }
        return 0
    }
}
