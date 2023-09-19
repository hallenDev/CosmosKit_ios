@testable import CosmosKit
import XCTest

class CosmosColorTests: XCTestCase {

    func testAllDynamicColorsLoadFromCatalog() {
        let allKnownColors = CosmosColor.allCases
        for name in allKnownColors {
            XCTAssertNotNil(UIColor(named: name.rawValue, in: .cosmos, compatibleWith: nil), "Missing color in asset catalog named \(name)")
        }
    }
}
