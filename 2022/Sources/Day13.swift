import AdventOfCodeCommon
import Foundation

public struct Day13 {

    public static func partOne(input: String) -> Int {
        let compareResult = input.components(separatedBy: "\n\n")
            .tokenize()
            .compare()
            .enumerated()
        let result = compareResult
            .filter { $0.element }
            .map { $0.offset + 1 }
            .sum()
        return result
    }

    public static func testInput(input: String, index: Int) -> Bool {
        let compareResult = input.components(separatedBy: "\n\n")[index]
            .components(separatedBy: "\n")
            .compactMap { $0.tokenize() }
//            .tokenize()
//            .compare()
//            .enumerated()
        let result = compareResult.compare()
        return result
    }

    public static func partTwo(input: [String]) -> Int {
        return -1
    }
}

enum TokenType: Character  {

    case start = "["
    case end = "]"
}

class TokenNode: Node<Int>, CustomStringConvertible {

    var description: String { "" }
}
class ValueNode: TokenNode {

    override var description: String {
         "\(value)"
    }
}
class ArrayNode: TokenNode {

    init() {
        super.init(value: 0)
    }

    override var description: String {
        "[\(edges.map { ($0.end as? CustomStringConvertible)?.description ?? "?" }.joined(separator: ","))]"
    }
}

extension Node {

    func addNode(node: Node<Value>) {
        let edge = Edge(start: self, end: node)
        edges.append(edge)
    }
}

extension Sequence where Element == String {

    func tokenize() -> [[TokenNode]] {
        let result = self.map { input in
                input.components(separatedBy: "\n")
                .filter { row in
                    print(row)
                    if row.isEmpty {
                        return false
                    }
                    return true
                }
            .compactMap { $0.tokenize() } }
        return result
    }
}

extension Array where Element == TokenNode {

    func compare() -> Bool {
        return compare(left: self[0], right: self[1])
    }

    enum Result {
        case success
        case failure
        case equal
    }

    private func innerCompare(left: TokenNode, right: TokenNode) -> Result {
        switch (left, right) {
        case let (left, right) as (ValueNode, ValueNode):
            print("Compare \(left.value) vs \(right.value)")
            if left.value < right.value {
                return .success
            } else if left.value == right.value {
                return .equal
            } else {
                return .failure
            }
        case let (left, right) as (ValueNode, ArrayNode):
            let leftArray = ArrayNode()
            leftArray.addNode(node: left)
            print("Mixed types; convert left to [\(left.value)] and retry comparison")
            return innerCompare(left: leftArray, right: right)
        case let (left, right) as (ArrayNode, ValueNode):
            let rightArray = ArrayNode()
            rightArray.addNode(node: right)
            print("Mixed types; convert right to [\(right.value)] and retry comparison")
            return innerCompare(left: left, right: rightArray)
        case let (left, right) as (ArrayNode, ArrayNode):
            let count = Swift.max(left.edges.count, right.edges.count)
            let allValues = (left.edges + right.edges).map { $0.end }.allSatisfy { $0 is ValueNode }
            for index in 0..<count {
                if index > right.edges.count - 1 {
                    print("Right side ran out of items")
                    return .failure
                }
                if index > left.edges.count - 1 {
                    print("Left side ran out of items")
                    return .success
                }
                let leftNode: TokenNode = left.edges[index].end as! TokenNode
                let rightNode: TokenNode = right.edges[index].end as! TokenNode
                let result = innerCompare(left: leftNode, right: rightNode)
                print("inner is \(result)")
                if case .equal = result {
                    continue
                }
                return result
            }
            return .equal
        default:
            fatalError("Unhandled case")
        }
    }


    private func compare(left: TokenNode, right: TokenNode) -> Bool {
        let result = innerCompare(left: left, right: right)
        switch result {
        case .success:
            return true
        case .failure:
            return false
        case .equal:
            return true
        }
    }
}

extension Sequence where Element == [TokenNode] {

    func compare() -> [Bool] {
        let result = self.map { $0.compare() }
        return result
    }
}

extension String {

    func tokenize() -> TokenNode? {
        var arrayNodeStack = [ArrayNode]()
        var value = Array(self)
        repeat {
            if value.isEmpty {
                fatalError("Corrupt stack")
            }
            let next = value.removeFirst()
            if next == TokenType.start.rawValue {
                let arrayNode = ArrayNode()
                arrayNodeStack.last?.addNode(node: arrayNode)
                arrayNodeStack.append(arrayNode)
            } else if next == TokenType.end.rawValue {
                let node = arrayNodeStack.popLast()
                if arrayNodeStack.isEmpty {
                    return node
                }
            } else {
                if next != "," {
                    let valueNode = ValueNode(value: Int(String(next))!)
                    arrayNodeStack.last?.addNode(node: valueNode)
                }
            }
        } while true
    }
}
