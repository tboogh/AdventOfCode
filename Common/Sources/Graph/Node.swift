public class Node<Value: Equatable & Hashable>: Hashable {

    public init(value: Value) {
        self.value = value
    }

    public let value: Value
    public var edges: [Edge<Value>] = []

    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }

    public static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.value == rhs.value
    }

    public func firstParentNode() -> Node<Value>? {
        edges.map { $0.start }.first
    }

    public var isLeafNode: Bool {
        edges.allSatisfy { $0.end == self }
    }
}
