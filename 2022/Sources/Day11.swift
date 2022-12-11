import AdventOfCodeCommon
import RegexBuilder
import Foundation


public struct Day11 {

    public static func partOne(input: String) -> Int {
        let monkeys = input.parseToNotes()
        let processor = MonkeyProcessor()
        let inspections = processor.processRounds(monkeys: monkeys, rounds: 20, worryLevelDivisor: 3, modulu: Int.max)
        return inspections[0] * inspections[1]
    }

    public static func partTwo(input: String) -> Int {
        let monkeys = input.parseToNotes()
        let leastCommon = monkeys.map { $0.test.divisibleBy }.reduce(into: 1) { partialResult, next in
            partialResult = partialResult * next
        }
        let processor = MonkeyProcessor()
        let inspections = processor.processRounds(monkeys: monkeys, rounds: 10_000, worryLevelDivisor: 1, modulu: leastCommon)
        return inspections[0] * inspections[1]
    }
}

private class MonkeyProcessor {

    func processRounds(monkeys: [Monkey], rounds: Int, worryLevelDivisor: Int, modulu: Int) -> [Int] {
        for _ in 0..<rounds {
            processRound(monkeys: monkeys,
                         worryLevelDivisor: worryLevelDivisor,
                         modulu: modulu)
        }
        return monkeys.map { $0.inspections }.sorted().reversed()
    }

    func processRound(monkeys: [Monkey], worryLevelDivisor: Int, modulu: Int) {
        for monkey in monkeys.enumerated() {
//            print("Monkey \(monkey.offset):")
            let results = processMonkey(monkey: monkey.element,
                                        worryLevelDivisor: worryLevelDivisor,
                                        modulu: modulu)
            for result in results {
                monkeys[result.monkeyIndex].addItem(item: result.item)
            }
        }
    }

    func processMonkey(monkey: Monkey, worryLevelDivisor: Int, modulu: Int) -> [ProcessMonkeyResult]{
        var results = [ProcessMonkeyResult]()
        for item in monkey.items {
            monkey.inspect()
            let newItemValue = (monkey.operation.perform(old: item) / Int(worryLevelDivisor)) % modulu
            let testResult = monkey.test.performTest(value: newItemValue)
            let result = ProcessMonkeyResult(monkeyIndex: testResult, item: newItemValue)
            results.append(result)
        }
        monkey.removeItems()
        return results
    }

    struct ProcessMonkeyResult {

        let monkeyIndex: Int
        let item: Int
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
//        print("StartingItems: \(startingItems)")
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

private class Monkey {

    init(items: [Int],
         operation: Operation,
         test: Test) {
        self.items = items
        self.operation = operation
        self.test = test
    }

    private(set) var inspections: Int = 0
    private(set) var items: [Int]
    let operation: Operation
    let test: Test

    func inspect() {
        inspections += 1
    }

    func removeItems() {
        items.removeAll()
    }

    func addItem(item: Int) {
        items.append(item)
    }
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
                items: startingItems,
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

    func performTest(value: Int) -> Int {
        if value.isMultiple(of: divisibleBy) {
//            print("    Current worry level is divisible by \(divisibleBy).")
            return trueMonkey
        } else {
//            print("    Current worry level is not divisible by \(divisibleBy).")
            return falseMonkey
        }

    }
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

private enum Operator: CustomStringConvertible {

    case add
    case multiplication

    var description: String {
        switch self {
        case .add:
            return "increases"
        case .multiplication:
            return "is multiplied"
        }
    }
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

    func prettyPrint(old: Int) {
        print("    Worry level \(op.description) by \(b.value(old: old).description) to \(perform(old: old)).")
    }
}

