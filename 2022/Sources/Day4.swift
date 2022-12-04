import AdventOfCodeCommon
import Foundation


public struct Day4 {

    public static func partOne(input: [String]) -> Int {
        let result = input
            .convertToRanges()
            .convertRangesToSets()
            .filterSetsThatAreFullyContained()
        return result.count
    }

    public static func partTwo(input: [String]) -> Int {
        let result = input
            .convertToRanges()
            .convertRangesToSets()
            .filterSetsThatOverlap()
        return result.count
    }
}

public extension Sequence where Element == String {

    func convertToRanges() -> [[[String]]] {
        self.map {
            let result = $0.components(separatedBy: ",")
                .map {
                    let values = $0.components(separatedBy: "-")
                    return [values[0], values[1]]
                }
            return result
        }
    }
}

public extension Sequence where Element == [[String]] {

    func convertRangesToSets() -> [[Set<Int>]] {
        self.map {
            $0.map {
                let start = Int($0[0]) ?? 0
                let end = Int($0[1]) ?? 0
                return Set(start...end)
            }
        }
    }
}

public extension Sequence where Element == [Set<Int>] {

    func filterSetsThatAreFullyContained() -> [[Set<Int>]] {
        let result = self.filter { $0.isRangeFullyContained() }
        return result
    }

    func filterSetsThatOverlap() -> [[Set<Int>]] {
        let result = self.filter { $0.doRangesOverlap() }
        return result
    }
}

public extension Sequence where Element == Set<Int> {

    func isRangeFullyContained() -> Bool {
        var largestSet = 0
        let result = self.reduce(into: Set<Int>(), { partialResult, next in
            largestSet = Swift.max(largestSet, next.count)
            partialResult = partialResult.union(next)
        })
        return result.count  == largestSet
    }

    func doRangesOverlap() -> Bool {
        let result = self.reduce(into: Set<Int>(), { partialResult, next in
            if partialResult.isEmpty {
                partialResult = next
            } else {
                partialResult = partialResult.intersection(next)
            }
        })
        return !result.isEmpty
    }
}
