import AdventOfCodeCommon
import Foundation

public struct Day12 {

    public static func partOne(input: [String]) -> Int {
        let graph = input.parse().createGraph()

        guard
            let startNode = graph.nodes.first(where: { $0.value.value == "S" }),
            let endNode = graph.nodes.first(where: { $0.value.value == "E" })
        else { return -999 }
        let search = BreadthFirstSearch<GridNode>()
        let p = search.findShortestPath(from: endNode, to: startNode, in: graph)

        return p?.length ?? -1
    }
    
    public static func partTwo(input: [String]) -> Int {
        return -1
    }
}

private struct GridNode: Hashable, CustomDebugStringConvertible {

    let value: Character
    let position: GridPosition

    var debugDescription: String { String(value) }
}

private extension Array where Element == String {

    func parse() -> [[GridNode]] {
        var data: [[GridNode]] = []
        for line in self.enumerated() {
            var row = [GridNode]()
            for item in line.element.enumerated() {
                let result = GridNode(value: item.element,
                                      position: GridPosition(x: item.offset, y: line.offset))
                row.append(result)
            }
            data.append(row)
        }
        return data
    }
}

private extension Array where Element == [GridNode] {

    func createGraph() -> (Graph<GridNode>) {
        let graph = Graph<GridNode>()

        let lowerCaseCharacters = (97...122).map({Character(UnicodeScalar($0))})
        let letters = (["E"] + lowerCaseCharacters.reversed() + ["S"])

        func connect(in graph: Graph<GridNode>, node: Node<GridNode>, toParent: Node<GridNode>) {
            var parentNodeIndex = letters.firstIndex(of: toParent.value.value)!
            if toParent.value.value == "E" {
                parentNodeIndex = letters.firstIndex(of: "z")!
            }
            var endNodeIndex = letters.firstIndex(of: node.value.value)!
            if node.value.value == "S" {
                endNodeIndex = letters.firstIndex(of: "a")!
            }
            let diff = endNodeIndex - parentNodeIndex

            if diff <= 1 {
                graph.connect(node: node, parent: toParent)
            }
        }

        for y in 0..<self.count {
            let line = self[y]
            for x in 0..<line.count {
                let currentNode = line[x]
                let graphNode = graph.getOrCreateNode(value: currentNode)
                if x >= 1 {
                    let node = graph.getOrCreateNode(value: line[x - 1])
                    connect(in: graph, node: graphNode, toParent: node)
                }
                if x <= line.count - 2 {
                    let node = graph.getOrCreateNode(value: line[x + 1])
                    connect(in: graph, node: graphNode, toParent: node)
                }
                if y >= 1 {
                    let node = graph.getOrCreateNode(value: self[y - 1][x])
                    connect(in: graph, node: graphNode, toParent: node)
                }
                if y <= self.count - 2 {
                    let node = graph.getOrCreateNode(value: self[y + 1][x])
                    connect(in: graph, node: graphNode, toParent: node)
                }
            }
        }
        return graph
    }
}
