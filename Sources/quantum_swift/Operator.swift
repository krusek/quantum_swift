import Foundation

public typealias Operator<Node> = (Node, Node) -> (Node, Node)
public typealias ComplexOperator = Operator<Complex>

let sqrtHalf = 1.0/sqrt(2)

public let h: ComplexOperator = { (zero, one) in
    return ((zero + one) * sqrtHalf, (zero - one) * sqrtHalf)
}

public let x: ComplexOperator = { (zero, one) in
    return (one, zero)
}

public let y: ComplexOperator = { (zero, one) in
    return (-Complex.i * one, Complex.i * zero)
}

public let z: ComplexOperator = { (zero, one) in
    return (zero, -one)
}

public let i: ComplexOperator = { (zero, one) in
    return (zero, one)
}

public let ri: (Double) -> ComplexOperator = { (angle) in
    return { (zero, one) in
        let rotation = Complex.polar(r: 1, theta: angle)
        return (zero * rotation, one * rotation)
    }
}

public let rx: (Double) -> ComplexOperator = { (angle) in
    let c = cos(angle / 2)
    let s = sin(angle / 2)
    return { (zero: Complex, one: Complex) -> (Complex, Complex) in
        return (zero * c - Complex.i * one * s, one * c - Complex.i * zero * s)
    }
}

public let ry: (Double) -> ComplexOperator = { (angle) in
    let c = cos(angle / 2)
    let s = sin(angle / 2)
    return { (zero: Complex, one: Complex) -> (Complex, Complex) in
        return (zero * c - one * s,
                one * c + zero * s)
    }
}

public let rz: (Double) -> ComplexOperator = { (angle) in
    let c = cos(angle / 2)
    let s = sin(angle / 2)
    return { (zero: Complex, one: Complex) -> (Complex, Complex) in
        return (zero * (Complex.one * c - Complex.i * s),
                one * (Complex.one * c + Complex.i * s))
    }
}
