import Foundation

public struct Qubit {
    var index: Int

    func isZero(_ index: Int) -> Bool {
        return index & (1 << self.index) == 0
    }
}

extension RandomAccessTree where Node == Complex {
    func pairedMap(_ index: Int, mapping: Operator<Complex>, filter: (Int) -> Bool = { _ in true }) -> RandomAccessTree {
        var tree = self
        let mask = 1 << index
        for ix in 0..<(1<<tree.depth) {
            guard ix & mask == 0 else { continue }
            guard filter(ix) else { continue }
            
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

    static func *=(lhs: inout RandomAccessTree, rhs: Double) {
        for ix in 0..<(1 << (lhs.depth + 1)) {
            lhs.set(index: ix, value:lhs[ix] * rhs)
        }
    }

    static func linearCombination(lhs: RandomAccessTree, rhs: RandomAccessTree, lscalar: Complex, rscalar: Complex) -> RandomAccessTree {
        var r = (lhs.depth > rhs.depth) ? lhs : rhs
        for ix in 0..<(1 << (r.depth + 1)) {
            r.set(index: ix, value: lscalar*lhs[ix] + rscalar*rhs[ix])
        }
        return r
    }

    var probability: Double {
        return self.reduce(initial: 0.0) { (result, complex) -> Double in
            return result + complex.magnitudeSquared
        }
    }
}

public class Bank {
    var data = RandomAccessTree<Complex>.tree(0, .leaf(.one), .zero)
    private let generator: () -> Double
    
    public init() {
        generator = {
            return Double.random(in: 0.0...1.0)
        }
    }

    init(generator: @escaping () -> Double) {
        self.generator = generator
    }
    
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

    public func operate(qubit: Qubit, controls: [Qubit], antiControls: [Qubit], op: (Complex, Complex) -> (Complex, Complex)) {
        let filter: (Int) -> Bool = { ix  in
            if !controls.allSatisfy({ !$0.isZero(ix) }) { return false }
            if !antiControls.allSatisfy({ $0.isZero(ix) }) { return false }
            return true
        }
        data = data.pairedMap(qubit.index, mapping: op, filter: filter)
    }
    
    public func measure(qubit: Qubit, op: MeasurableOperator) -> Complex {
        assert(op.eigenvalues.count == 2)
        assert(op.eigenvalues == [Complex.one, -Complex.one])
        let mx = data.pairedMap(qubit.index, mapping: op.op)
        let pls = Complex.one / 2
        let prs = op.eigenvalues[1] / 2

        var p = RandomAccessTree.linearCombination(lhs: self.data, rhs: mx, lscalar: pls, rscalar: prs)
        let nls = Complex.one / 2
        let nrs = op.eigenvalues[0] / 2

        var n = RandomAccessTree.linearCombination(lhs: self.data, rhs: mx, lscalar: nls, rscalar: nrs)
        let pp = p.probability
        let pn = n.probability

        print("n: \(n), p: \(p), pp: \(pp), pn: \(pn)")
        let prob = self.generator()
        if pp >= prob && pp > 1e-6 {
            p *= 1 / sqrt(pp)
            self.data = p
            return op.eigenvalues[0]
        } else {
            n *= 1 / sqrt(pn)
            self.data = n
            return op.eigenvalues[1]
        }
    }
}

extension Bank: CustomStringConvertible {
    public var description: String {
        return data.description
    }
}
