@testable import CosmosKit
import XCTest

class CosmosErrorTests: XCTestCase {

    func testLocalizedDescription() {

        XCTAssertEqual(CosmosError.invalidURL.localizedDescription, "Looks like something went wrong. The team will look into this ASAP.")
        XCTAssertEqual(CosmosError.authenticationError.localizedDescription, "You have provided an incorrect email address or password.")
        XCTAssertEqual(CosmosError.serverError.localizedDescription, "Looks like something went wrong. The team will look into this ASAP.")
        XCTAssertEqual(CosmosError.networkError(nil).localizedDescription, "Network problem. Please check your internet connection and try again")
        XCTAssertEqual(CosmosError.noResponse.localizedDescription, "Network problem. Please check your internet connection and try again")
        XCTAssertEqual(CosmosError.parsingError("test").localizedDescription, "Looks like something went wrong. The team will look into this ASAP.")
        XCTAssertEqual(CosmosError.apiError(DecodableError(code: 1, error: "test")).localizedDescription, "Looks like something went wrong. The team will look into this ASAP.")

    }
}
