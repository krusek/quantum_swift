import XCTest
@testable import quantum_swift

extension Int: HasZero {
    public static var zero: Int { return 0 }
}

final class quantum_swiftTests: XCTestCase {
    func testTreeGetter() {
        let tree = RandomAccessTree<Int>.tree(0, .leaf(5), .leaf(3))
        XCTAssertEqual(tree[0], 5)
        XCTAssertEqual(tree[1], 3)
    }
    
    func testTreeGetterOutOfBounds() {
        let tree = RandomAccessTree<Int>.tree(0, .leaf(5), .leaf(3))
        XCTAssertEqual(tree[2], 5)
        XCTAssertEqual(tree[3], 3)
    }
    
    func testTreeBorrow() {
        let tree = RandomAccessTree<Int>.tree(0, .leaf(5), .leaf(3)).borrow()
        XCTAssertEqual(tree[0], 5)
        XCTAssertEqual(tree[1], 3)
        XCTAssertEqual(tree[2], Int.zero)
        XCTAssertEqual(tree[3], Int.zero)
    }
    
    func testTreeBorrowSet() {
        let tree = RandomAccessTree<Int>.tree(0, .leaf(5), .leaf(3))
            .borrow()
            .set(index: 2, value: 8)
            .borrow()
            .set(index: 6, value: 12)
        XCTAssertEqual(tree[0], 5)
        XCTAssertEqual(tree[1], 3)
        XCTAssertEqual(tree[2], 8)
        XCTAssertEqual(tree[3], Int.zero)
        XCTAssertEqual(tree[4], Int.zero)
        XCTAssertEqual(tree[5], Int.zero)
        XCTAssertEqual(tree[6], 12)
        XCTAssertEqual(tree[7], Int.zero)
    }
}
