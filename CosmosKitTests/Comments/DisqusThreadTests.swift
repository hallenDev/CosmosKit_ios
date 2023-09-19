@testable import CosmosKit
import XCTest

class DisqusThreadTests: XCTestCase {

    func testCreate() {
        let jsonData = readJSONData("DisqusThreadResponse")

        do {
            let sut = try JSONDecoder().decode(DisqusResponse.self, from: jsonData).response.first

            XCTAssertEqual(sut!.posts, 6)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
