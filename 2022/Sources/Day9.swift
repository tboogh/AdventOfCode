import AdventOfCodeCommon
import Foundation

public struct Day9 {

    public static func partOne(input: [String]) -> Int {
        let moves = input.parseToMoves()

        let tailPositions = moves
            .computeHeadPostions()
            .computeTailPositions(numberOfTails: 1)
            .first!
        let size = tailPositions.size()
        let uniqueTailPositions = Set(tailPositions)
        tailPositions.printPositions(gridSize: size)
        return uniqueTailPositions.count
    }

    public static func partTwo(input: [String]) -> Int {
        let moves = input.parseToMoves()

        let headPositions = moves
            .computeHeadPostions()
        let tailPositions = headPositions
            .computeTailPositions(numberOfTails: 10)
        let size = headPositions.size()
//        tailPositions.printPositions(gridSize: size, symbol: "#")
        let uniqueTailPositions = Set(tailPositions)

        return uniqueTailPositions.count
    }
}

private struct Size {

    let minX: Int
    let maxX: Int
    let minY: Int
    let maxY: Int
    
    var width: Int {
        let width = maxX - minX
        return width + 1
    }
    var height: Int {
        let height = maxY - minY
        return height + 1
    }

    var offsetX: Int {
        abs(minX)
    }

    var offsetY: Int {
        abs(minY)
    }
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

    func computeTailPositions(numberOfTails: Int) -> [[Position]] {
        var tailPositionsCollection = (0..<numberOfTails).map { _ in [Position(x: 0, y: 0)] }
        for headPosition in self {
            let position = headPosition
            for tailIndex in 0..<numberOfTails {
                var tailPositions = tailPositionsCollection[tailIndex]
                var tailPosition = tailPositions.last!
                tailPosition = tailPosition.computeNextPosition(previousPosition: position)
                tailPositions.append(tailPosition)
                tailPositionsCollection[tailIndex] = tailPositions
            }
        }
        return tailPositionsCollection
    }

    func size() -> Size {
        var minX = 0
        var maxX = 0
        var minY = 0
        var maxY = 0

        for position in self {
            minX = Swift.min(minX, position.x)
            maxX = Swift.max(maxX, position.x)
            minY = Swift.min(minY, position.y)
            maxY = Swift.max(maxY, position.y)
        }
        return Size(minX: minX,
                    maxX: maxX,
                    minY: minY,
                    maxY: maxY)
    }
}

private extension Position {

    func computeNextPosition(previousPosition: Position) -> Position {
        let diff = previousPosition - self
        if diff.x == 0 && diff.y == 0 ||
            diff.magnitude <= 1.0 ||
            abs(diff.x) == 1 && abs(diff.y) == 1 {
            return self
        }
        if diff.x == 0 {
            return Position(x: self.x, y: self.y + diff.y.signum())
        }
        if diff.y == 0 {
            return Position(x: self.x + diff.x.signum(), y: self.y)
        }
        let xMove = diff.x.clamped(to: -1...1)
        let yMove = diff.y.clamped(to: -1...1)
        return Position(x: self.x + xMove,
                                y: self.y + yMove)
    }
}

private extension Sequence where Element == Position {

    func printPositions(gridSize: Size, symbol: String = "#") {
        var grid = Array(repeating: Array(repeating: ".", count: gridSize.width), count: gridSize.height)
        for position in self {
            let x = gridSize.offsetX + position.x
            let y = gridSize.offsetY + position.y
            grid[y][x] = symbol
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
