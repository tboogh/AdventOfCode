open class Grid<T: Equatable> {

    public init(from input: [[T]]) {
        var data: [[GridNode<T>]] = []
        for line in input.enumerated() {
            var row = [GridNode<T>]()
            for item in line.element.enumerated() {
                let result = GridNode(position: GridPosition(x: item.offset, y: line.offset),
                                      value: item.element)
                row.append(result)
            }
            data.append(row)
        }
        self.data = data
    }

    public var data: [[GridNode<T>]]

    public var width: Int {
        data.first?.count ?? 0
    }

    public var height: Int {
        data.count
    }

    open func neighbors(value: T, position: GridPosition) -> [(GridPosition, GridNode<T>)] {
        var x = position.x
        var y = position.y
        if x > width { x = width - 1 }
        if y > height { y = height - 1 }
        if x < 0 { x = 0 }
        if y < 0 { y = 0 }
        let minX = max(0, x - 1)
        let maxX = min(width - 1, x + 1)
        let minY = max(0, y - 1)
        let maxY = min(height - 1, y + 1)
        let xRange = minX...maxX
        let yRange = minY...maxY
        if xRange.isEmpty || yRange.isEmpty { return [] }

        var values: [(GridPosition, GridNode<T>)] = []
        for x in xRange {
            for y in yRange {
                values.append((GridPosition(x: x, y: y), data[y][x]))
            }
        }
        return values
    }
}

extension Grid: CustomStringConvertible {

    public var description: String {
        let output = data.map { $0.map { $0.description }
            .joined(separator: "") }
            .joined(separator: "\n")
        return output
    }
}

extension Grid {

    public func printNodes(visitedNodes: [GridNode<T>], symbol: String) {
        let output = data.map { $0.map { visitedNodes.contains($0) ? symbol: "\($0.value)" }
            .joined(separator: "") }
            .joined(separator: "\n")
        print(output)
    }
}

public struct GridNode<T>: Hashable, CustomStringConvertible {

    public init(position: GridPosition,
                value: T) {
        self.position = position
        self.value = value
    }


    public let position: GridPosition
    public let value: T
    public var description: String { "\(value)" }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(position)
    }

    public static func == (lhs: GridNode<T>, rhs: GridNode<T>) -> Bool {
        lhs.position == rhs.position
    }
}
