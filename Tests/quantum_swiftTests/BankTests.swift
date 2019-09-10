//
//  BankTests.swift
//  quantum_swiftTests
//
//  Created by Korben Rusek on 9/8/19.
//

import XCTest
@testable import quantum_swift

class BankTests: XCTestCase {
    func testSimpleOperations() {
        let bank = Bank()
        let qs = bank.borrow(count: 1)
        bank.operate(qubit: qs[0], op: x)
        XCTAssertTrue(equals(bank, [1: Complex.one]))
        bank.operate(qubit: qs[0], op: x)
        XCTAssertTrue(equals(bank, [0: Complex.one]))

        bank.operate(qubit: qs[0], op: x)
        bank.operate(qubit: qs[0], op: h)
        XCTAssertTrue(equals(bank, [0: Complex(real: 1.0/sqrt(2), imaginary: 0),
                                    1: Complex(real: -1.0/sqrt(2), imaginary: 0)]))
        
        bank.operate(qubit: qs[0], op: z)
        XCTAssertTrue(equals(bank, [0: Complex(real: 1.0/sqrt(2), imaginary: 0),
                                    1: Complex(real: 1.0/sqrt(2), imaginary: 0)]))
    }

    func testControlledOperations() {
        let bank = Bank()
        let qs = bank.borrow(count: 2)
        bank.operate(qubit: qs[0], op: h)
        bank.operate(qubit: qs[1], controls: [qs[0]], antiControls: [], op: x)
        XCTAssertTrue(equals(bank, [0: Complex(real: 1.0/sqrt(2), imaginary: 0),
                                    3: Complex(real: 1.0/sqrt(2), imaginary: 0)]))
    }

    func testAntiControlledOperations() {
        let bank = Bank()
        let qs = bank.borrow(count: 2)
        bank.operate(qubit: qs[0], op: h)
        bank.operate(qubit: qs[1], controls: [], antiControls: [qs[0]], op: x)
        XCTAssertTrue(equals(bank, [1: Complex(real: 1.0/sqrt(2), imaginary: 0),
                                    2: Complex(real: 1.0/sqrt(2), imaginary: 0)]))
    }
}

protocol ComplexLookup {
    func value(_ index: Int) -> Complex
    var count: Int { get }
}

extension Bank: ComplexLookup {
    func value(_ index: Int) -> Complex {
        return self.data[index]
    }

    var count: Int {
        return 1 << self.data.depth
    }
}

extension Array: ComplexLookup where Element == Complex {
    func value(_ index: Int) -> Complex {
        if index >= self.count { return Complex.zero }
        return self[index]
    }
}

extension Dictionary: ComplexLookup where Key == Int, Value == Complex {
    func value(_ index: Int) -> Complex {
        return self[index] ?? Complex.zero
    }
}

func equals(_ lhs: ComplexLookup, _ rhs: ComplexLookup) -> Bool {
    for ix in 0..<max(lhs.count, rhs.count) {
        if lhs.value(ix) != rhs.value(ix) { return false }
    }
    return true
}
