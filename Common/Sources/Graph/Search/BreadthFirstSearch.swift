open class BreadthFirstSearch<T: Hashable> {

    public init() {
    }

    private let visitedCache = VisitedCache<T>()
    private let pathCache = PathCache<T>()

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

    public class VisitedCache<T: Hashable> {

        public init() {}

        private var visitedEdges = [Edge<T>]()

        public func appendEdge(edge: Edge<T>) {
            visitedEdges.append(edge)
        }

        public func hasVisited(edge: Edge<T>) -> Bool {
            visitedEdges.contains(edge)
        }
    }

    public class PathCache<T: Hashable> {

        public init() {}

        public private(set) var paths: [Path<T>] = [] {
            didSet {
                paths.sort { $0.length < $1.length }
                shortestLength = paths.first?.length ?? Int.max
            }
        }

        public func appendPath(path: Path<T>) {
            paths.append(path)
        }

        public var shortestLength = Int.max
    }

    open func findPaths(from startNode: Node<T>, to endNode: Node<T>, in graph: Graph<T>) -> [Path<T>] {
        var pathsToSearch = [Path(node: startNode)]
        repeat {
            var nextPaths = [Path<T>]()

            while let path = pathsToSearch.popLast() {
                for edge in path.node.edges {
                    if visitedCache.hasVisited(edge: edge) { continue }
                    visitedCache.appendEdge(edge: edge)
                    let nextPath = Path(node: edge.end, previousPath: path)
                    if edge.end == endNode {
                        pathCache.appendPath(path: path)
                        continue
                    }
                    let currentShortestLength = pathCache.shortestLength
                    if nextPath.length > currentShortestLength {
                        continue
                    }
                    nextPaths.append(nextPath)
                }
            }

            pathsToSearch = nextPaths
        } while !pathsToSearch.isEmpty

        let paths = pathCache.paths
        return paths
    }

    open func findPaths(from startNode: Node<T>, toNearestNodeIn endNodes: [Node<T>], in graph: Graph<T>) -> [Path<T>] {
        var pathsToSearch = [Path(node: startNode)]
        repeat {
            var nextPaths = [Path<T>]()

            while let path = pathsToSearch.popLast() {
                for edge in path.node.edges {
                    if visitedCache.hasVisited(edge: edge) { continue }
                    visitedCache.appendEdge(edge: edge)
                    let nextPath = Path(node: edge.end, previousPath: path)
                    if endNodes.contains(edge.end) {
                        pathCache.appendPath(path: path)
                        continue
                    }
                    let currentShortestLength = pathCache.shortestLength
                    if nextPath.length > currentShortestLength {
                        continue
                    }
                    nextPaths.append(nextPath)
                }
            }

            pathsToSearch = nextPaths
        } while !pathsToSearch.isEmpty

        let paths = pathCache.paths
        return paths
    }

    open func findShortestPath(from startNode: Node<T>, toNearestNodeIn endNodes: [Node<T>], in graph: Graph<T>) -> Path<T>? {
        let paths = findPaths(from: startNode, toNearestNodeIn: endNodes, in: graph)
        return paths.sorted { $0.length < $1.length }.last
    }

    open func findShortestPath(from startNode: Node<T>, to endNode: Node<T>, in graph: Graph<T>) -> Path<T>? {
        let paths = findPaths(from: startNode, to: endNode, in: graph)
        return paths.sorted { $0.length < $1.length }.last
    }
}

public extension BreadthFirstSearch.Path {

    var array: [Node<T>] {
        var array: [Node] = [self.node]
        var iterativePath = self
        while let path = iterativePath.previousPath {
            array.append(path.node)

            iterativePath = path
        }
        return array
    }
}
