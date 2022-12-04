public class Day_13 {

    func partOne(input: String) -> Int {
        let lines = input.lines
        let dataRows = lines.filter { $0.starts(with: "fold") == false }
        let foldRows = lines.filter { $0.starts(with: "fold") == true }

        let folds = foldRows.map { FoldingGrid.Fold(data: $0) }

        let grid = FoldingGrid(dataRows: dataRows)

        let foldedGrid = grid.fold([folds[0]])

        return foldedGrid.count
    }

    func partTwo(input: String) -> Int {
        let lines = input.lines
        let dataRows = lines.filter { $0.starts(with: "fold") == false }
        let foldRows = lines.filter { $0.starts(with: "fold") == true }

        let folds = foldRows.map { FoldingGrid.Fold(data: $0) }

        let grid = FoldingGrid(dataRows: dataRows)

        let foldedGrid = grid.fold(folds)
        debugPrint(data: foldedGrid)
        return foldedGrid.count
    }

    func debugPrint(data: [FoldingGrid.Point]) {
        let maxX = data.map { $0.x }.max() ?? 0
        let maxY = data.map { $0.y }.max() ?? 0

        for y in 0...maxY {
            var row: String = ""
            for x in 0...maxX {
                if data.first(where: { $0.x == x && $0.y == y }) != nil {
                    row.append("#")
                } else {
                    row.append(" ")
                }
            }
            print(row)
        }
    }
}

class FoldingGrid {

    struct Fold {

        enum Axis: String {
            case horizontal = "y"
            case vertical = "x"
        }

        init(data: String) {
            let input = data.split(separator: " ")[2].split(separator: "=")
            self.axis = Axis(rawValue: String(input[0])) ?? .vertical
            self.value = Int(String(input[1])) ?? 0
        }

        let value: Int
        let axis: Axis
    }

    struct Point: Hashable {

        init(data: String) {
            let dataPoint = data.split(separator: ",").compactMap{ Int($0) }
            self.x = dataPoint[0]
            self.y = dataPoint[1]
        }

        init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }

        let x, y: Int
    }

    init(dataRows: [String]) {
        var maxX = 0
        var maxY = 0
        var pointData: [Point] = []
        for row in dataRows {
            let point = Point(data: row)

            pointData.append(point)
            maxX = max(point.x, maxX)
            maxY = max(point.y, maxY)
        }
        self.maxX = maxX
        self.maxY = maxY
        self.data = pointData
    }

    let maxX: Int
    let maxY: Int
    let data: [Point]

    func fold(_ folds: [Fold]) -> [Point]{
        var result: [Point] = data
        for fold in folds {
            switch fold.axis {
            case .vertical:
                result = foldVertical(fold, data: result)
            case .horizontal:
                result = foldHorizontal(fold, data: result)
            }
        }
        return result
    }

    func foldVertical(_ fold: Fold, data: [Point]) -> [Point] {
        let sorted = data.sorted { $0.x < $1.x }
        let pointsAboveFold = Set(sorted.filter { $0.x < fold.value })
        let pointsBelowFold = sorted.filter { $0.x > fold.value }
        let movedPoints = Set(pointsBelowFold.map { Point(x: computeFoldValue(fold, value: $0.x), y: $0.y) })
        let setOfPoints = pointsAboveFold.union(movedPoints)
        return Array(setOfPoints)
    }

    func foldHorizontal(_ fold: Fold, data: [Point]) -> [Point] {
        let sorted = data.sorted { $0.y < $1.y }
        let pointsAboveFold = Set(sorted.filter { $0.y < fold.value })
        let pointsBelowFold = sorted.filter { $0.y > fold.value }
        let movedPoints = Set(pointsBelowFold.map { Point(x: $0.x, y: computeFoldValue(fold, value: $0.y)) })
        let setOfPoints = pointsAboveFold.union(movedPoints)
        return Array(setOfPoints)
    }

    func computeFoldValue(_ fold: Fold, value: Int) -> Int {
        switch fold.axis {
        case .vertical:
            return fold.value - (value - fold.value)
        case .horizontal:
            return fold.value - (value - fold.value)
        }
    }
}
