public protocol HasZero {
    static var zero: Self { get }
}

/// This is a random access sparse tree that acts similarly to an array with default values.
/// You can access elements by index. The default value is
/// supplied by the type of element that it holds.
///
/// - tree: Depth indicates which bit to compare for indexes. The first subtree is the zero but and the second is the one bit.
/// - zero: This means the subtree is not created, so everything below this tree uses the default value.
/// - leaf: A value containing leaf
public indirect enum RandomAccessTree<Node> where Node: HasZero {
    case tree(Int, RandomAccessTree, RandomAccessTree), zero, leaf(Node)
    
    public subscript(index: Int) -> Node {
        get {
            switch self {
            case .tree(let depth, let zero, let one):
                if index & (1 << depth) == 0 {
                    return zero[index]
                } else {
                    return one[index]
                }
            case .zero:
                return Node.zero
            case .leaf(let node):
                return node
            }
        }
    }
    
    public func set(index: Int, value: Node) -> RandomAccessTree<Node> {
        return self.setDepth(self.depth, index, value)
    }
    
    private func setDepth(_ depth: Int, _ index: Int, _ value: Node) -> RandomAccessTree<Node> {
        switch self {
        case .tree(let d, let zero, let one) where index & (1 << d) == 0:
            return .tree(d, zero.setDepth(depth - 1, index, value), one)
        case .tree(let d, let zero, let one):
            return .tree(d, zero, one.setDepth(depth - 1, index, value))
        case .leaf(_),
             .zero:
            if depth == -1 {
                return .leaf(value)
            } else {
                return RandomAccessTree<Node>.tree(depth, .zero, .zero).setDepth(depth, index, value)
            }
            
        }
    }
    
    public func borrow() -> RandomAccessTree<Node> {
        return .tree(self.depth + 1, self, .zero)
    }
    
    public var depth: Int {
        switch self {
        case .tree(let depth, _, _):
            return depth
        default:
            return 0
        }
    }
}
