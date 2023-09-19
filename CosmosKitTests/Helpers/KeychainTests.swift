@testable import CosmosKit
import XCTest
import SwiftKeychainWrapper

class KeychainTests: XCTestCase {

    var testKeyChain = TestableKeyChainWrapper()

    override func setUp() {
        super.setUp()
        Keychain.keychain = testKeyChain
    }

    override func tearDown() {
        super.tearDown()
        Keychain.keychain = KeychainWrapper.standard
    }

    func testSetAccessToken_notNil() {

        let token = AccessToken(token: "12345", expires: "123456")

        Keychain.setAccessToken(token)

        XCTAssertTrue(testKeyChain.setStringCalled)
        XCTAssertTrue(testKeyChain.setStringValues.contains("12345"))
        XCTAssertTrue(testKeyChain.setStringValues.contains("123456"))
        XCTAssertTrue(testKeyChain.stringKeys.contains(Keychain.Keys.accessToken.rawValue))
        XCTAssertTrue(testKeyChain.stringKeys.contains(Keychain.Keys.accessTokenExpiry.rawValue))
    }

    func testSetAccessToken_nil_removes() {

        Keychain.setAccessToken(nil)

        XCTAssertTrue(testKeyChain.removeCalled)
        XCTAssertTrue(testKeyChain.removeKeys.contains(Keychain.Keys.accessToken.rawValue))
        XCTAssertTrue(testKeyChain.removeKeys.contains(Keychain.Keys.accessTokenExpiry.rawValue))
    }

    func testSetUser_nil_removes() {

        Keychain.setUser(nil)

        XCTAssertTrue(testKeyChain.removeCalled)
        XCTAssertTrue(testKeyChain.removeKeys.contains(Keychain.Keys.userEmail.rawValue))
        XCTAssertTrue(testKeyChain.removeKeys.contains(Keychain.Keys.userFirstName.rawValue))
        XCTAssertTrue(testKeyChain.removeKeys.contains(Keychain.Keys.userLastName.rawValue))
        XCTAssertTrue(testKeyChain.removeKeys.contains(Keychain.Keys.accessToken.rawValue))
        XCTAssertTrue(testKeyChain.removeKeys.contains(Keychain.Keys.accessTokenExpiry.rawValue))
        XCTAssertTrue(testKeyChain.removeKeys.contains(Keychain.Keys.guid.rawValue))
    }

    func testSetUser_notNil() {

        let user = CosmosUser(firstname: "test", lastname: "tester", email: "test@test.com", guid: "testguid")

        Keychain.setUser(user)

        XCTAssertTrue(testKeyChain.setStringCalled)
        XCTAssertTrue(testKeyChain.setStringValues.contains("test"))
        XCTAssertTrue(testKeyChain.setStringValues.contains("tester"))
        XCTAssertTrue(testKeyChain.setStringValues.contains("test@test.com"))
        XCTAssertTrue(testKeyChain.setStringValues.contains("testguid"))
        XCTAssertTrue(testKeyChain.stringKeys.contains(Keychain.Keys.userEmail.rawValue))
        XCTAssertTrue(testKeyChain.stringKeys.contains(Keychain.Keys.userFirstName.rawValue))
        XCTAssertTrue(testKeyChain.stringKeys.contains(Keychain.Keys.userLastName.rawValue))
        XCTAssertTrue(testKeyChain.stringKeys.contains(Keychain.Keys.guid.rawValue))
    }

    func testSetUser_notNil_noguid() {

        let user = CosmosUser(firstname: "test", lastname: "tester", email: "test@test.com", guid: nil)

        Keychain.setUser(user)

        XCTAssertTrue(testKeyChain.setStringCalled)
        XCTAssertTrue(testKeyChain.setStringValues.contains("test"))
        XCTAssertTrue(testKeyChain.setStringValues.contains("tester"))
        XCTAssertTrue(testKeyChain.setStringValues.contains("test@test.com"))
        XCTAssertFalse(testKeyChain.setStringValues.contains("testguid"))
        XCTAssertTrue(testKeyChain.stringKeys.contains(Keychain.Keys.userEmail.rawValue))
        XCTAssertTrue(testKeyChain.stringKeys.contains(Keychain.Keys.userFirstName.rawValue))
        XCTAssertTrue(testKeyChain.stringKeys.contains(Keychain.Keys.userLastName.rawValue))
        XCTAssertFalse(testKeyChain.stringKeys.contains(Keychain.Keys.guid.rawValue))
    }

    func testGetUser_exists() {

        testKeyChain.getStringValues[Keychain.Keys.userEmail.rawValue] = "test@test"
        testKeyChain.getStringValues[Keychain.Keys.userFirstName.rawValue] = "tester"
        testKeyChain.getStringValues[Keychain.Keys.userLastName.rawValue] = "tester"
        testKeyChain.getStringValues[Keychain.Keys.guid.rawValue] = "testguid"

        guard let user = Keychain.getUser() else {
            XCTFail("User was nil")
            return
        }
        XCTAssertTrue(testKeyChain.getStringCalled)
        XCTAssertEqual(user.firstname, "tester")
        XCTAssertEqual(user.lastname, "tester")
        XCTAssertEqual(user.email, "test@test")
        XCTAssertEqual(user.guid, "testguid")
    }

    func testGetUser_exists_noguid() {

        testKeyChain.getStringValues[Keychain.Keys.userEmail.rawValue] = "test@test"
        testKeyChain.getStringValues[Keychain.Keys.userFirstName.rawValue] = "testername"
        testKeyChain.getStringValues[Keychain.Keys.userLastName.rawValue] = "testerlastname"

        guard let user = Keychain.getUser() else {
            XCTFail("User was nil")
            return
        }
        XCTAssertTrue(testKeyChain.getStringCalled)
        XCTAssertEqual(user.firstname, "testername")
        XCTAssertEqual(user.lastname, "testerlastname")
        XCTAssertEqual(user.email, "test@test")
        XCTAssertNil(user.guid)
    }

    func testGetUser_nil() {

        let user = Keychain.getUser()

        XCTAssertNil(user)
        XCTAssertTrue(testKeyChain.getStringCalled)
    }

    func testGetAccessToken() {

        testKeyChain.getStringValues[Keychain.Keys.accessToken.rawValue] = "test"

        let token = Keychain.getAccessTokenValue()

        XCTAssertTrue(testKeyChain.getStringCalled)
        XCTAssertEqual(token, "test")
    }

    func testGetAccessTokenExpiry() {

        testKeyChain.getStringValues[Keychain.Keys.accessTokenExpiry.rawValue] = "test"

        let expiry = Keychain.getAccessTokenExpiry()

        XCTAssertTrue(testKeyChain.getStringCalled)
        XCTAssertEqual(expiry, "test")
    }
}
