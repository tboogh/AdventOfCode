import AppKit
public class Day_12 {

    func partOne(input: String) -> Int {
        let graph = createGraph(input: input.rows)
        let visitor = CaveVisitor()

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
            graph.setRootNode(node: parentNode)
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


    override func canVisit(index: Int, nodes: [Node<String>], visited: [Bool]) -> Bool {
        let node = nodes[index]
        if node.value.isLowercase && visited[index] {
            return false
        }
        return true
    }
}

class GraphVisitor<Value: Equatable & Hashable> {

    typealias Path = [Node<Value>]

    func findPaths(start: Node<Value>, end: Node<Value>, nodes: [Node<Value>]) -> [Path]{
        guard let startIndex = nodes.firstIndex(of: start),
              let endIndex = nodes.firstIndex(of: end)
        else {
            assertionFailure("Missing start or end node in nodes array")
            return []
        }
        var count = 0
        var paths = [Path]()
        var visited = Array(repeating: false, count: nodes.count)
        visit(nodeIndex: startIndex,
              endIndex: endIndex,
              nodes: nodes,
              count: &count,
              visited: &visited,
              paths: &paths)
        return paths
    }

    func visit(nodeIndex: Int,
               endIndex: Int,
               nodes: [Node<Value>],
               count: inout Int,
               visited: inout [Bool],
               paths: inout [Path]) {
        visited[nodeIndex] = true
        appendToPath(index: nodeIndex,
                     nodes: nodes,
                     paths: &paths,
                     count: count)
        if nodeIndex == endIndex {
            count += 1
        } else {
            for connection in nodes[nodeIndex].connections {
                guard
                    let connectionIndex = nodes.firstIndex(of: connection),
                    canVisit(index: connectionIndex, nodes: nodes, visited: visited)
                else {
                    continue
                }
                visit(nodeIndex: connectionIndex,
                      endIndex: endIndex,
                      nodes: nodes,
                      count: &count,
                      visited: &visited,
                      paths: &paths)
            }
        }
        visited[nodeIndex] = false
    }

    func appendToPath(index: Int, nodes: [Node<Value>], paths: inout [Path], count: Int) {
        let node = nodes[index]
        if paths.count <= count {
            paths.append(Path())
        }
        var path = paths[count]
        path.append(node)
        paths[count] = path
    }

    func canVisit(index: Int, nodes: [Node<Value>], visited: [Bool]) -> Bool {
        return true
    }
}

typealias CaveGraph = Graph<String>

class Graph<Value: Equatable & Hashable> {

    private(set) var rootNode: Node<Value>? = nil
    private(set) var nodes = Set<Node<Value>>()

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
    var connections: [Node<Value>] = []

    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }

    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.value == rhs.value
    }
}

