import Foundation

public class Day_7 {

    func partOne(input: String) -> Int {
        let data = input.components(separatedBy: ",").compactMap { Int($0) }
        return computeAlignment(data: data)
    }

    func partTwo(input: String) -> Int {
        let data = input.components(separatedBy: ",").compactMap { Int($0) }
        return computeAlignment2(data: data)
    }

    func computeAlignment(data: [Int]) -> Int {
//        let groups = Dictionary(grouping: data) { $0 }.map { ($0.value.count, $0.key)}
//        let largest = groups.max(by: {$0.0 < $1.0 })
        guard let max = data.max() else {
            return 0
        }
        var totals: [Int] = []
        for index in 0..<max {
            let distance = data.reduce(into: 0) { partialResult, value in
                partialResult += abs(value - index)
            }
            totals.append(distance)
        }
        return totals.min() ?? 0
    }

    func computeAlignment2(data: [Int]) -> Int {
        let groups = Dictionary(grouping: data) { $0 }.map { ($0.key, $0.value.count)}
        guard let max = data.max() else {
            return 0
        }
        var totals: [Int] = []

        let queue = DispatchQueue(label: "com.day7.compute", attributes: .concurrent)
        let group = DispatchGroup()
        let lock = DispatchSemaphore(value: 1)
        for index in 0..<max {
            group.enter()
            queue.async {

                print("\(index+1)/\(max)")
                let distance = groups.reduce(into: 0) { partialResult, value in
                    let distance = abs(value.0 - index)
                    if distance == 0 {
                        return
                    }
                    partialResult += ((1...distance).reduce(0, +) * value.1)
                }
                lock.wait()
                totals.append(distance)
                lock.signal()
                group.leave()
            }
        }
        group.wait()
        return totals.min() ?? 0
    }
}
