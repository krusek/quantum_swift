//
//  BankTests.swift
//  quantum_swiftTests
//
//  Created by Korben Rusek on 9/8/19.
//

import XCTest
import quantum_swift

class BankTests: XCTestCase {
    func testSimpleOperations() {
        let bank = Bank()
        let qs = bank.borrow(count: 1)
        bank.operate(qubit: qs[0], op: x)
        XCTAssertEqual("\(bank)", "(1.0) |1>")
        bank.operate(qubit: qs[0], op: x)
        XCTAssertEqual("\(bank)", "(1.0) |0>")

        bank.operate(qubit: qs[0], op: x)
        bank.operate(qubit: qs[0], op: h)
        XCTAssertEqual("\(bank)", "(0.7071067811865475) |0> + (-0.7071067811865475) |1>")
        
        bank.operate(qubit: qs[0], op: z)
        XCTAssertEqual("\(bank)", "(0.7071067811865475) |0> + (0.7071067811865475) |1>")
    }

    func testControlledOperations() {
        let bank = Bank()
        let qs = bank.borrow(count: 2)
        bank.operate(qubit: qs[0], op: h)
        bank.operate(qubit: qs[1], controls: [qs[0]], antiControls: [], op: x)
        XCTAssertEqual("\(bank)", "(0.7071067811865475) |00> + (0.7071067811865475) |11>")
    }

    func testAntiControlledOperations() {
        let bank = Bank()
        let qs = bank.borrow(count: 2)
        bank.operate(qubit: qs[0], op: h)
        bank.operate(qubit: qs[1], controls: [], antiControls: [qs[0]], op: x)
        XCTAssertEqual("\(bank)", "(0.7071067811865475) |01> + (0.7071067811865475) |10>")
    }

}
