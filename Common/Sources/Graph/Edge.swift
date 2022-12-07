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

    public static func == (lhs: Edge, rhs: Edge) -> Bool {
        lhs.start.value == rhs.start.value &&
        lhs.end.value == rhs.end.value
    }
}
