import AdventOfCodeCommon
import Foundation
import RegexBuilder

public struct Day7 {

    public static func partOne(input: [String]) -> Int {
        let result = input
            .parseCommandList()
            .computeBranchSizes()
            .computeTotalSizeOfDirectories(below: 100_000)
        return result
    }

    public static func partTwo(input: [String]) -> Int {
        let availableDiskSpace = 70_000_000
        let requiredUnusedSpace = 30_000_000
        let parsedTree = input.parseCommandList()
        let result = parsedTree
            .computeBranchSizes()
            .findSmallestDirectoryThatCanBeDeleted(
                rootNodeId: parsedTree.rootNode?.value.id ?? UUID(),
                availableDiskSpace: availableDiskSpace,
                requiredUnusedSpace: requiredUnusedSpace)
        return result
    }
}

private extension SizeVisitor {

    func computeTotalSizeOfDirectories(below: Int) -> Int {
        let size = branchSize.values.filter { $0 < below }.sum()
        return size
    }

    func findSmallestDirectoryThatCanBeDeleted(rootNodeId: UUID,
                                               availableDiskSpace: Int,
                                               requiredUnusedSpace: Int) -> Int {
        guard let totalAmountOfUsedSize = branchSize[rootNodeId] else { return 0 }
        let unusedSpace = availableDiskSpace - totalAmountOfUsedSize
        let requiredSizeToBeDeleted = requiredUnusedSpace - unusedSpace
        let branchSizes = Array(branchSize.values)
        let branchSizesAboveRequiredSize = branchSizes
            .filter { $0 > requiredSizeToBeDeleted }
        let smallestBranchSizeAboveRequiredSize = branchSizesAboveRequiredSize
            .sorted()
            .first ?? 0
        return smallestBranchSizeAboveRequiredSize
    }
}

private extension Tree where Value == Directory {
    func computeBranchSizes() -> SizeVisitor {
        let visitor = SizeVisitor()
        guard let rootNode else { return visitor }
        visitor.visit(node: rootNode)
        return visitor
    }
}

private class SizeVisitor: TreeVisitor<Directory> {

    private(set) var branchSize = [UUID: Int]()

    @discardableResult
    override func visit(node: TreeNode<Directory>) -> TreeVisitor<Directory> {
        let visitor = super.visit(node: node)
        let currentBranchSize = branchSize[node.value.id]
        if currentBranchSize == nil {
            let nodeSize = node.value.totalSize
            let childSize = node.children.map {
                branchSize[$0.value.id] ?? $0.value.totalSize
            }.sum()
            let sizeOfChildrenAndNode = nodeSize + childSize
            branchSize[node.value.id] = sizeOfChildrenAndNode
        }
        return visitor
    }

}

open class TreeVisitor<Value: Hashable & Equatable> {

    @discardableResult
    open func visit(node: TreeNode<Value>) -> TreeVisitor<Value>{
        for node in node.children {
            visit(node: node)
        }
        return self
    }
}

private extension Dictionary where Key == String, Value == Int {

    func sumOfDirectorySizes() -> Int {
        self.map { $0.value }.sum()
    }
}

private struct File: Encodable, Hashable {

    let name: String
    let size: Int
}

private class Directory: Hashable, Encodable, Equatable {

    init(path: String) {
        self.path = path
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    let id: UUID = UUID()
    let path: String
    private(set) var contents: Set<File> = []

    func appendContents(_ content: File) {
        contents.insert(content)
    }

    lazy var totalSize: Int = { contents.map { $0.size }.sum() }()

    static func == (lhs: Directory, rhs: Directory) -> Bool {
        lhs.id == rhs.id
    }
}

private extension Sequence where Element == String {

    func parseCommandList() -> Tree<Directory> {
        let cdRegex = Regex {
            "$ cd"
            One(.whitespace)
            Capture {
                OneOrMore(.any)
            }
        }
        let lsRegex = Regex { "$ ls" }
        let dirRegex = Regex {
            "dir"
            One(.whitespace)
            Capture {
                OneOrMore(.any)
            }
        }
        let fileRegex = Regex {
            Capture {
                OneOrMore(.digit)
            }
            One(.whitespace)
            Capture {
                OneOrMore(.any)
            }
        }

        let tree = Tree<Directory>()

        let rootDirectory = Directory(path: "/")
        let node = tree.getOrCreateNode(value: rootDirectory)
        tree.setRootNodeIfNeeded(node: node)
        var currentNode = node

        for line in self {
            if let cdMatch = line.prefixMatch(of: cdRegex) {
                switch cdMatch.1 {
                case "..":
                    currentNode = currentNode.parent!
                    break
                default:
                    let path = String(cdMatch.1)
                    if path == "/" { break }
                    currentNode = currentNode.children.first { $0.value.path == path }!
                    break
                }
            } else if let _ = line.prefixMatch(of: lsRegex) {
                // Skip
            } else if let dirMatch = line.prefixMatch(of: dirRegex) {
                let path = String(dirMatch.1)
                let directory = Directory(path: path)
                let dirNode = tree.getOrCreateNode(value: directory)
                tree.connect(node: dirNode, parent: currentNode)
            } else {
                if let lineMatch = line.prefixMatch(of: fileRegex) {
                    let size = Int(String(lineMatch.1))!
                    let name = String(lineMatch.2)
                    let file = File(name: name, size: size)
                    currentNode.value.appendContents(file)
                }
            }
        }
        return tree
    }
}
