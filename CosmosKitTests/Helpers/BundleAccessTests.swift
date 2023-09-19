import XCTest
@testable import CosmosKit

class BundleAccessTests: XCTestCase {

    func testCreate() {

        XCTAssertNotNil(Bundle.cosmos.getOptionalValue(for: .version))
        XCTAssertNotNil(Bundle.cosmos.getOptionalValue(for: .build))
        XCTAssertNotNil(Bundle.cosmos.getValue(for: .version))
        XCTAssertNotNil(Bundle.cosmos.getValue(for: .build))
    }
}
