import AdventOfCodeCommon
import Foundation

// The one where I tested to extension all the things
public struct Day3 {

    static let lowerCaseCharacters = (97...122).map({Character(UnicodeScalar($0))})
    static let upperCaseCharacters = (65...90).map({Character(UnicodeScalar($0))})
    static let characters = lowerCaseCharacters + upperCaseCharacters

    public static func partOne(input: [String]) -> Int {
        let result = input
            .splitRucksackContentsIntoCompartments()
            .mapItemsToCharacters()
            .mapCharacterToValue()
            .sum()

        return result
    }

    public static func partTwo(input: [String]) -> Int {
        let result = input
            .chunked(into: 3)
            .mapItemsToCharacters()
            .mapCharacterToValue()
            .sum()
        return result
    }
}

private extension Sequence where Element == Character {

    func mapCharacterToValue() -> [Int] {
        self.map {
            let index = (Day3.characters.firstIndex(of: $0) ?? -1) + 1
            return index
        }
    }
}

private extension Sequence where Element == [String] {

    func mapItemsToCharacters() -> [Character] {
        self.flatMap { $0.mapItemsToCharacters() }
    }
}

private extension Sequence where Element == String {

    func splitRucksackContentsIntoCompartments() -> [[String]] {
        self.map { $0.splitContentsIntoCompartments() }
    }

    func mapItemsToCharacters() -> [Character] {
        let result = self.map { Set($0) }
            .reduce(into: Set<Character>(), { partialResult, next in
                if partialResult.isEmpty {
                    partialResult = next
                } else {
                    partialResult = partialResult.intersection(next)
                }

            })
        return Array(result)
    }
}

private extension String {

    func splitContentsIntoCompartments() -> [String] {
        let midIndex = index(startIndex, offsetBy: count/2)
        let first = String(self[..<midIndex])
        let second = String(self[midIndex...])
        return [first, second]
    }
}
