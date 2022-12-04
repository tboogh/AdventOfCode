public class Day_11 {

    func partOne(input: String, iterations: Int = 2) -> Int {
        let rows = input.lines
        let data = rows.map { $0.compactMap { Int(String($0)) } }
        return simulate(iterations, data: data)
    }

    func partTwo(input: String) -> Int {
        let rows = input.lines
        let data = rows.map { $0.compactMap { Int(String($0)) } }
        return simulateSynchronize(500, data: data)
    }

    func simulate(_ iterations: Int, data: [[Int]]) -> Int {
        var result = data
        var flashCount = 0
        for _ in 0..<iterations {
            result = increaseEnergy(rows: result)

            var flash = true
            while(flash) {
                let flashResult = flashValues(rows: result)
                flash = flashResult.flash
                result = flashResult.rows
                flashCount += flashResult.flashCount
            }

        }
        return flashCount
    }

    func simulateSynchronize(_ iterations: Int, data: [[Int]]) -> Int {
        var result = data
//        var flashCount = 0
        for iteration in 0..<iterations {
            result = increaseEnergy(rows: result)

            var flash = true
            while(flash) {
                let flashResult = flashValues(rows: result)
                flash = flashResult.flash
                result = flashResult.rows
//                flashCount += flashResult.flashCount
                let sum = result.reduce(into: 0, { partialResult, row in
                    partialResult += row.reduce(0, +)
                })
                if sum == 0 {
                    return iteration + 1
                }
            }

        }
        return -1
    }

    func increaseEnergy(rows: [[Int]]) -> [[Int]] {
        var nextData = Array(repeating: Array(repeating: -1, count: rows[0].count), count: rows.count)
        for rowIndex in 0..<rows.count {
            let row = rows[rowIndex]
            for columnIndex in 0..<row.count {
                let value = rows[rowIndex][columnIndex] + 1
                nextData[rowIndex][columnIndex] = value
            }
        }
        return nextData
    }

    func flashValues(rows: [[Int]]) -> (rows: [[Int]], flash: Bool, flashCount: Int) {
        var flashCount = 0
        var flash = false
        var data = rows
        for rowIndex in 0..<rows.count {
            let row = rows[rowIndex]
            for columnIndex in 0..<row.count {
                let result = updateFlash(row: rowIndex, column: columnIndex, rows: data)
                if flash == false {
                    flash = result.flash
                }
                flashCount += result.flashCount
                data = result.rows
            }
        }
        return (data, flash, flashCount)
    }

    func updateFlash(row: Int, column: Int, rows: [[Int]]) -> (rows: [[Int]], flash: Bool, flashCount: Int) {
        guard shouldFlash(row: row, column: column, data: rows) else {
            return (rows, false, 0)
        }
        var flashCount = 1
        var data = rows
        data[row][column] = 0

        let minY = 0
        let minX = 0
        let maxX = rows[0].count - 1
        let maxY = rows.count - 1

        let minValueX = max(column - 1, minX)
        let maxValueX = min(column + 1, maxX)
        let minValueY = max(row - 1, minY)
        let maxValueY = min(row + 1, maxY)

        var flash = false
        for x in minValueX...maxValueX {
            for y in minValueY...maxValueY {
                let value = rows[y][x]
                let flashed = data[y][x]
                if value == 0 || flashed == 0 {
                    continue
                }
                data[y][x] = value + 1

                if data[y][x] > 9 {
                    flash = true
                }
            }
        }
        return (data, flash, flashCount)
    }

    func shouldFlash(row: Int, column: Int, data: [[Int]]) -> Bool {
        let value = data[row][column]
        return value > 9
    }

    func debugPrint(data: [[Int]]) {
        let output = data.reduce(into: "") { $0 += $1.map { String($0) }.reduce("", +) + "\n"}
        print(output)
    }
}
