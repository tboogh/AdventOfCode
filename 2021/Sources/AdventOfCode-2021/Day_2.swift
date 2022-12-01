fileprivate enum Direction {
    case forward
    case up
    case down
}

fileprivate struct Instruction {

    let direction: Direction
    let value: Int
}

private struct Vector<T: Numeric> {

    let x: T
    let y: T
}

public class Day_2 {

    func partOne(input: [String]) -> Int {
        let directions = parseData(data: input)
        let horizontal = directions
            .filter { $0.isHorizontal }
            .map { $0.value }
            .reduce(0, +)

        let vertical = directions
            .filter { $0.isVertical }
            .map { $0.value }
            .reduce(0, +)

        return abs(horizontal * vertical)
    }

    func partTwo(input: [String]) -> Int {
        let instructions = parseData(data: input)

        var aim = 0
        var position = 0
        var depth = 0
        for instruction in instructions {
            switch instruction.direction {
            case .forward:
                depth += instruction.value * aim
                position += instruction.value
            case .up:
                aim += instruction.value
            case .down:
                aim += instruction.value
            }
        }

        return abs(depth * position)
    }
}

private extension Instruction {

    var isHorizontal: Bool {
        switch self.direction {
        case .forward:
            return true
        default:
            return false
        }
    }

    var isVertical: Bool {
        switch self.direction {
        case .forward:
            return false
        default:
            return true
        }
    }
}

private extension Day_2 {



    func parseData(data: [String]) -> [Instruction] {
        return data.compactMap {
            let direction = $0.split(separator: " ")
            let value = Int(direction[1]) ?? 0
            switch direction[0] {
            case "forward":
                return Instruction(direction: .forward, value: value)
            case "up":
                return Instruction(direction: .up, value: -value)
            case "down":
                return Instruction(direction: .down, value: value)
            default:
                return nil
            }
        }
    }
}
