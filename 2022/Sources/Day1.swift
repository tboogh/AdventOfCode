import AdventOfCodeCommon

public struct Day1 {

    public init() {}

    public func part1(input: String) -> Int {
        let inputSets = input.split(separator: "\n\n")
            .map {
                $0.split(separator: "\n")
                    .compactMap { Int($0) }
                    .reduce(into: 0, { $0 += $1 })
            }

        return inputSets.max() ?? -1
    }

    public func part2(input: String) -> Int {
        let inputSets = input.split(separator: "\n\n")
            .map {
                $0.split(separator: "\n")
                    .compactMap { Int($0) }
                    .reduce(into: 0, { $0 += $1 })
            }

        return inputSets
            .sorted()
            .reversed()
            .prefix(3)
            .reduce(into: 0, { $0 += $1 })

    }
}
