/*
 This is a set of protocols and helper functions to allow easier
 assertions that quantum banks contain their expected values. This
 way one can create either an array or a dictionary with values
 that match, at least, the non-zero elements of the bank. To be
 equal then any place they disagree must be zero or empty.
 */

import XCTest
import Foundation

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

protocol ComplexConvertible {
    var complex: Complex { get }
}

extension Complex: ComplexConvertible {
    var complex: Complex {
        return self
    }
}

extension Double: ComplexConvertible {
    var complex: Complex {
        return .real(self)
    }
}

extension Array: ComplexLookup where Element == ComplexConvertible {
    func value(_ index: Int) -> Complex {
        if index >= self.count { return Complex.zero }
        return self[index].complex
    }
}

extension Dictionary: ComplexLookup where Key == Int, Value == ComplexConvertible {
    func value(_ index: Int) -> Complex {
        return self[index]?.complex ?? Complex.zero
    }
}

func AssertEqual(_ lhs: ComplexLookup, _ rhs: ComplexLookup, _ message: String? = nil) {
    if let message = message {
        XCTAssertTrue(equals(lhs, rhs), message)
    } else {
        XCTAssertTrue(equals(lhs, rhs))
    }
}

func equals(_ lhs: ComplexLookup, _ rhs: ComplexLookup) -> Bool {
    for ix in 0..<max(lhs.count, rhs.count) {
        if lhs.value(ix) != rhs.value(ix) { return false }
    }
    return true
}
