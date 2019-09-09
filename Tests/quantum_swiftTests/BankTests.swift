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
        let x: (Complex, Complex) -> (Complex, Complex) = { (zero, one) in
            return (one, zero)
        }
        bank.operate(qubit: qs[0], op: x)
        print("bank: \(bank)")
        bank.operate(qubit: qs[0], op: x)
        print("bank: \(bank)")
        let h: (Complex, Complex) -> (Complex, Complex) = { (zero, one) in
            return ((one + zero) / sqrt(2), (zero - one) / sqrt(2))
        }
        bank.operate(qubit: qs[0], op: x)
        bank.operate(qubit: qs[0], op: h)
        print("bank: \(bank)")
        
        let z: (Complex, Complex) -> (Complex, Complex) = { (zero, one) in
            return (zero, -one)
        }
        bank.operate(qubit: qs[0], op: z)
        print("bank: \(bank)")
    }
}
