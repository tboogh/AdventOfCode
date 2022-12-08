public class Tree<Value: Equatable & Hashable> {

    public private(set) var rootNode: TreeNode<Value>? = nil
    public private(set) var nodes = Set<TreeNode<Value>>()

    public init() {}

    public func addNode(value: Value) -> TreeNode<Value> {
        return getOrCreateNode(value: value)
    }

    public func setRootNodeIfNeeded(node: TreeNode<Value>) {
        guard rootNode == nil else {
            return
        }

        rootNode = node
    }

    public func connect(node: TreeNode<Value>, parent: TreeNode<Value>) {
        parent.children.append(node)
        node.parent = parent
    }

    public func getOrCreateNode(value: Value) -> TreeNode<Value> {
        if let node = nodes.first(where: { $0.value == value }) {
            return node
        }
        let node = TreeNode(value: value)
        nodes.insert(node)
        return node
    }

    func findNode(value: Value) -> TreeNode<Value>? {
        nodes.first(where: { $0.value == value })
    }
}
