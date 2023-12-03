import AdventOfCodeCommon
import Foundation

public struct Day3 {

    public static func partOne(input: [String]) -> Int {
        let (numbers, symbols) = processData(input: input)
        var resultNumbersArray = [NumberRegion]()
        for number in numbers {
            let rowRange = (number.row - 1)...(number.row + 1)
            for rowIndex in rowRange {
                let symbolsOnRow = symbols.filter { $0.row == rowIndex }
                let numberRange = (number.range.lowerBound - 1)...(number.range.upperBound + 1)
                if let _ = symbolsOnRow.first(where: { numberRange.contains($0.column) }) {
                    resultNumbersArray.append(number)
                    break
                }
            }
        }
        return resultNumbersArray.map { $0.number }.sum()
    }

    public static func partTwo(input: [String]) -> Int {
        let (numbers, symbols) = processData(input: input)
        var resultNumbersArray = [Int]()
        for symbol in symbols where symbol.symbol == "*" {
            let rowRange = (symbol.row - 1)...(symbol.row + 1)
            let symbolRange = (symbol.column - 1)...(symbol.column + 1)
            var numbersInSymbolRange = [NumberRegion]()
            for rowIndex in rowRange {
                let numbersOnRow = numbers.filter { $0.row == rowIndex }
                let numbersInRange = numbersOnRow.filter { $0.range.overlaps(symbolRange) }
                numbersInSymbolRange.append(contentsOf: numbersInRange)
            }
            if numbersInSymbolRange.count == 2 {
                let result = numbersInSymbolRange[0].number * numbersInSymbolRange[1].number
                resultNumbersArray.append(result)
            }
        }
        return resultNumbersArray.sum()
    }

    private static func processData(input: [String]) -> ([NumberRegion], [SymbolInfo]){
        var notSymbols = CharacterSet()
        notSymbols.formUnion(.lowercaseLetters)
        notSymbols.formUnion(.uppercaseLetters)
        notSymbols.formUnion(.decimalDigits)
        notSymbols.insert(charactersIn: ".")

        var numbers = [NumberRegion]()
        var symbols = [SymbolInfo]()
        for rowIndex in 0..<input.count {
            let row = input[rowIndex]
            var rowNumbers = [NumberRegion]()
            var rowSymbols = [SymbolInfo]()
            var currentNumber: String?
            var currentNumberStart: Int?
            var currentNumberEnd: Int?

            func appendNumber() {
                if let currentNumber,
                   let number = Int(currentNumber),
                   let currentNumberStart,
                   let currentNumberEnd
                {
                    let range = currentNumberStart...currentNumberEnd
                    rowNumbers.append(NumberRegion(number: number, row: rowIndex, range: range))
                }
                currentNumber = nil
                currentNumberStart = nil
                currentNumberEnd = nil
            }

            for index in 0..<row.count {
                let element = row[String.Index(utf16Offset: index, in: row)]
                if element.isNumber {
                    if currentNumberStart == nil {
                        currentNumberStart = index
                    }
                    currentNumberEnd = index

                    if currentNumber == nil {
                        currentNumber = String(element)
                    } else {
                        currentNumber?.append(element)
                    }
                } else {
                    appendNumber()
                    if element != "." {
                        rowSymbols.append(SymbolInfo(row: rowIndex, column: index, symbol: String(element)))
                    }
                }
                if index == row.count - 1 {
                    appendNumber()
                }
            }
            numbers.append(contentsOf: rowNumbers)
            symbols.append(contentsOf: rowSymbols)
        }
        return (numbers, symbols)
    }
}

private struct NumberRegion: Hashable {

    let number: Int
    let row: Int
    let range: ClosedRange<Int>
}

private struct SymbolInfo {

    let row: Int
    let column: Int
    let symbol: String
}
