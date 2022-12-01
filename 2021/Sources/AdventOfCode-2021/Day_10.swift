public class Day_10 {

    func partOne(input: String) -> Int {
        let rows = input
            .components(separatedBy: .newlines)
            .filter { $0.count > 0 }
        var corruptNodes = [ParseNode<String>]()
        for row in rows {
            let result = Day10Parser.parse(input: row)
            if let node = result.corruptNodes.first {
                corruptNodes.append(node)
            }
        }
        var score = 0
        for corruptNode in corruptNodes {
            if corruptNode.closing == ")" {
                score += 3
            }
            if corruptNode.closing == "]" {
                score += 57
            }
            if corruptNode.closing == "}" {
                score += 1197
            }
            if corruptNode.closing == ">" {
                score += 25137
            }
        }
        return score
    }

    func partTwo(input: String) -> Int {
        let rows = input
            .components(separatedBy: .newlines)
            .filter { $0.count > 0 }

        var scores = [Int]()
        let results = rows.map { Day10Parser.parse(input: $0) }
        for result in results {
            if result.isCorrupt {
                continue
            }
            let incompleteNodes = result.incompleteNodes.reversed()
            var rowScore = 0

            var nodeLine = ""

            for incompleteNode in incompleteNodes {
                nodeLine = "\(incompleteNode.closing ?? ".")\(nodeLine)"
                rowScore = rowScore * 5
                guard let bracket = incompleteNode.bracketForNode(brackets: result.brackets) else {
                    continue
                }
                rowScore = rowScore + bracket.score
                print(rowScore)
            }
            print("\(nodeLine) = \(rowScore)")
            scores.append(rowScore)
        }

        let sorted = scores.sorted()
        let middle = sorted.count / 2

        return sorted[middle]
    }
}

public class Day10Parser: ParseTree<String> {

    static func parse(input: String) -> ParseTree<String> {
        let brackets = [
            Bracket(open: "(", close: ")", score: 1),
            Bracket(open: "[", close: "]", score: 2),
            Bracket(open: "{", close: "}", score: 3),
            Bracket(open: "<", close: ">", score: 4)
        ]
        let result = ParseTree<String>.parseDataInput(input: Array(input).map { String($0) }, brackets: brackets)
        return ParseTree(rootNode: result.0, nodes: result.1, brackets: brackets, row: input)
    }
}

public class ParseTree<T: Equatable> {

    init(rootNode: ParseNode<T>, nodes: [ParseNode<T>], brackets: [Bracket<T>], row: String) {
        self.rootNode = rootNode
        self.nodes = nodes
        self.brackets = brackets
        self.row = row
    }

    let brackets: [Bracket<T>]
    let nodes: [ParseNode<T>]
    let rootNode: ParseNode<T>
    let row: String

    var corruptNodes: [ParseNode<T>] {
        var corrupt = [ParseNode<T>]()
        for node in nodes {
            for bracket in brackets {
                if bracket.open == node.value {
                    if node.closing != nil && node.closing != bracket.close {
                        corrupt.append(node)
                    }
                }
            }
        }
        return corrupt
    }

    var isCorrupt: Bool {
        !corruptNodes.isEmpty
    }

            
    var incompleteNodes: [ParseNode<T>] {
        var incomplete = [ParseNode<T>]()
        for node in nodes {

            if node.closing != nil {
                continue
            }
            for bracket in brackets {
                if bracket.open == node.value {
                    node.closing = bracket.close
                }
            }

            incomplete.append(node)
        }
        return incomplete
    }
}

public struct Bracket<T> {
    let open: T
    let close: T

    let score: Int
}

public extension ParseTree {

    static func parseDataInput<T: Collection>(input: T, brackets: [Bracket<T.Element>]) -> (ParseNode<T.Element>, [ParseNode<T.Element>])  where T.Element: Equatable {
        var nodes = [ParseNode<T.Element>]()
        var rootNode: ParseNode<T.Element>? = nil
        var workingNode: ParseNode<T.Element>? = nil

        for value in input {
            if rootNode == nil {
                rootNode = ParseNode(value: value)
                workingNode = rootNode
                nodes.append(workingNode!)
            } else {
                var closed: Bool = false
                var closingBracket: Bracket<T.Element>? = nil
                for bracket in brackets {
                    if value == bracket.close {
                        closingBracket = bracket
                    }
                }
                if closingBracket != nil {
                    workingNode?.closing = value
                    workingNode = workingNode?.parent
                    closed = true
                }
                if closed {
                    continue
                }
                let childNode = ParseNode(value: value, parent: workingNode)
                workingNode?.child = childNode
                workingNode = childNode
                nodes.append(workingNode!)
            }
        }
        return (rootNode!, nodes.compactMap{ $0 })
    }
}

public class ParseNode<T: Equatable> {

    init(value: T, parent: ParseNode<T>? = nil) {
        self.parent = parent
        self.value = value
    }

    let value: T
    let parent: ParseNode<T>?
    var child: ParseNode<T>? = nil
    var closing: T? = nil
}

extension ParseNode {

    func bracketForNode(brackets: [Bracket<T>]) -> Bracket<T>? {
        for bracket in brackets {
            if bracket.close == closing {
                return bracket
            }
        }
        return nil
    }
}
