import XCTest
@testable import ToDo_Titan

class ToDo_TitanTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(ToDo_Titan().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
