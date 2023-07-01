import XCTest
@testable import FileCache

final class FileCacheTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(FileCache().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
