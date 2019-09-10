import Foundation

public struct MeasurableOperator {
    public let op: ComplexOperator
    public let eigenvalues: [Complex]
}

let mx = MeasurableOperator(op: x, eigenvalues: [.one, -.one])
let my = MeasurableOperator(op: y, eigenvalues: [.one, -.one])
let mz = MeasurableOperator(op: z, eigenvalues: [.one, -.one])
let mh = MeasurableOperator(op: h, eigenvalues: [.one, -.one])

