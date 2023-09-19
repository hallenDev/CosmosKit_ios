import XCTest
@testable import CosmosKit

class CosmosConfigTests: XCTestCase {

    func testCreate_default() {

        let publication = TestPublication(consumerKey: "key", liveDomain: "baseURL", id: "pub", name: "Pub", isEdition: false)
        let sut = CosmosConfig(publication: publication)
        
        XCTAssertEqual(sut.publication.consumerKey, "key")
        XCTAssertEqual(sut.publication.domain, "baseURL")
        XCTAssertEqual(sut.publication.id, "pub")
        XCTAssertEqual(sut.publication.name, "Pub")
        XCTAssertFalse(sut.publication.isEdition)
        XCTAssertEqual(sut.apiVersion, 1)
    }

    func testCreate_nonDefault() {

        let publication = TestPublication(consumerKey: "key", liveDomain: "baseURL", id: "pub", name: "Pub", isEdition: true)

        let sut = CosmosConfig(publication: publication, apiVersion: 2)

        XCTAssertEqual(sut.publication.consumerKey, "key")
        XCTAssertEqual(sut.publication.domain, "baseURL")
        XCTAssertEqual(sut.publication.id, "pub")
        XCTAssertEqual(sut.publication.name, "Pub")
        XCTAssertTrue(sut.publication.isEdition)
        XCTAssertEqual(sut.apiVersion, 2)
    }
}
