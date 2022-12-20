import AdventOfCodeCommon
import Foundation

public struct Day14 {

    public static func partOne(input: String) -> Int {
        let shapes = input.parseToShapes()
        let grid = shapes.createGrid()
        let simulation = SandSimulation(grid: grid)
        simulation.simulateSteps(steps: Int.max)
        let sandCount = grid.countSand()
        return sandCount
    }

    public static func partTwo(input: String) -> Int {
        let shapes = input.parseToShapes()
        let grid = shapes.createGrid()
        grid.appendRows(rows: 2)
        let simulation = SandSimulation(grid: grid)
        simulation.simulateSteps(steps: 400, fill: true)
        let sandCount = grid.countSand()
        return sandCount
    }
}

private extension String {

    func parseToShapes() -> [Shape] {
        let decoder = JSONDecoder()
        var shapes = [Shape]()
        for line in self.lines {
            let arrayLine = "[\(line.replacingOccurrences(of: " -> ", with: ","))]"
            print(arrayLine)
            let result = try! decoder.decode([Int].self, from: arrayLine.data(using: .utf8)!)
            let parsedPositions = result.parse()
            shapes.append(Shape(positions: parsedPositions))
        }
        return shapes
    }
}

private class SandSimulation {

    init(grid: Grid<GridVector>,
         sandStartPosition: Int = 500) {
        self.grid = grid
        self.sandStartPosition = sandStartPosition
    }

    private let grid: Grid<GridVector>
    private let sandStartPosition: Int

    func simulateSteps(steps: Int, fill: Bool = false) {
        guard
            let firstHorizontalElement = grid.leftMostElement(),
            let lastVerticalElement = grid.bottomElement()
        else { return }
        var currentStep = 0
        let leftStart = fill ? 0: firstHorizontalElement.position.x - 1
        var currentSand: GridPosition = spawnSand()
        repeat {
            let neighbors = grid.neighbors(position: currentSand).filter { $0.1.vector != nil }
            if neighbors.isEmpty {
                currentSand = GridPosition(x: currentSand.x, y: currentSand.y + 1)
            } else {
                let lowerNeighbors = neighbors.filter { $0.1.position.y > currentSand.y }
                let leftNeighbor = lowerNeighbors.first(where: { $0.0.x < currentSand.x })
                let rightNeighbor = lowerNeighbors.first(where: { $0.0.x > currentSand.x })
                let bottomNeighbor = lowerNeighbors.first(where: { $0.0.x == currentSand.x })

                switch (leftNeighbor, bottomNeighbor, rightNeighbor) {
                case (_, nil, _):
                    currentSand = GridPosition(x: currentSand.x, y: currentSand.y + 1)
                case (nil, _, _):
                    currentSand = GridPosition(x: currentSand.x - 1, y: currentSand.y + 1)
                case (_, _, nil):
                    currentSand = GridPosition(x: currentSand.x + 1, y: currentSand.y + 1)
                case (_, _, _):
                    grid.data[currentSand.y][currentSand.x] = GridVector(vector: Vector2(x: 999, y: 999), position: currentSand)
                    currentSand = spawnSand()
                }
            }
            if fill {
                if currentSand.y == lastVerticalElement.position.y + 2 {
                    grid.data[currentSand.y][currentSand.x] = GridVector(vector: Vector2(x: 999, y: 999), position: currentSand)
                    let startPosition = grid.data[0][500]
                    if startPosition.vector != nil {
                        print("Done")
                        grid.printGrid(leftStart: leftStart, sandPosition: currentSand)
                        return
                    }
                    currentSand = spawnSand()
                }
            } else {
                if currentSand.y > lastVerticalElement.position.y {
                    print("Done")
                    grid.printGrid(leftStart: leftStart, sandPosition: currentSand)
                    return
                }
            }
            currentStep += 1
            if currentStep >= steps {
                grid.printGrid(leftStart: leftStart, sandPosition: currentSand)
                return
            }
        } while true
    }

    func spawnSand() -> GridPosition {
        GridPosition(x: 500, y: 0)
    }
}

private struct GridVector: Equatable, CustomStringConvertible {

    private(set) var vector: Vector2?
    let position: GridPosition

    var description: String { "" }

