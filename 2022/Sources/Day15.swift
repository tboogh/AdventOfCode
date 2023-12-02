import AdventOfCodeCommon
import Foundation
import RegexBuilder

public struct Day15 {

    public static func partOne(input: String, row: Int) -> Int {
        let result = input.parseSensorsAndBeacons()
            .findPositionsOnRow(row: row)
        return result.count
    }

    public static func partTwo(input: String) -> Int {
        let result = input.parseSensorsAndBeacons()
            .findPositionsForBeacon()
            .uniquePositions


//        let tf = result.map { $0.tuningFrequency }
//            .sorted()
        return -1
    }
}

struct Point: Hashable {

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    let x: Int
    let y: Int
}

extension Point {

    var tuningFrequency: Int {
        x * 4_000_000 + y
    }
}

struct SensorsAndNearestBeacon {

    let sensor: Point
    let nearestBeacon: Point
}

extension SensorsAndNearestBeacon {

    var manhattanDistance: Int {
        let x = abs(sensor.x - nearestBeacon.x)
        let y = abs(sensor.y - nearestBeacon.y)

        return x + y
    }

    func findPositionsOnRow(row: Int) -> ClosedRange<Int>? {
//        print("Find positions for beacon at: \(nearestBeacon) from sensor: \(sensor)")
        let deltaX = manhattanDistance - abs(row - sensor.y)
        if deltaX > 0 {
            return sensor.x-deltaX...sensor.x+deltaX
        }
        return nil
    }

    func findPositionsAlongPerimeter(padding: Int = 1) -> [Point] {
        var positions = [Point]()
        let distance = manhattanDistance+padding
        for yValue in 0...distance {
            let xPositive = distance - yValue
            let yPositive = yValue%(distance+1)
            let xNegative = -xPositive
            let yNegative = -yPositive

            let topRight = Point(x: xPositive, y: yPositive)
            let bottomRight = Point(x: xPositive, y: yNegative)
            let bottomLeft = Point(x: xNegative, y: yNegative)
            let topLeft = Point(x: xNegative, y: yPositive)
            positions.append(contentsOf: [topRight, bottomRight, bottomLeft, topLeft])
        }
        return positions
    }
}

private extension Array where Element == Set<Point> {

    var uniquePositions: [Point] {
        var items = self
        var result = Set<Point>()
        while let next = items.popLast() {
            if result.isEmpty {
                result = next
                continue
            }
            result = result.intersection(next)
        }
//        let r = Array(result)
        return []
    }
}

private extension Array where Element == SensorsAndNearestBeacon {

    func findPositionForBeacon() -> Set<Point> {
        var points = Set<Point>()
        for item in self {
            let positions = Set(item.findPositionsAlongPerimeter())
            let possiblePositions = positions.subtracting(points)
            points = points.union(possiblePositions)
        }
        return points
    }

    func findPositionsForBeacon() -> [Set<Point>] {
        var points = [Set<Point>]()
        for item in self {
            let positions = Set(item.findPositionsAlongPerimeter())
            points.append(positions)
        }
        return points
    }

    func findPositionsOnRow(row: Int) -> [Int] {
        var positions = Set<Int>()
        for sensorsAndNearestBeacon in self {
            if let range = sensorsAndNearestBeacon.findPositionsOnRow(row: row) {
                positions = positions.union(range)
            }
            if sensorsAndNearestBeacon.nearestBeacon.y == row {
                positions = positions.subtracting([sensorsAndNearestBeacon.nearestBeacon.x])
            }
        }
        return Swift.Array(positions)
    }

    func findPositionsInRowRange(range: ClosedRange<Int>) -> [Int:[Int]] {
        var result = [Int:[Int]]()
        for row in range {
            let rowResult = findPositionsOnRow(row: row).sorted()
            result[row] = rowResult
        }
        return result
    }
}

extension String {

    func parseSensorsAndBeacons() -> [SensorsAndNearestBeacon] {
        let regex = Regex {
            "Sensor at x="
            Capture {
                Optionally { "-" }
                OneOrMore(.digit)
            }
            ", y="
            Capture {
                Optionally { "-" }
                OneOrMore(.digit)
            }
            ": closest beacon is at x="
            Capture {
                Optionally { "-" }
                OneOrMore(.digit)
            }
            ", y="
            Capture {
                Optionally { "-" }
                OneOrMore(.digit)
            }
        }
        var result = [SensorsAndNearestBeacon]()
        for line in self.lines {
            guard
                let matches = try? regex.firstMatch(in: line),
                let sensorX = Int(String(matches.output.1)),
                let sensorY = Int(String(matches.output.2)),
                let beaconX = Int(String(matches.output.3)),
                let beaconY = Int(String(matches.output.4))
            else { continue }

            let sensor = Point(x: sensorX, y: sensorY)
            let beacon = Point(x: beaconX, y: beaconY)
            result.append(SensorsAndNearestBeacon(sensor: sensor, nearestBeacon: beacon))
        }
        return result
    }
}
