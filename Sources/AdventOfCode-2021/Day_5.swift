import Foundation

public class Day_5 {

    init(input: String) {
        let lines = input
            .split(separator: "\n")
            .drop { $0.isEmpty }
            .map { $0.components(separatedBy: " -> ") }
            .compactMap { Line(input: $0) }
        graph = Graph(lines: lines)
    }

    private let graph: Graph

    func partOne() -> Int {
        return graph.computeAnswer()
    }

    func partTwo() -> Int {
        return 0
    }
}

class Graph {

    init(lines: [Line]) {

        let xValues = lines.flatMap { [$0.start.x, $0.end.x] }
        let minX = xValues.reduce(0, { min($0, $1) })
        let maxX = xValues.reduce(0, { max($0, $1) })
        let yValues = lines.flatMap { [$0.start.y, $0.end.y] }
        let minY = yValues.reduce(0, { min($0, $1) })
        let maxY = yValues.reduce(0, { max($0, $1) })

        let graph = Array(repeating: Array(repeating: 0, count: maxX - minX + 1), count: maxY - minY + 1)

        self.graph = graph
        self.lines = lines
        self.minX = minX
        self.minY = minY
        self.maxX = maxX
        self.maxY = maxY
    }

    private let minX: Int
    private let maxX: Int
    private let minY: Int
    private let maxY: Int
    private var graph: [[Int]]
    private let lines: [Line]

    public func computeAnswer() -> Int {
        for line in lines {
            if !line.isHorizontal && !line.isVertical {
                continue
            }
            let minX = min(line.start.x, line.end.x)
            let maxX = max(line.start.x, line.end.x)
            let minY = min(line.start.y, line.end.y)
            let maxY = max(line.start.y, line.end.y)

            for x in minX...maxX {
                for y in minY...maxY {
                    graph[y][x] += 1

                }
            }
        }
        return graph.flatMap { $0 }.filter { $0 > 1 }.count
    }

    func debugPrint(graph: [[Int]]) {
        for rowindex in 0..<graph.count {
            let row = graph[rowindex]
            print("\(row.reduce("") { $0 + "\($1)" })")
        }
    }
}

struct Point {

    init(input: String) {
        let data = input.components(separatedBy: ",")
        x = Int(data[0]) ?? 0
        y = Int(data[1]) ?? 0
    }

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    let x: Int
    let y: Int
}

struct Line {

    init(input: [String]) {
        start = Point(input: input[0])
        end = Point(input: input[1])
    }

    let start: Point
    let end: Point

    var isHorizontal: Bool {
        start.y == end.y
    }

    var isVertical: Bool {
        start.x == end.x
    }
}
