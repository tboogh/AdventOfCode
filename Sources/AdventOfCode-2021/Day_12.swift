public class Day_12 {

    func partOne(input: String) -> Int {
        let graph = createGraph(input: input.rows)
        return 0
    }

    func partTwo(input: String) -> Int {
        return 0
    }

    func createGraph(input: [String]) -> CaveGraph {
        let graph = CaveGraph()
        for branch in input.map({ $0.components(separatedBy: "-")}) {
            let parentValue = branch[0]
            let nodeValue = branch[1]
            let parentNode = graph.getOrCreateNode(value: parentValue)
            let node = graph.getOrCreateNode(value: nodeValue)
            graph.connect(node: node, parent: parentNode)
            graph.setRootNode(node: parentNode)
        }
        return graph
    }
}

typealias CaveGraph = Graph<String>

class Graph<Value: Equatable> {

    private(set) var rootNode: Node<Value>? = nil
    private(set) var nodes: [Node<Value>] = []

    func addNode(value: Value) -> Node<Value> {
        return getOrCreateNode(value: value)
    }

    func setRootNode(node: Node<Value>) {
        guard rootNode == nil else {
            return
        }

        rootNode = node
    }

    func connect(node: Node<Value>, parent: Node<Value>) {
        parent.connections.append(node)
        node.connections.append(parent)
    }

    func getOrCreateNode(value: Value) -> Node<Value> {
        if let node = nodes.first(where: { $0.value == value }) {
            return node
        }
        let node = Node(value: value)
        nodes.append(node)
        return node
    }
}

class Node<Value: Equatable> {

    init(value: Value) {
        self.value = value
    }

    let value: Value
    var connections: [Node<Value>] = []
}
