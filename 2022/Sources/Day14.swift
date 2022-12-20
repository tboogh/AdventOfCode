import AdventOfCodeCommon
import Foundation

public struct Day14 {

    public static func partOne(input: String) -> Int {
        let objects = input
            .parseToObjects()
        let simulation = SandSimulation(objects: objects)
        simulation.simulateSteps(steps: Int.max)

        let sandCount = simulation.countSand()
        return sandCount
    }

    public static func partTwo(input: String) -> Int {
        let objects = input
            .parseToObjects()
        let simulation = SandSimulation(objects: objects)
        simulation.simulateSteps(steps: Int.max, partTwo: true)

        let sandCount = simulation.countSand()
        return sandCount
    }
}

private enum SquareType {

    case air
    case ground
    case sand
}

extension SquareType: CustomStringConvertible {

    var description: String {
        switch self {
        case .air: return "⬛️"
        case .ground: return "🟫"
        case .sand: return "🟧"
        }
    }
}

private struct Object {

    let squareType: SquareType
    let position: IntVector2
}

private extension String {

    func parseToObjects() -> [IntVector2: SquareType] {
        let decoder = JSONDecoder()
        var objects = [IntVector2: SquareType]()
        for line in self.lines {
            let arrayLine = "[\(line.replacingOccurrences(of: " -> ", with: ","))]"
            let result = try! decoder.decode([Int].self, from: arrayLine.data(using: .utf8)!)
            let gridPositions = result.parseGridPositions()
            let gridObjects = gridPositions.parseToObjects()
            objects = objects.merging(gridObjects) { (_, new) in new }
        }
        return objects
    }
}

private extension Array where Element == Int {

    func parseGridPositions() -> [GridPosition] {
        var positions = [GridPosition]()
        for index in stride(from: 0, to: self.count, by: 2) {
            positions.append(GridPosition(x: self[index], y: self[index + 1]))
        }
        return positions
    }
}

private extension Array where Element == GridPosition {

    func parseToObjects() -> [IntVector2: SquareType] {
        var objects = [IntVector2: SquareType]()
        for index in 1..<self.count {
            let start = self[index - 1]
            let end = self[index]
            if start.x == end.x {
                // draw vertical
                let minY = Swift.min(start.y, end.y)
                let maxY = Swift.max(start.y, end.y)
                for yValue in minY...maxY {
                    let position = Vector2(x: start.x, y: yValue)
                    objects[position] = .ground
                }
            }
            if start.y == end.y {
                // draw horizontal
                let minX = Swift.min(start.x, end.x)
                let maxX = Swift.max(start.x, end.x)
                for xValue in minX...maxX {
                    let position = Vector2(x: xValue, y: start.y)
                    objects[position] = .ground
                }
            }
        }
        return objects
    }
}

private extension Dictionary where Key == IntVector2, Value == SquareType {

    var horizontalBounds: (Int, Int) {
        let sortedX = self.keys.sorted(by: { $0.x < $1.x })
        let minX = sortedX.first?.x
        let maxX = sortedX.last?.x
        return (minX ?? 0, maxX ?? 0)
    }

    var verticalBounds: (Int, Int) {
        let sortedY = self.keys.sorted(by: { $0.y < $1.y })
        let maxY = sortedY.last?.y
        return (0, maxY ?? 0)
    }

    func printObjects() {

        let (minX, maxX) = horizontalBounds
        let (minY, maxY) = verticalBounds

        let normalizedMaxY = maxY - minY
        let normalizedMaxX = maxX - minX

        var grid = [String]()
        for y in 0..<normalizedMaxY+1 {
            var row = ""
            for x in 0..<normalizedMaxX+1 {
                let position = IntVector2(x: minX + x, y: minY + y)
                if let object = self[position] {
                    row.append(object.description)
                } else {
                    row.append(SquareType.air.description)
                }
            }
            grid.append(row)
        }

        let output = grid.joined(separator: "\n")
        Swift.print(output)
    }
}

private class SandSimulation {

    init(objects: [IntVector2: SquareType]) {
        self.objects = objects
    }

    private var objects: [IntVector2: SquareType]
    private let sandStartPosition = 500

    func simulateSteps(steps: Int, partTwo: Bool = false) {
        let debugPrint = false

        let (_, maxY) = objects.verticalBounds

        var currentStep = 0
        var currentSandPosition: IntVector2 = IntVector2(x: 500, y: 0)
        repeat  {
            if debugPrint {
                print("===== \(currentStep) =====")
                var printObjects = objects
                printObjects[currentSandPosition] = .sand
                printObjects.printObjects()
            }
            if currentStep >= steps {
                return
            }
            currentStep += 1

            if currentSandPosition.y > maxY && !partTwo{
                return
            }

            let nextY = currentSandPosition.y + 1
            let leftBlockerPosition = IntVector2(x: currentSandPosition.x - 1, y: nextY)
            let middleBlockerPosition = IntVector2(x: currentSandPosition.x, y: nextY)
            let rightBlockerPosition = IntVector2(x: currentSandPosition.x + 1, y: nextY)

            let leftBlocker = objects[leftBlockerPosition]
            let middleBlocker = objects[middleBlockerPosition]
            let rightBlocker = objects[rightBlockerPosition]

            if [leftBlocker, middleBlocker, rightBlocker].isEmpty {
                currentSandPosition = IntVector2(x: currentSandPosition.x, y: currentSandPosition.y + 1)
                continue
            }

            switch (leftBlocker, middleBlocker, rightBlocker) {
            case (_, nil, _):
                currentSandPosition = IntVector2(x: currentSandPosition.x, y: currentSandPosition.y + 1)
            case (nil, _, _):
                currentSandPosition = IntVector2(x: currentSandPosition.x - 1, y: currentSandPosition.y + 1)
            case (_, _, nil):
                currentSandPosition = IntVector2(x: currentSandPosition.x + 1, y: currentSandPosition.y + 1)
            case (_, _, _):
                objects[currentSandPosition] = .sand
                currentSandPosition = IntVector2(x: 500, y: 0)
            }
            if currentSandPosition.y == maxY + 1 &&  partTwo {
                objects[currentSandPosition] = .sand
                currentSandPosition = IntVector2(x: 500, y: 0)
            }
            if partTwo,
               let _ = objects[IntVector2(x: 500, y: 0)] {
                objects.printObjects()
                return
            }

        } while true
    }

    func countSand() -> Int {
        objects.values.filter { $0 == .sand}.count
    }
}
