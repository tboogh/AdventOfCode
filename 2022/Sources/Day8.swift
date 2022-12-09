import AdventOfCodeCommon
import Foundation

public struct Day8 {

    public static func partOne(input: [String]) -> Int {
        let grid = Grid(from: input)
        let result = grid.findVisibleTrees()
            .computeTotalVisibleTree(grid: grid)
        return result
    }

    public static func partTwo(input: [String]) -> Int {
        let grid = Grid(from: input)
        let result = grid
            .findVisibleTrees()
            .sorted(by: { $0.scenicValue < $1.scenicValue })
            .last
        return result?.scenicValue ?? -1
    }
}

private enum Direction {

    case up
    case down
    case left
    case right
}

private struct TreeHeightIndex: Hashable, CustomDebugStringConvertible {

    let row: Int
    let column: Int
    let height: Int
    let scenicValue: Int

    var debugDescription: String {
        "(x: \(column), y: \(row)) height: \(height)"
    }
}

private extension Sequence where Element == TreeHeightIndex {

    func computeTotalVisibleTree(grid: Grid) -> Int {
        let setOfTrees = Set(self)
        let totalEdgeLength = grid.totalEdgeLength
        return totalEdgeLength + setOfTrees.count
    }
}

private extension Grid {

    func treeIndexes() -> [TreeHeightIndex] {
        data.enumerated().map{ row in
            row.element.enumerated().map { column in
                TreeHeightIndex(row: row.offset, column: column.offset, height: column.element, scenicValue: 0)
            }
        }.flatMap{ $0 }
    }

    func findVisibleTrees() -> [TreeHeightIndex] {
        var treeIndexes = Set<TreeHeightIndex>()
        for rowIndex in 1..<data.count - 1 {
            let row = data[rowIndex]
            for columnIndex in 1..<row.count - 1 {
                if let treeIndex = findVisibleTrees(rowIndex: rowIndex, columnIndex: columnIndex) {
                    treeIndexes.insert(treeIndex)
                }
            }
        }
        return Array(treeIndexes)
    }

    func findVisibleTrees(rowIndex: Int, columnIndex: Int) -> TreeHeightIndex? {
        let row = data[rowIndex]
        let value = row[columnIndex]
        let leftValues = row.enumerated().filter { $0.offset < columnIndex }.reversed().map { $0.element }
        let rightValues = row.enumerated().filter { $0.offset > columnIndex }.map { $0.element }
        let columnValues = data.map { $0[columnIndex] }
        let upValues = columnValues.enumerated().filter { $0.offset < rowIndex }.reversed().map { $0.element }
        let downValues = columnValues.enumerated().filter { $0.offset > rowIndex }.map { $0.element }

        let left = Array(row.enumerated().filter { $0.offset < columnIndex }.reversed())
        let right = Array(row.enumerated().filter { $0.offset > columnIndex })
        let up = columnValues.enumerated().filter { $0.offset < rowIndex }.reversed()
        let down = columnValues.enumerated().filter { $0.offset > rowIndex }
        let firstBlockLeft = left.first(where: { $0.element >= value })
        let firstBlockRight = right.first(where: { $0.element >= value })
        let firstBlockUp = up.first(where: { $0.element >= value })
        let firstBlockDown = down.first(where: { $0.element >= value })

        let upDistance = firstBlockUp?.offset ?? 0
        let leftDistance = firstBlockLeft?.offset ?? 0
        let downDistance = firstBlockDown?.offset ?? data.count - 1
        let rightDistance = firstBlockRight?.offset ?? row.count - 1

        let upValueCount = rowIndex - upDistance
        let leftValueCount = columnIndex - leftDistance
        let rightValueCount = rightDistance - columnIndex
        let downValueCount = downDistance - rowIndex
        let scenic = upValueCount * leftValueCount * rightValueCount * downValueCount
        if firstBlockUp == nil ||
            firstBlockLeft == nil ||
            firstBlockDown == nil ||
            firstBlockRight == nil {
            let treeHeightIndex = TreeHeightIndex(
                row: rowIndex,
                column: columnIndex,
                height: value,
                scenicValue: scenic)
            return treeHeightIndex
        }
        return nil
    }

    var totalEdgeLength: Int {
        let horizontalEdgeLength = data[0].count - 1
        let verticalEgdeLength = data.count - 1
        return horizontalEdgeLength * 2 + verticalEgdeLength * 2
    }
}

private struct Grid {

    init(from input: [String]) {
        var data: [[Int]] = []
        for line in input {
            let values = line.compactMap { Int(String($0)) }
            data.append(values)
        }
        self.data = data
    }

    public var data: [[Int]]

    public var width: Int {
        data.first?.count ?? 0
    }
}

extension Grid: CustomDebugStringConvertible {

    var debugDescription: String {
        let output = data.map { $0.map { String($0) }
            .joined(separator: "") }
            .joined(separator: "\n")
        return output
    }
}
