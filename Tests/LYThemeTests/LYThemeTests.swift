import XCTest
@testable import LYTheme

final class LYThemeTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(LYTheme().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
