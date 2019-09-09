//
//  BankTests.swift
//  quantum_swiftTests
//
//  Created by Korben Rusek on 9/8/19.
//

import XCTest
import quantum_swift

class BankTests: XCTestCase {
    func testExample() {
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
}
