import AdventOfCodeCommon
import Foundation
import RegexBuilder

public struct Day15 {

    public static func partOne(input: String, row: Int) -> Int {
        let result = input.parseSensorsAndBeacons()
            .findPositionsOnRow(row: row)
        return result
    }

    public static func partTwo(input: String) -> Int {
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
        print("Find positions for beacon at: \(nearestBeacon) from sensor: \(sensor)")
        let deltaX = manhattanDistance - abs(row - sensor.y)
        if deltaX > 0 {
            return sensor.x-deltaX...sensor.x+deltaX
        }
        return nil
    }
}

private extension Array where Element == SensorsAndNearestBeacon {

    func findPositionsOnRow(row: Int) -> Int {
        var positions = Set<Int>()
        for sensorsAndNearestBeacon in self {
            if let range = sensorsAndNearestBeacon.findPositionsOnRow(row: row) {
                positions = positions.union(range)
            }
            if sensorsAndNearestBeacon.nearestBeacon.y == row {
                positions = positions.subtracting([sensorsAndNearestBeacon.nearestBeacon.x])
            }
        }
        return positions.count
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
