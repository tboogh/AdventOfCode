open class BreadthFirstSearch<T: Hashable> {

    public init() {}

    open class Path<T: Hashable> {

        public init(node: Node<T>, previousPath: Path<T>? = nil) {
            self.node = node
            if let previousPath {
                self.length = previousPath.length + 1
            } else {
                self.length = 0
            }
            self.previousPath = previousPath
        }

        public let length: Int
        public let node: Node<T>
        public let previousPath: Path<T>?
    }

    open func findShortestPath(from startNode: Node<T>, to endNode: Node<T>, in graph: Graph<T>) -> Path<T>? {
        var paths = [Path<T>]()
        var visitedEdges = [Edge<T>]()
        var pathsToSearch = [Path(node: startNode)]
        repeat {
            var nextPaths = [Path<T>]()

            while let path = pathsToSearch.popLast() {
                if path.node.edges.isEmpty {
                    paths.append(path)
                }
                for edge in path.node.edges {
                    if visitedEdges.contains(edge) { continue }
                    visitedEdges.append(edge)
                    let nextPath = Path(node: edge.end, previousPath: path)
                    if edge.end == endNode {
                        return nextPath
                    }
                    nextPaths.append(nextPath)
                }
            }

            pathsToSearch = nextPaths
        } while !pathsToSearch.isEmpty

        return paths.sorted { $0.length < $1.length }.last
    }
}