    mutating func updateVector(vector: Vector2) {
        self.vector = vector
    }
}

private struct Shape {

    let positions: [GridPosition]

    var maxX: Int {
        positions.map { $0.x }.max() ?? 0
    }

    var maxY: Int {
        positions.map { $0.y }.max() ?? 0
    }
}

private extension Array where Element == Shape {

    func createGrid() -> Grid<GridVector> {
        let grid = Grid<GridVector>(data: [[]])
        for shape in self {
            grid.appendShape(shape: shape)
        }
        guard let bottomElement = grid.bottomElement() else { return grid }
        
        return grid
    }
}

private extension Array where Element == Int {

    func parse() -> [GridPosition] {
        var positions = [GridPosition]()
        for index in stride(from: 0, to: self.count, by: 2) {
            positions.append(GridPosition(x: self[index], y: self[index + 1]))
        }
        return positions
    }
}

private extension Grid where T == GridVector {

    func countSand() -> Int {
        data.flatMap { $0.filter { $0.vector?.x == 999 } }.count
    }

    func printGrid(leftStart: Int = 0, sandPosition: GridPosition) {
        func symbol(for gridVector: GridVector, sandPosition: GridPosition) -> String {
            if gridVector.position == sandPosition {
                return "🟧"
            }
            guard let vector = gridVector.vector else { return "⬛️" }
            if vector.x == 999 && vector.y == 999 {
                return "🟧"
            }
            if vector.x == 888 && vector.y == 888 {
                return "🟫"
            }
            if vector.x < 0 && vector.y < 0 {
                return "↙️"
            }
            if vector.x > 0 && vector.y < 0 {
                return "↘️"
            }
            if vector.x == 0 && vector.y < 0 {
                return "⬇️"
            }
            return "🟪"
        }

        let rows = data.map { $0.filter { $0.position.x >= leftStart }.map { symbol(for: $0, sandPosition: sandPosition) }
            .joined(separator: "") }
        let output = rows
            .joined(separator: "\n")
        Swift.print(output)
    }

    func leftMostElement() -> GridVector? {
        let fields = data.flatMap { $0.filter { $0.vector != nil } }
        let smallestX = fields.sorted(by: { $0.position.x < $1.position.x }).first
        return smallestX
    }

    func bottomElement() -> GridVector? {
        let fields = data.flatMap { $0.filter { $0.vector != nil } }
        let bottomY = fields.sorted(by: { $0.position.y > $1.position.y }).first
        return bottomY
    }

    func appendShape(shape: Shape) {
        let maxX = shape.maxX + 1
        let maxY = shape.maxY + 1
        let currentX = data[0].count
        if currentX < maxX {
            // Expand row widths
            for index in 0..<data.count {
                var row = data[index]
                row.append(contentsOf: (currentX..<maxX).map { GridVector(position: GridPosition(x: $0, y: index))})
                data[index] = row
            }
        }
        let currentY = data.count
        if currentY < maxY {
            for y in currentY..<maxY {
                let emptyRow = (0..<max(maxX, currentX)).map { GridVector(position: GridPosition(x: $0, y: y))}
                data.append(emptyRow)
            }
        }

        for index in 1..<shape.positions.count {
            let start = shape.positions[index - 1]
            let end = shape.positions[index]
            if start.x == end.x {
                // draw vertical
                let minY = min(start.y, end.y)
                let maxY = max(start.y, end.y)
                for yValue in minY...maxY {
                    data[yValue][start.x] = GridVector(
                        vector: Vector2(x: 888, y: 888),
                        position: GridPosition(x: start.x, y: yValue))
                }
            }
            if start.y == end.y {
                // draw horizontal
                let minX = min(start.x, end.x)
                let maxX = max(start.x, end.x)
                for xValue in minX...maxX {
                    data[start.y][xValue] = GridVector(
                        vector: Vector2(x: 888, y: 888),
                        position: GridPosition(x: xValue, y: start.y))
                }
            }
        }
    }

    func appendRows(rows count: Int) {
        let maxX = data[0].count
        for yIndex in data.count..<data.count + count {
            let emptyRow = (0..<maxX).map { GridVector(position: GridPosition(x: $0, y: yIndex))}
            data.append(emptyRow)
        }
    }
}
