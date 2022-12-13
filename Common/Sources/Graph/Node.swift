import Foundation

public class Node<Value: Equatable & Hashable>: Hashable, Identifiable {

    public init(value: Value) {
        self.value = value
    }

    public var id = UUID()
    public let value: Value
    public var edges: [Edge<Value>] = []

    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }

    public static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.value == rhs.value
    }

    public func isConnected(to node: Node<Value>) -> Bool {
        for edge in edges {
            if edge.start == node || edge.end == node {
                return true
            }
        }
        return false
    }
}
