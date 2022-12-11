import AdventOfCodeCommon
import RegexBuilder
import Foundation


public struct Day11 {

    public static func partOne(input: String) -> Int {
        let monkeys = input.parseToNotes()
        return -1
    }

    public static func partTwo(input: [String]) -> Int {
        return -1
    }
}


private extension String {

    func parseToNotes() -> [Monkey] {
        let data = self.split(separator: "\n\n")
        let monkeys = data.compactMap { Monkey.parse(input: String($0).lines) }
        return monkeys
    }

    func parseStarting() -> [Int] {
        let startingItems = self
            .replacing(Monkey.startingItemsToken, with: "")
            .replacing(" ", with: "")
            .components(separatedBy: ",")
            .compactMap { Int($0) }
        print("StartingItems: \(startingItems)")
        return startingItems
    }

    func parseOperation() -> Operation? {
        //   Operation: new = old + 6
        let regex = Regex {
            Capture {
                OneOrMore(.word)
            }
            Capture {
                ZeroOrMore {
                    "+"
                }
                ZeroOrMore {
                    "*"
                }
            }
            Capture {
                OneOrMore(.word)
            }
        }
        let regexResult = self
            .replacing("Operation: new = ", with: "")
            .replacing(" ", with: "")
            .firstMatch(of: regex)
        if let regexResult {
            let (_, a, op, b) = regexResult.output
            if let aValue = String(a).parseOperationValue(),
               let bValue = String(b).parseOperationValue(),
               let operatorValue = String(op).parseOperationOperator() {
                return Operation(
                    a: aValue,
                    op: operatorValue,
                    b: bValue)
            }
        }
        return nil
    }

    func parseOperationOperator() -> Operator? {
        if self == "+" {
            return .add
        } else if self == "*" {
            return .multiplication
        }
        fatalError("Unknown operator: \(self)")
    }

    func parseOperationValue() -> OperationValue? {
        if let aValue = Int(self) {
            return .value(aValue)
        } else if self == "old" {
            return .current
        }
        fatalError("unknown value: \(self)")
    }
}

private extension Array where Element == String {

    private static let testDivisibleToken = "Test: divisible by "
    private static let testTrueToken = "If true: throw to monkey "
    private static let testFalseToken = "If false: throw to monkey "

    func parseTestinput() -> Test? {
        var divisibleBy: Int = 0
        var trueMonkey: Int = 0
        var falseMonkey: Int = 0

        for line in self {
            let input = line.trimmingCharacters(in: .whitespaces)
            if input.starts(with: Self.testDivisibleToken) {
                divisibleBy = Int(input.replacing(Self.testDivisibleToken, with: ""))!
            } else if input.starts(with: Self.testTrueToken) {
                trueMonkey = Int(input.replacing(Self.testTrueToken, with: ""))!
            } else if input.starts(with: Self.testFalseToken) {
                falseMonkey = Int(input.replacing(Self.testFalseToken, with: ""))!
            }
        }
        return Test(divisibleBy: divisibleBy,
                    trueMonkey: trueMonkey,
                    falseMonkey: falseMonkey)
    }
}

private struct Monkey {

    let startingItems: [Int]
    let operation: Operation
    let test: Test
}

private extension Monkey {

    static let startingItemsToken = "Starting items:"

    static func parse(input: [String]) -> Monkey? {
        var startingItems: [Int]?
        var operation: Operation?
        var test: Test?
        var lines = input

        repeat {
            let line = lines.removeFirst()
            if line.contains(startingItemsToken) {
                startingItems = line.parseStarting()
            }
            if line.contains("Operation:") {
                operation = line.parseOperation()
            }
            if line.contains("Test") {
                test = ([line] + lines).parseTestinput()
                lines = []
            }
        } while !lines.isEmpty
        if let startingItems,
            let operation,
            let test {
            return Monkey(
                startingItems: startingItems,
                operation: operation,
                test: test)
        }
        return nil
    }
}

private struct Test {

    let divisibleBy: Int
    let trueMonkey: Int
    let falseMonkey: Int
}

private enum OperationValue {

    case current
    case value(Int)

    func value(old: Int) -> Int {
        switch self {
        case .current: return old
        case .value(let value): return value
        }
    }
}

private enum Operator {

    case add
    case multiplication
}

private struct Operation {

    let a: OperationValue
    let op: Operator
    let b: OperationValue

    func perform(old: Int) -> Int {
        let aValue = a.value(old: old)
        let bValue = b.value(old: old)
        switch op {
        case .add:
            return aValue + bValue
        case .multiplication:
            return aValue * bValue
        }
    }
}

