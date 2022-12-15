import Foundation

open class Node<Value: Equatable & Hashable>: Hashable, Identifiable {

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

    public var parent: Node<Value>? {
        let edge = edges.first { $0.start != self}
        let parentNode = edge?.start
        return parentNode
    }
}
