public class Edge<Value: Equatable & Hashable>: Hashable {

    public init(start: Node<Value>, end: Node<Value>) {
        self.start = start
        self.end = end
    }

    public let start: Node<Value>
    public let end: Node<Value>

    public func hash(into hasher: inout Hasher) {
        hasher.combine(start.value)
        hasher.combine(end.value)
    }

    public func opposingNode(_ node: Node<Value>) -> Node<Value>? {
        if start == node {
            return end
        }
        if end == node {
            return start
        }
        return nil
    }

    public static func == (lhs: Edge, rhs: Edge) -> Bool {
        lhs.start.value == rhs.start.value &&
        lhs.end.value == rhs.end.value
    }
}
