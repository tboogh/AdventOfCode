import AdventOfCodeCommon
import Foundation

public struct Day9 {

    public static func partOne(input: [String]) -> Int {
        let moves = input.parseToMoves()

        let tailPositions = moves
            .computeHeadPostions()
            .computeTailPositions()
        let size = tailPositions.size()
        let uniqueTailPositions = Set(tailPositions)
        tailPositions.printPositions(gridSize: size)
        return uniqueTailPositions.count
    }

    public static func partTwo(input: [String]) -> Int {
        return -1
    }
}

private struct Size {

    let width: Int
    let height: Int
}

private enum Move {
    case left(Int)
    case right(Int)
    case down(Int)
    case up(Int)
}

private struct Position: Hashable, CustomDebugStringConvertible {

    let x: Int
    let y: Int

    static func -(lhs: Position, rhs: Position) -> Position {
        Position(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    var magnitude: Float {
        sqrt(Float(x * x) + Float(y * y))
    }

    var debugDescription: String {
        "(x:\(x) y:\(y))"
    }
}

private extension Array where Element == Position {

    func computeTailPositions() -> [Position] {
        var tailPosition = Position(x: 0, y: 0)
        var tailPositions = [tailPosition]
        for headPosition in self {
            let diff = headPosition - tailPosition
//            print("h: \(headPosition) t:\(tailPosition) m:\(diff.magnitude)")
            if diff.x == 0 && diff.y == 0 {
                tailPositions.append(tailPosition)
                continue
            }
            if diff.magnitude <= 1.0 {
                tailPositions.append(tailPosition)
                continue
            }
            //            print(diff.magnitude)
            if diff.x == 0 {
                // Straight vertical move
                tailPosition = Position(x: tailPosition.x, y: tailPosition.y + diff.y.signum())
                tailPositions.append(tailPosition)
                continue
            }
            if diff.y == 0 {
                // Straight horizontal move
                tailPosition = Position(x: tailPosition.x + diff.x.signum(), y: tailPosition.y)
                tailPositions.append(tailPosition)
                continue
            }
            if abs(diff.x) == 1 && abs(diff.y) == 1 {
                tailPositions.append(tailPosition)
                continue
            } else {
                let xMove = diff.x.clamped(to: -1...1)
                let yMove = diff.y.clamped(to: -1...1)
                tailPosition = Position(x: tailPosition.x + xMove,
                                        y: tailPosition.y + yMove)
            }
            tailPositions.append(tailPosition)
        }
        return tailPositions
    }

    func size() -> Size {
        var width = 0
        var height = 0
        for position in self {
            width = Swift.max(width, position.x)
            height = Swift.max(height, position.y)
        }
        return Size(width: width + 1, height: height + 1)
    }
}

private extension Sequence where Element == Position {

    func printPositions(gridSize: Size) {
        var grid = Array(repeating: Array(repeating: ".", count: gridSize.width), count: gridSize.height)
        for position in self {
            grid[position.y][position.x] = "#"
        }
        let printGrid = grid.reversed()
        for row in printGrid {
            print(row.joined())
        }
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

private extension Array where Element == Move {

    func computeHeadPostions() -> [Position] {
        var headPosition = Position(x: 0, y: 0)
        var headPositions = [headPosition]
        for move in self {
            switch move {
            case .left(let distance):
                for _ in 0..<distance {
                    headPosition = Position(x: headPosition.x - 1, y: headPosition.y)
                    headPositions.append(headPosition)
                }
            case .right(let distance):
                for _ in 0..<distance {
                    headPosition = Position(x: headPosition.x + 1, y: headPosition.y)
                    headPositions.append(headPosition)
                }
            case .down(let distance):
                for _ in 0..<distance {
                    headPosition = Position(x: headPosition.x, y: headPosition.y - 1)
                    headPositions.append(headPosition)
                }
            case .up(let distance):
                for _ in 0..<distance {
                    headPosition = Position(x: headPosition.x, y: headPosition.y + 1)
                    headPositions.append(headPosition)
                }
            }
        }
        return headPositions
    }
}

private extension Array where Element == String {

    func parseToMoves() -> [Move] {
        var moves = [Move]()
        for row in self {
            let components = row.split(separator: " ")
            let direction = components[0]
            let value = Int(components[1])!
            if direction == "U" {
                moves.append(Move.up(value))
            }
            if direction == "D" {
                moves.append(Move.down(value))
            }
            if direction == "L" {
                moves.append(Move.left(value))
            }
            if direction == "R" {
                moves.append(Move.right(value))
            }
        }
        return moves
    }
}
