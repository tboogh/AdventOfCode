public class TreeNode<Value: Equatable & Hashable>: Hashable {

    public init(value: Value) {
        self.value = value
    }

    public let value: Value
    public var children: [TreeNode<Value>] = []
    public var parent: TreeNode<Value>?
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }

    public static func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
        lhs.value == rhs.value
    }

    public var isLeafNode: Bool {
        children.isEmpty
    }
}
