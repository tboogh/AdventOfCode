public class Day_9 {

    func partOne(input: String) -> Int {

        let heightPoints = compute(input)
        let lowPoints = heightPoints.flatMap { $0 }.filter { $0.isLowPoint }

        return lowPoints.map { $0.value + 1 }.reduce(0, +)
    }

    func partTwo(input: String) -> Int {
        let heightPoints = compute(input)
        let lowPoints = heightPoints.flatMap { $0 }.filter { $0.isLowPoint }

        var results = [Set<HeightPoint>]()
        for lowPoint in lowPoints {
            let result = calculateValue(lowPoint, heightPoints: heightPoints)
            results.append(result)
        }
        let sorted = results.sorted { $0.count > $1.count }
        return sorted.prefix(3).map { $0.count }.reduce(1,*)
    }

    func calculateValue(_ heightPoint: HeightPoint, heightPoints: [[HeightPoint]]) -> Set<HeightPoint> {
        var pointsInBasin = Set<HeightPoint>()
        guard heightPoint.value != 9 else { return pointsInBasin }

        let x = heightPoint.x
        let y = heightPoint.y
        if heightPoint.isNorthHigher && heightPoint.north != 99 {
            let points = calculateValue(heightPoints[y - 1][x], heightPoints: heightPoints)
            pointsInBasin = pointsInBasin.union(points)
        }

        if heightPoint.isEastHigher && heightPoint.east != 99 {
            let points = calculateValue(heightPoints[y][x + 1], heightPoints: heightPoints)
            pointsInBasin = pointsInBasin.union(points)
        }

        if heightPoint.isSouthHigher && heightPoint.south != 99  {
            let points = calculateValue(heightPoints[y + 1][x], heightPoints: heightPoints)
            pointsInBasin = pointsInBasin.union(points)
        }

        if heightPoint.isWestHigher && heightPoint.west != 99  {
            let points = calculateValue(heightPoints[y][x - 1], heightPoints: heightPoints)
            pointsInBasin = pointsInBasin.union(points)
        }

        return pointsInBasin.union([heightPoint])
    }

    func inBounds(_ value: Int, min: Int, max: Int) -> Bool {
        value >= min && value < max
    }

    func compute(_ input: String) -> [[HeightPoint]] {
        let grid = input
            .components(separatedBy: .newlines)
            .map { $0.compactMap { Int(String($0)) }}
            .filter { $0.count > 0 }
        let height = grid.count
        let width = grid.max { $0.count < $1.count }?.count ?? 0

        var heightPoints = [[HeightPoint]]()

        for y in 0..<height {
            var row = [HeightPoint]()
            for x in 0..<width {
                let north = y - 1
                let east = x + 1
                let south = y + 1
                let west = x - 1

                let value = grid[y][x]
                var northValue = 99
                var eastValue = 99
                var southValue = 99
                var westValue = 99

                if inBounds(north, min: 0, max: height) {
                    northValue = grid[north][x] - value
                }

                if inBounds(east, min: 0, max: width) {
                    eastValue = grid[y][east] - value
                }

                if inBounds(south, min: 0, max: height) {
                    southValue = grid[south][x] - value
                }

                if inBounds(west, min: 0, max: width) {
                    westValue = grid[y][west] - value
                }
                row.append(HeightPoint(x: x, y: y, value: value, north: northValue, east: eastValue, south: southValue, west: westValue))
            }
            heightPoints.append(row)
        }
        return heightPoints
    }
}

struct HeightPoint: Hashable {

    let x: Int
    let y: Int
    let value: Int
    let north: Int
    let east: Int
    let south: Int
    let west: Int
}

extension HeightPoint {

    var isLowPoint: Bool {
        isNorthHigher &&
        isEastHigher &&
        isSouthHigher &&
        isWestHigher
    }

    var isNorthHigher: Bool {
        north > 0
    }

    var isEastHigher: Bool {
        east > 0
    }

    var isSouthHigher: Bool {
        south > 0
    }

    var isWestHigher: Bool {
        west > 0
    }
}
