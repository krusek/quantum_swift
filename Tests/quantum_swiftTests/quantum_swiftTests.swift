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
        let tree = RandomAccessTree<Int>.tree(0, .leaf(5), .leaf(3)).withBorrowed()
        XCTAssertEqual(tree[0], 5)
        XCTAssertEqual(tree[1], 3)
        XCTAssertEqual(tree[2], Int.zero)
        XCTAssertEqual(tree[3], Int.zero)
    }
    
    func testTreeBorrowSet() {
        let tree = RandomAccessTree<Int>.tree(0, .leaf(5), .leaf(3))
            .withBorrowed()
            .withSet(index: 2, value: 8)
            .withBorrowed()
            .withSet(index: 6, value: 12)
        XCTAssertEqual(tree[0], 5)
        XCTAssertEqual(tree[1], 3)
        XCTAssertEqual(tree[2], 8)
        XCTAssertEqual(tree[3], Int.zero)
        XCTAssertEqual(tree[4], Int.zero)
        XCTAssertEqual(tree[5], Int.zero)
        XCTAssertEqual(tree[6], 12)
        XCTAssertEqual(tree[7], Int.zero)
    }
    
    func testDescription() {
        let tree = RandomAccessTree<Complex>
            .tree(0,
                  .leaf(.zero),
                  .leaf(.zero))
            .withBorrowed()
            .withSet(index: 0, value: .zero)
            .withSet(index: 1, value: Complex(real: 1, imaginary: 3))
            .withSet(index: 2, value: .one)
        XCTAssertEqual(tree.description, "(1.0 + 3.0i) |01> + (1.0) |10>")
        
    }
    
    func testPruning() {
        let tree = RandomAccessTree<Int>.tree(0, .leaf(5), .leaf(3))
            .withBorrowed()
            .withSet(index: 2, value: 8)
            .withSet(index: 0, value: 0)
            .withSet(index: 1, value: 0)
            .withSet(index: 2, value: 0)
            .withBorrowed()
            .withSet(index: 4, value: 1)
            .withSet(index: 4, value: 0)
        
        switch tree {
        case .tree(2, .zero, .zero):
            break
        default:
            XCTFail("tree: \(tree)")
        }
        
        switch tree.withBorrowed() {
        case .tree(3, .zero, .zero):
            break
        default:
            XCTFail("tree: \(tree.withBorrowed())")
            
        }
    }
}
