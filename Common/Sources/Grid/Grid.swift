open class Grid<T: Equatable> {

    public init(data: [[T]]) {
        self.data = data
        var gridNodes = [GridNode<T>]()
        for rowIndex in 0..<data.count {
            let row = data[rowIndex]
            for columnIndex in 0..<row.count {
                let item = row[columnIndex]
                let position = GridPosition(x: columnIndex, y: rowIndex)
                let node = GridNode(position: position, value: item)
                gridNodes.append(node)
            }
        }
        self.gridNodes = gridNodes
    }

    public let data: [[T]]
    public let gridNodes: [GridNode<T>]

    public var width: Int {
        data.first?.count ?? 0
    }

    public var height: Int {
        data.count
    }

    open func neighbors(position: GridPosition) -> [(GridPosition, T)] {
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

        var values: [(GridPosition, T)] = []
        for x in xRange {
            for y in yRange {
                values.append((GridPosition(x: x, y: y), data[y][x]))
            }
        }
        return values
    }
}

public struct GridNode<T>: Hashable {

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
