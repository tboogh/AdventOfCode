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
        return 0
    }
}

private extension Day_3 {

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
