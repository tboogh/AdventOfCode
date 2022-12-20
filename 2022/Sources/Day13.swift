import AdventOfCodeCommon
import Foundation

public struct Day13 {

    public static func partOne(input: String) -> Int {
        let result = input
            .parse()
            .orderIntoPairs()
            .compare()
            .enumerated()
            .filter { $0.element }
            .map { $0.offset + 1 }
            .sum()
        return result
    }

    public static func testInput(input: String, index: Int) -> Bool {
        let packets = input.parse().orderIntoPairs()
        let result = packets[index].compare()
        return result
    }

    public static func partTwo(input: String) -> Int {
        let dividiers = """
                       
                       [[2]]
                       [[6]]
                       """
        let modifiedInput = input.appending(dividiers)
        let result =  modifiedInput
            .parse()
            .sorted(by: <)
        guard
            let firstDividerIndex = result.firstIndex(of: .list([.list([.value(2)])])),
            let secondDividerIndex = result.firstIndex(of: .list([.list([.value(6)])]))
        else { return 0 }

        return (firstDividerIndex + 1) * (secondDividerIndex + 1)
    }
}

private extension String {

    func parse() -> [Packet] {
        let decoder = JSONDecoder()
        let packets = self.components(separatedBy: "\n")
            .filter { !$0.isEmpty }
            .map { try! decoder.decode(Packet.self, from: $0.data(using: .utf8)!)}
        return packets
    }
}

private extension Array where Element == Packet {

    func orderIntoPairs() -> [PacketPair] {
        var result = [PacketPair]()
        for index in stride(from: 0, to: self.count, by: 2) {
            result.append(PacketPair(left: self[index], right: self[index + 1]))
        }
        return result
    }
}

private extension Array where Element == PacketPair {

    func compare() -> [Bool] {
        map { $0.compare() }
    }
}

private struct PacketPair {

    let left: Packet
    let right: Packet

    func compare() -> Bool {
        left < right
    }
}

private enum Packet: Decodable, Comparable {

    case value(Int)
    case list([Packet])

    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            self = .value(try container.decode(Int.self))
        } catch {
            self = .list(try [Packet](from: decoder))
        }
    }

    static func < (lhs: Packet, rhs: Packet) -> Bool {
        switch (lhs, rhs) {
        case (.list(let leftPackets), .list(let rightPackets)):
            let zipped = zip(leftPackets, rightPackets)
            for (left, right) in zipped {
                if left < right { return true }
                if right < left { return false }
            }
            return leftPackets.count < rightPackets.count
        case (.value, .list):
            return .list([lhs]) < rhs
        case (.list, .value):
            return lhs < .list([rhs])
        case (.value(let left), .value(let right)):
//            print("- Compare: \(left) vs \(right)")
            return left < right
        }
    }
}
