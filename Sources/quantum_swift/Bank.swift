import Foundation

public struct Qubit {
    var index: Int
}

extension RandomAccessTree {
    func pairedMap(_ index: Int, mapping: (Node, Node) -> (Node, Node)) -> RandomAccessTree {
        var tree = self
        let mask = 1 << index
        for ix in 0..<(1<<tree.depth) {
            guard ix & mask == 0 else { continue }
            
            let oneIndex = ix | mask
            let zero = self[ix]
            let one = self[oneIndex]
            
            let (newZero, newOne) = mapping(zero, one)
            guard newZero != zero || newOne != one else { continue }
            tree = tree.set(index: ix, value: newZero)
            tree = tree.set(index: oneIndex, value: newOne)
        }
        return tree
    }
}

public class Bank {
    var data = RandomAccessTree<Complex>.tree(0, .leaf(.one), .zero)
    
    public init() { }
    
    var borrowed = false
    public func borrow(count: Int) -> [Qubit] {
        let index = data.depth
        let qs = (0..<count).map { (ix) -> Qubit in
            if index + ix == 0 && !borrowed {
                borrowed = true
                return Qubit(index: 0)
            }
            data.borrow()
            return Qubit(index: ix + index)
        }
        return qs
    }
    
    public func operate(qubit: Qubit, op: (Complex, Complex) -> (Complex, Complex)) {
        data = data.pairedMap(qubit.index, mapping: op)
    }
}

extension Bank: CustomStringConvertible {
    public var description: String {
        return data.description
    }
}
