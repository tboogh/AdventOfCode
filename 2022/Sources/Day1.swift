import AdventOfCodeCommon

public struct Day1 {

    public init() {}

    private func caloriesPerElf(input: String) -> [Int] {
        let caloriesPerElf = input.split(separator: "\n\n")
            .map {
                $0.split(whereSeparator: \.isNewline)
                    .compactMap { Int($0) }
                    .reduce(0, +)
            }
            .sorted()
        return caloriesPerElf
    }

    public func part1(input: String) -> Int {
        return caloriesPerElf(input: input).last ?? -1
    }

    public func part2(input: String) -> Int {
        return caloriesPerElf(input: input)
            .suffix(3)
            .reduce(0, +)

    }
}
