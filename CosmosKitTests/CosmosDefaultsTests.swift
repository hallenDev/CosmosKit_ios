@testable import CosmosKit
import XCTest

class CosmosDefaultsTests: XCTestCase {

    var sut: CosmosDefaults!
    var testDefaults: TestUserDefaults!

    override func setUp() {
        testDefaults = TestUserDefaults(suiteName: "test")
        sut = CosmosDefaults(location: testDefaults)
    }

    func testLastStoredEdition() {

        sut.setLastStoredEditionKey(1234)

        XCTAssertTrue(testDefaults.setValueCalled)
        XCTAssertEqual(testDefaults.lastUsedKey, "lastStoredEditionKey")
        XCTAssertEqual(testDefaults.lastSetValue as? Int64, 1234)
    }

    func testSetLastStoredEdition_failed() {

        sut.setLastStoredEditionKey(nil)

        XCTAssertFalse(testDefaults.setValueCalled)
        XCTAssertNil(testDefaults.lastUsedKey)
        XCTAssertNil(testDefaults.lastSetValue)
    }

    func testGetLastStoredEditionKey() {

        testDefaults.returnObject = 12345

        let key = sut.getLastStoredEditionKey()

        XCTAssertTrue(testDefaults.objectForKeyCalled)
        XCTAssertEqual(testDefaults.lastUsedKey, "lastStoredEditionKey")
        XCTAssertEqual(key, 12345)
    }

    func testRemoveLastStoredEditionKey() {

        sut.removeLastStoredEditionKey()

        XCTAssertTrue(testDefaults.removeObjectCalled)
        XCTAssertEqual(testDefaults.lastUsedKey, "lastStoredEditionKey")
    }

    func testSetBodyFontSize() {

        sut.setBodyFontSize(.body)

        XCTAssertTrue(testDefaults.setValueCalled)
        XCTAssertEqual(testDefaults.lastUsedKey, "bodyFontSize")
        XCTAssertEqual(testDefaults.lastSetValue as? String, UIFont.TextStyle.body.rawValue)
    }

    func testGetBodyFontSize() {

        testDefaults.returnObject = UIFont.TextStyle.headline.rawValue

        let size = sut.getBodyFontSize()

        XCTAssertTrue(testDefaults.objectForKeyCalled)
        XCTAssertEqual(testDefaults.lastUsedKey, "bodyFontSize")
        XCTAssertEqual(size, UIFont.TextStyle.headline)
    }

    func testGetBodyFontSize_default() {

        let size = sut.getBodyFontSize()

        XCTAssertTrue(testDefaults.objectForKeyCalled)
        XCTAssertEqual(testDefaults.lastUsedKey, "bodyFontSize")
        XCTAssertEqual(size, UIFont.TextStyle.body)
    }

    func testEnableStaging() {

        sut.enableStaging()

        XCTAssertTrue(testDefaults.setBoolValueCalled)
        XCTAssertEqual(testDefaults.lastUsedKey, "useStaging")
        XCTAssertEqual(testDefaults.lastSetValue as? Bool, true)
    }

    func testDisableStaging() {

        sut.disableStaging()

        XCTAssertTrue(testDefaults.removeObjectCalled)
        XCTAssertEqual(testDefaults.lastUsedKey, "useStaging")
    }

    func testIsStagingEnabled_default() {

        XCTAssertFalse(sut.isStagingEnabled())

        XCTAssertTrue(testDefaults.boolForKeyCalled)
        XCTAssertEqual(testDefaults.lastUsedKey, "useStaging")
    }

    func testSetSubscriptions() {

        let topics = [
            "test1": true,
            "test2": false
        ]

        sut.setSubscriptions(topics)

        XCTAssertTrue(testDefaults.setValueCalled)
        XCTAssertEqual(testDefaults.lastUsedKey, "firebaseTopics")
        XCTAssertEqual(testDefaults.lastSetValue as? [String: Bool], topics)

    }

    func testGetSubscriptions() {

        testDefaults.returnObject = [
            "test1": true,
            "test2": false
        ]

        let subscriptions = sut.getSubscriptions()

        XCTAssertEqual(subscriptions, ["test1": true, "test2": false ])
        XCTAssertEqual(testDefaults.lastUsedKey, "firebaseTopics")
    }

    func testSetGlobalSubscriptions() {

        sut.setSubscriptions(enabled: true)

        XCTAssertTrue(testDefaults.setValueCalled)
        XCTAssertEqual(testDefaults.lastUsedKey, "subscriptions")
        XCTAssertTrue(testDefaults.lastSetValue as! Bool)
    }

    func testGetGlobalSubscriptionsStatus() {

        testDefaults.returnBool = true

        let value = sut.getSubscriptionsStatus()

        XCTAssertTrue(testDefaults.boolForKeyCalled)
        XCTAssertEqual(testDefaults.lastUsedKey, "subscriptions")
        XCTAssertTrue(value)
    }
}
