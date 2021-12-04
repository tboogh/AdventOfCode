public class Day_3 {

    func partOne(input: [String]) -> Int {
        let count = input[0].count
        let integerRows = input.map {
            $0.map{ String($0) }.compactMap { Int($0) }
        }
        var result = Array(repeating: 0, count: count)
        for row in integerRows {
            for index in 0..<count {
                result[index] += row[index]
            }
        }
        let bits = result.map { (Double($0) / Double(input.count)) > 0.5 ? 1 : 0 }
        let inverseBits = invert(bits)

        let gamma = bitToInt(bits)
        let epsilon = bitToInt(inverseBits)
        return gamma * epsilon
    }

    func partTwo(input: [String]) -> Int {
        let count = input[0].count
        let integerRows = input.map {
            $0.map{ String($0) }.compactMap { Int($0) }
        }
        let oxygenGeneratorRating = oxygenGeneratorRating(input: integerRows)
        let co2ScrubberRating = co2ScrubberRating(input: integerRows)
        let oxygenValue = bitToInt(oxygenGeneratorRating)
        let scubberValue = bitToInt(co2ScrubberRating)
        return oxygenValue * scubberValue
    }
}

private extension Day_3 {

    func oxygenGeneratorRating(input: [[Int]]) -> [Int] {
        var filteredResults = input
        var currentColumn = 0
        repeat {
            let ones = filteredResults.filter{ $0[currentColumn] == 1 }
            let zeroes = filteredResults.filter{ $0[currentColumn] == 0 }

            if ones.count >= zeroes.count {
                filteredResults = ones
            } else {
                filteredResults = zeroes
            }
            if filteredResults.count == 1 {
                return filteredResults[0]
            }
            currentColumn += 1
        } while(true)
    }

    func co2ScrubberRating(input: [[Int]]) -> [Int] {
        var filteredResults = input
        var currentColumn = 0
        repeat {
            let ones = filteredResults.filter{ $0[currentColumn] == 1 }
            let zeroes = filteredResults.filter{ $0[currentColumn] == 0 }

            if ones.count == zeroes.count {
                filteredResults = zeroes
            } else {
                filteredResults = [ones, zeroes].sorted { $0.count < $1.count }.first ?? []
            }

            if filteredResults.count == 1 {
                return filteredResults[0]
            }
            currentColumn += 1
        } while(true)
    }

    func bitToInt(_ bits: [Int]) -> Int {
        stringBitsToInt(stringRep(bits))
    }

    func invert(_ bits: [Int]) -> [Int] {
        bits.map { $0 == 1 ? 0: 1}
    }

    func stringRep(_ bits: [Int]) -> String {
        bits.reduce(into: "") { partialResult, value in
            partialResult += String(value)
        }
    }

    func stringBitsToInt(_ bits: String) -> Int {
        Int(bits, radix: 2) ?? 0
    }
}
