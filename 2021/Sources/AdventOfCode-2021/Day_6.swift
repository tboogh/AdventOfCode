public class Day_6 {

    func partOne(input: String, days: Int) -> Int {
        let data = input.components(separatedBy: ",")
            .compactMap { Int($0) }
        return compute(values: data, days: days)
    }

    func partTwo(input: String, days: Int) -> Int {
        let data = input.components(separatedBy: ",")
            .compactMap { Int($0) }
        return computeCalculated(values: data, days: days)
    }
}

private extension Day_6 {

    func computeCalculated(values: [Int], days: Int) -> Int {
        var groups = Dictionary(grouping: values, by: { $0 }).mapValues { $0.count }
        for day in 1...days {
            var newCount = 0
            var updated = groups.map { (key, value) -> (Int, Int) in
                var newkey = key
                if key == 0 {
                    newCount += value
                    newkey = 6
                } else {
                    newkey = key - 1
                }
                return (newkey, value)
            }

            if newCount > 0 {
                updated.append((8, newCount))
            }
            let updatedGroups = Dictionary(grouping: updated) { $0.0 }
                .mapValues { $0.map { $0.1 }.reduce(0, +) }
            groups = updatedGroups
        }

        return groups.values.reduce(0, +)
    }

    func compute(values: [Int], days: Int) -> Int {
        var fishes = values
        for day in 0..<days {
            var dayUpdate: [Int] = []
            var newCount = 0
            for fish in fishes {
                if fish == 0 {
                    newCount += 1
                    dayUpdate.append(6)
                } else {
                    dayUpdate.append(fish - 1)
                }
            }
            fishes = dayUpdate + Array(repeating: 8, count: newCount)
        }
        return fishes.count
    }

    func debug(fishes: [Int]) {
        print(fishes.reduce("", { $0 + "\($1), "}))
    }
}


