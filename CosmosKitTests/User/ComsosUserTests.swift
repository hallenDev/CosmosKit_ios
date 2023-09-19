import XCTest
@testable import CosmosKit

class ComsosUserTests: XCTestCase {

    var publication: Publication!
    var fallbackConfig: FallbackConfig!
    var config: CosmosConfig!

    override func setUp() {
        super.setUp()
        fallbackConfig = FallbackConfig(noNetworkFallback: TestFallback(),
                                        articleFallback: TestFallback(),
                                        searchFallback: TestFallback())
        publication = TestPublication(fallbackConfig: fallbackConfig)
        
        config = CosmosConfig(publication: publication)
    }

    func testCreate() {
        let json = readJSONData("User")

        do {
            let sut = try JSONDecoder().decode(CosmosUser.self, from: json)

            XCTAssertEqual(sut.firstname, "Flat")
            XCTAssertEqual(sut.lastname, "Circle")
            XCTAssertEqual(sut.email, "flatcircle@guerrillamail.info")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testSetUser_SetsKeychain() {

        let sut = Cosmos(client: TestableCosmosClient(apiConfig: config), apiConfig: config,
                         errorDelegate: nil, eventDelegate: nil)

        sut.user = CosmosUser(firstname: "piet", lastname: "pompies", email: "piet@pompies.com", guid: "test")

        let user = Keychain.getUser()
        XCTAssertEqual(user?.firstname, "piet")
        XCTAssertEqual(user?.lastname, "pompies")
        XCTAssertEqual(user?.email, "piet@pompies.com")
    }

    func testRemoveUser_ClearsKeychain() {

        let sut = Cosmos(client: TestableCosmosClient(apiConfig: config), apiConfig: config,
                         errorDelegate: nil, eventDelegate: nil)

        sut.user = CosmosUser(firstname: "piet", lastname: "pompies", email: "piet@pompies.com", guid: "test")

        XCTAssertNotNil(Keychain.getUser())

        sut.user = nil
        XCTAssertNil(Keychain.getUser())
    }
}
