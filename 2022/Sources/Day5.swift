import AdventOfCodeCommon
import Foundation

public struct Day5 {

    public static func partOne(input: String) -> String {
        let testData = input
            .parseTestData()
        var stacks = testData.0
        let result = stacks
            .perform(moves: testData.1)
            .result()
        return result
    }

    public static func partTwo(input: String) -> String {
        let testData = input
            .parseTestData()
        var stacks = testData.0
        let result = stacks
            .perform(moves: testData.1, batchMoves: true)
            .result()
        return result
    }
}

private extension String {

    func parseTestData() -> (Stacks, [Move]) {
        let halfs = self.components(separatedBy: "\n\n")
        return (halfs[0].parseStackData(), halfs[1].parseMoveData())
    }

    func parseMoveData() -> [Move] {
        let moves = self.lines
            .map {
                let c = $0.replacingOccurrences(of: "move ", with: "")
                    .replacingOccurrences(of: " from", with: "")
                    .replacingOccurrences(of: " to", with: "")
                    .components(separatedBy: .whitespaces)
                let index = Int(c[0]) ?? 0
                let from = Int(c[1]) ?? 0
                let to = Int(c[2]) ?? 0
                return Move(
                    iterations: index,
                    from: from - 1,
                    to: to - 1)
            }
        return moves
    }

    func parseStackData() -> Stacks {
        let lines = Array(self.lines.reversed())
        let numberOfColumns = lines.first?.parseNumberOfColumns() ?? 0
        var stacks = Stacks(count: numberOfColumns)
        let stackLines = Array(lines.dropFirst())
        let stackHeight = stackLines.count - 1
        for row in 0...stackHeight {
            let line = stackLines[row]
            for column in 0..<numberOfColumns {
                let offset = Int(column * 4) + 1
                guard offset < line.count else { continue }
                let index = line.index(line.startIndex, offsetBy: offset)
                let valueAtOffset = line[index]
                if valueAtOffset.isWhitespace { continue }
                stacks.push(stack: column, values: [valueAtOffset], reverse: false)
            }
        }
        return stacks
    }

    func parseNumberOfColumns() -> Int {
        guard
            let numberOfColumns =
                self.components(separatedBy: CharacterSet.whitespaces)
                .filter({ !$0.isEmpty })
                .map({ value in Int(String(value)) })
                .last!
        else { return 0 }
        return numberOfColumns
    }
}

private struct Move {

    let iterations: Int
    let from: Int
    let to: Int
}

private struct Stacks {

    private var stacks: [Stack]

    init(count: Int) {
        stacks = Array(repeating: Stack(), count: count)
    }

    private mutating func push(stack: Int, value: Character) {
        stacks[stack].push(value)
    }

    private mutating func pop(stack: Int) -> Character? {
        stacks[stack].pop()
    }

    mutating func pop(stack: Int, count: Int) -> [Character] {
        var values = [Character]()
        for _ in 0..<count {
            guard let value = pop(stack: stack) else { continue }
            values.append(value)
        }
        return values
    }

    mutating func push(stack: Int, values: [Character], reverse: Bool) {
        var values = values
        if reverse {
            values = values.reversed()
        }
        values.forEach { push(stack: stack, value: $0) }
    }
}

private struct Stack {

    private(set) var values: [Character] = []

    mutating func push(_ value: Character) {
        values.append(value)
    }

    mutating func pop() -> Character? {
        values.popLast()
    }
}

private extension Stacks {

    @discardableResult
    mutating func perform(moves: [Move], batchMoves: Bool = false) -> Stacks {
        for move in moves {
            let values = pop(stack: move.from, count: move.iterations)
            push(stack: move.to, values: values, reverse: batchMoves)
        }
        return self
    }

    func result() -> String {
        let result = stacks.compactMap { $0.values.last }
        return String(result)
    }
}
