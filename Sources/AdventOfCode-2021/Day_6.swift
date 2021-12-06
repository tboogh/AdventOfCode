public class Day_6 {

    func partOne(input: String, days: Int) -> Int {
        let data = input.components(separatedBy: ",")
            .compactMap { Int($0) }
        return compute(values: data, days: days)
    }

    func partTwo(input: [Int]) -> Int {
        return 0
    }
}

private extension Day_6 {

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


