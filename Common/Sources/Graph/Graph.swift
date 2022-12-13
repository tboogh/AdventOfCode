public class Graph<Value: Equatable & Hashable> {

    public private(set) var rootNode: Node<Value>? = nil
    public private(set) var nodes = Set<Node<Value>>()

    public init() {}

    public func addNode(value: Value) -> Node<Value> {
        return getOrCreateNode(value: value)
    }

    public func setRootNodeIfNeeded(node: Node<Value>) {
        guard rootNode == nil else {
            return
        }

        rootNode = node
    }

    public func connect(node: Node<Value>, parent: Node<Value>) {
        if parent.isConnected(to: node) { return }
        let edge = Edge(start: parent, end: node)
        parent.edges.append(edge)
//        print("connect \(node.value) to \(parent.value)")
//        node.edges.append(edge)
    }

    public func getOrCreateNode(value: Value) -> Node<Value> {
        if let node = nodes.first(where: { $0.value == value }) {
            return node
        }
        let node = Node(value: value)
        nodes.formUnion([node])
        return node
    }
}
