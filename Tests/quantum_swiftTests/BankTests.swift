import XCTest
@testable import quantum_swift

let root1_2 = 1.0 / sqrt(2.0)

class BankTests: XCTestCase {
    func testSimpleOperations() {
        let bank = Bank()
        let qs = bank.borrow(count: 1)
        bank.operate(qubit: qs[0], op: x)
        AssertEqual(bank, [1: 1.0])
        bank.operate(qubit: qs[0], op: x)
        AssertEqual(bank, [0: 1.0])

        bank.operate(qubit: qs[0], op: x)
        bank.operate(qubit: qs[0], op: h)
        AssertEqual(bank, [0: root1_2, 1: -root1_2])
        
        bank.operate(qubit: qs[0], op: z)
        AssertEqual(bank, [0: root1_2, 1: root1_2])
    }

    func testControlledOperations() {
        let bank = Bank()
        let qs = bank.borrow(count: 2)
        bank.operate(qubit: qs[0], op: h)
        bank.operate(qubit: qs[1], controls: [qs[0]], antiControls: [], op: x)
        AssertEqual(bank, [0: root1_2, 3: root1_2])
    }

    func testAntiControlledOperations() {
        let bank = Bank()
        let qs = bank.borrow(count: 2)
        bank.operate(qubit: qs[0], op: h)
        bank.operate(qubit: qs[1], controls: [], antiControls: [qs[0]], op: x)
        AssertEqual(bank, [1: root1_2, 2: root1_2])
    }
}

extension BankTests {
    func testMeasurement() {
        let (bank, qs) = bellState(generator: { 0.0 })
        print("bank: \(bank)")
        XCTAssertEqual(bank.measure(qubit: qs[0], op: mz), .real(1.0))
        AssertEqual(bank, [1: 1.0])

        XCTAssertEqual(bank.measure(qubit: qs[1], op: mz), .real(-1.0))
        AssertEqual(bank, [1: 1.0])
    }

    private func bellState(generator: @escaping () -> Double) -> (Bank, [Qubit]) {
        let bank = Bank(generator: generator)
        let qs = bank.borrow(count: 2)
        bank.operate(qubit: qs[0], op: h)
        bank.operate(qubit: qs[1], controls: [], antiControls: [qs[0]], op: x)
        return (bank, qs)
    }
}
