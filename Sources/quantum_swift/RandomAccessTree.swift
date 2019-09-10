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
public indirect enum RandomAccessTree<Node> where Node: HasZero & Equatable {
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
    
    public func reduce<Result>(initial: Result, closure: (Result, Node) -> Result) -> Result {
        switch self {
        case .leaf(let node):
            return closure(initial, node)
        case .tree(_, let lhs, let rhs):
            let result = lhs.reduce(initial: initial, closure: closure)
            return rhs.reduce(initial: result, closure: closure)
        case .zero:
            return initial
        }
    }
    
    @discardableResult
    public mutating func set(index: Int, value: Node) -> RandomAccessTree<Node> {
        if self[index] == value { return self }
        self = self.setDepth(self.depth, index, value)
        return self
    }
    
    public func withSet(index: Int, value: Node) -> RandomAccessTree<Node> {
        return self.setDepth(self.depth, index, value)
    }
    
    private func setDepth(_ depth: Int, _ index: Int, _ value: Node) -> RandomAccessTree<Node> {
        switch self {
        case .tree(let d, let zero, let one) where index & (1 << d) == 0:
            return .tree(d, zero.setDepth(depth - 1, index, value).pruned(), one)
        case .tree(let d, let zero, let one):
            return .tree(d, zero, one.setDepth(depth - 1, index, value).pruned())
        case .leaf(_),
             .zero:
            if depth == -1 {
                return RandomAccessTree<Node>.leaf(value).pruned()
            } else {
                return RandomAccessTree<Node>.tree(depth, .zero, .zero).setDepth(depth, index, value)
            }
            
        }
    }
    
    private func pruned() -> RandomAccessTree<Node> {
        switch self {
        case .tree(_, .zero, .zero):
            return .zero
        case .leaf(let value) where value == .zero:
            return .zero
        default:
            return self
        }
    }
    
    @discardableResult
    public mutating func borrow() -> RandomAccessTree<Node> {
        self = .tree(self.depth + 1, self.pruned(), .zero)
        return self
    }
    
    public func withBorrowed() -> RandomAccessTree<Node> {
        var tree = self
        return tree.borrow()
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

extension RandomAccessTree: CustomStringConvertible where Node: CustomStringConvertible {
    public var description: String {
        let length = self.depth + 1
        let max = 1 << (length)
        let pieces = (0..<max).compactMap { (ix) -> String? in
            guard self[ix] != .zero else { return nil }
            let number = String(ix, radix: 2)
            let monomial = String(repeating: "0", count: length - number.count) + number
            return "(\(self[ix])) |\(monomial)>"
        }
        return pieces.joined(separator: " + ")
    }
}
