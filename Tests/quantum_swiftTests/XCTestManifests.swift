import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(quantum_swiftTests.allTests),
    ]
}
#endif
