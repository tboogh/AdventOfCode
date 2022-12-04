import AdventOfCodeCommon

public class Day_12 {

    func partOne(input: String) -> Int {
        let graph = createGraph(input: input.lines)
        let visitor: GraphVisitor<String> = GraphVisitor()

        guard
            let start = graph.rootNode,
            let end = graph.findNode(value: "end")
        else { return -1 }
        let paths = visitor.findPaths(start: start, end: end, nodes: Array(graph.nodes))
        debugPrint(paths)
        return paths.count
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
            graph.setRootNodeIfNeeded(node: parentNode)
        }
        return graph
    }

    func debugPrint(_ paths: [[Node<String>]]) {
        for path in paths {
            print(path.map { $0.value }.joined(separator: ","))
        }
    }
}

class CaveVisitor: GraphVisitor<String> {

    override func canVisit(_ node: Node<String>) -> Bool {
        return node.value.isUpperCase
    }
}

class GraphVisitor<Value: Equatable & Hashable> {

    typealias Path = [Node<Value>]

    func findPaths(start: Node<Value>, end: Node<Value>, nodes: [Node<Value>]) -> [Path]{
        var paths = [Path]()
        var visitedEdges = [Edge<Value>]()
        var currentNode: Node<Value>? = start
        while let node = currentNode {
            for edge in node.edges {
                if visitedEdges.contains(edge) && canVisit(edge.end) { continue }
                currentNode = edge.end
            }
        }
        return []
    }

    open func canVisit(_ node: Node<Value>) -> Bool { true }
}

typealias CaveGraph = Graph<String>

class Graph<Value: Equatable & Hashable> {

    private(set) var rootNode: Node<Value>? = nil
    private(set) var nodes = Set<Node<Value>>()

    func addNode(value: Value) -> Node<Value> {
        return getOrCreateNode(value: value)
    }

    func setRootNodeIfNeeded(node: Node<Value>) {
        guard rootNode == nil else {
            return
        }

        rootNode = node
    }

    func connect(node: Node<Value>, parent: Node<Value>) {
        parent.edges.append(Edge(start: parent, end: node))
        node.edges.append(Edge(start: node, end: parent))
    }

    func getOrCreateNode(value: Value) -> Node<Value> {
        if let node = nodes.first(where: { $0.value == value }) {
            return node
        }
        let node = Node(value: value)
        nodes.formUnion([node])
        return node
    }

    func findNode(value: Value) -> Node<Value>? {
        nodes.first(where: { $0.value == value })
    }
}

class Node<Value: Equatable & Hashable>: Hashable {

    init(value: Value) {
        self.value = value
    }

    let value: Value
    var edges: [Edge<Value>] = []

    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }

    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.value == rhs.value
    }
}

class Edge<Value: Equatable & Hashable>: Hashable {
    init(start: Node<Value>, end: Node<Value>) {
        self.start = start
        self.end = end
    }

    let start: Node<Value>
    let end: Node<Value>

    func hash(into hasher: inout Hasher) {
        hasher.combine(start.value)
        hasher.combine(end.value)
    }

    static func == (lhs: Edge, rhs: Edge) -> Bool {
        lhs.start.value == rhs.start.value &&
        lhs.end.value == rhs.end.value
    }
}

extension String {

    var isUpperCase: Bool { !isLowercase }
}

