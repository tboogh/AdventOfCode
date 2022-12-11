import AdventOfCodeCommon
import Foundation

public struct Day10 {

    public static func partOneIntro(input: [String]) -> Int {
        let instructions = input.parseInstructions()
        let processor = Processor()
        processor.addInstructionsToTimeline(instructions: instructions)
//        processor.cycle(count: 5)
        let result = processor.cycleProgram()
        result.prettyPrint()
        return processor.registries[0]
    }

    public static func partOne(input: [String]) -> Int {
        let instructions = input.parseInstructions()
        let processor = Processor()
        processor.addInstructionsToTimeline(instructions: instructions)
        let result = processor.cycleProgram()
        result.prettyPrint()
        return result.calculateSignalStrength()
    }

    public static func partTwo(input: [String]) -> Int {
        return -1
    }
}

private extension Dictionary where Key == Int, Value == [Int] {

    func calculateSignalStrength() -> Int {
        let values = self.map { ($0.key, $0.value.sum()) }.map { $0 * $1 }
        return values.sum()
    }

    func prettyPrint() {
        let pairs = self.map { ($0.key, $0.value.map { String($0) }.joined())}.sorted { $0.0 < $1.0 }
        print(pairs.map { "\($0): \($1)"}.joined(separator: "\n"))
    }
}

private extension Sequence where Element == String {

    func parseInstructions() -> [Instruction] {
        var instructions: [Instruction] = []
        for line in self {
            let components = line.components(separatedBy: .whitespaces)
            if components[0] == "noop" {
                instructions.append(.noop)
            } else if components[0] == "addx" {
                let value = Int(components[1])!
                instructions.append(.addx(value))
            } else {
                fatalError("Unknown instruction: \(components[0])")
            }
        }
        return instructions
    }
}

private enum Instruction {
    case noop
    case addx(Int)
}

private class Processor {

    init(registries: [Int] = [1]) {
        self.registries = registries
    }

    private(set) var currentCycle: Int = 0
    private(set) var registries: [Int]

    private var timelines: [[Instruction]] = []

    func addInstructionsToTimeline(instructions: [Instruction]) {
        let noops = instructions.filter {
            if case .noop = $0 { return true }
            return false
        }
        let addxs = instructions.filter {
            if case .addx = $0 { return true }
            return false
        }
        var timelineInstructions: [Instruction] = Array(repeating: .noop, count: noops.count + addxs.count * 2)
        var index = 0
        for instruction in instructions.enumerated() {
            switch instruction.element {
            case .addx:
                timelineInstructions[index+1] = instruction.element
                index += 2
                break
            case .noop:
                index += 1
//                timelineInstructions.append(.noop)
            }
        }
        timelines.append(timelineInstructions)
    }

    func cycleProgram(firstSample: Int = 20, sampleInterval: Int = 40) -> [Int: [Int]] {
        var samples = [Int: [Int]]()
        let cycleCount = timelines[0].count
        var nextSample = firstSample
        for cycle in 0..<cycleCount {
            if cycle == nextSample - 1 {
                samples[cycle + 1] = registries
                nextSample = nextSample + sampleInterval
            }
            self.performCycle()
        }
        return samples
    }

    func cycle(count: Int) {
        for _ in 0..<count {
            performCycle()
        }
    }

    func performCycle() {
        let current = currentCycle
        currentCycle += 1
        for timeline in timelines.enumerated() {
            let timelineCycleInstruction = timeline.element[current]
            let currentValue = registries[timeline.offset]
            switch timelineCycleInstruction {
            case .noop:
                print("\(current): .noop \(currentValue)")
            case .addx(let value):
                let currentValue = registries[timeline.offset]
                let nextValue = currentValue + value
                print("\(current): .addx \(value) \(currentValue)=>\(nextValue)")
                registries[timeline.offset] = nextValue
            }
        }
    }
}
