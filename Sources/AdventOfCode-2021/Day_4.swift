public class Day_4 {

    func partOne(input: Day4Data) -> Int {

        return playPartOne(data: input)
    }

    func partTwo(input: Day4Data) -> Int {
        return 0
    }
}

private extension Day_4 {

    func playPartOne(data: Day4Data) -> Int{
        for number in data.numberSequnce {
            print("Number: \(number)")
            for bingoBoard in data.bingoBoards {
                bingoBoard.checkNumber(number: number)
                if bingoBoard.bingo {
                    return bingoBoard.answer * number
                }
            }
        }
        return 0
    }
}

public struct Day4Data {

    public class BingoBoard {
        init(data: [[Int]]) {
            self.data = data
            self.checkedNumbers = Array(repeating: Array(repeating: 0, count: data.count), count: data.count)
            self.calcData = data
        }

        var calcData: [[Int]]
        var data: [[Int]]
        var checkedNumbers: [[Int]]

        func checkNumber(number: Int) {
            for rowIndex in 0..<data.count {
                let row = data[rowIndex]
                for columnIndex in 0..<row.count {
                    if row[columnIndex] == number {
                        var checkedRow = checkedNumbers[rowIndex]
                        checkedRow[columnIndex] = number
                        checkedNumbers[rowIndex] = checkedRow

                        var dataRow = calcData[rowIndex]
                        dataRow[columnIndex] = 0
                        calcData[rowIndex] = dataRow
                    }
                }
            }
        }

        var bingo: Bool {
            for row in checkedNumbers {
                if row.map({ $0 > 1 ? 1: 0 }).reduce(0, +) == 5 {
                    return true
                }
            }
            for row in transpose(input: checkedNumbers) {
                if row.map({ $0 > 1 ? 1: 0 }).reduce(0, +) == 5 {
                    return true
                }
            }
            return false
        }

        var answer: Int {
            let result = calcData.flatMap { $0 }.filter{ $0 > 0 }.reduce(0, +)
            return result
        }

        private func transpose(input: [[Int]]) -> [[Int]] {
            var result: [[Int]] = Array(repeating: Array(repeating: 0, count: input.count), count: input.count)
            for rowIndex in 0..<input.count {
                let row = input[rowIndex]
                for columnIndex in 0..<row.count {
                    let value = row[columnIndex]
                    result[columnIndex][rowIndex] = value
                }
            }
            return result
        }

        func debug() {
            for row in checkedNumbers {
                print(row.reduce(into: "") { partialResult, value in
                    if value > 0 {
                        partialResult += "\(value) "
                    } else {
                        partialResult += "  "
                    }

                })
            }
            print("========\n")
        }

        /*
         0 1 2
         3 4 5
         6 7 8

         0 3 6
         1 4 7
         2 5 8
         */
    }

    let numberSequnce: [Int]
    let bingoBoards: [BingoBoard]

    init(data: String) {
        let parts = data.split(separator: "\n", omittingEmptySubsequences: true)
        let bingoBoardData = parts
            .dropFirst()
            .map { $0.split(separator: " ").map{ Int($0) ?? -1 } }

        let numberSequence = parts[0].split(separator: ",").compactMap { Int($0) }
        let bingoBoards = bingoBoardData.chunked(into: 5)
            .map { BingoBoard(data: $0) }

        self.numberSequnce = numberSequence
        self.bingoBoards = bingoBoards
    }
}

extension Array {

    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
