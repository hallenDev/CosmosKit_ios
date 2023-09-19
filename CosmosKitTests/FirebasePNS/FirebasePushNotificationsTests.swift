@testable import CosmosKit
import XCTest

class FirebasePushNotificationsTests: XCTestCase {

    var sut: FirebasePushNotifications!
    var testDefaults: TestableCosmosDefaults!
//    var testMessaging: TestableFirebaseMessaging!

    override func setUp() {
        testDefaults = TestableCosmosDefaults()
//        testMessaging = TestableFirebaseMessaging(test: true)
//        sut = FirebasePushNotifications(defaults: testDefaults, messaging: testMessaging)
        sut = FirebasePushNotifications(defaults: testDefaults)
    }
    // NOTE: commented because Firebase does not allow init override and can't create this class
//    func testCreate() {
//
//        XCTAssertNotNil(sut)
//        XCTAssertTrue(testMessaging.delegate is FirebasePushNotifications)
//        XCTAssertTrue(testMessaging.subscribeCalled)
//        XCTAssertEqual(testMessaging.lastTopic, "debug")
//    }
//
//    func testSubscribe() {
//
//        sut.subscribe(to: "test")
//
//        XCTAssertTrue(testMessaging.subscribeCalled)
//        XCTAssertEqual(testMessaging.lastTopic, "test")
//    }
//
//    func testSubscribes() {
//
//        sut.subscribe(to: ["test", "test2"])
//
//        XCTAssertTrue(testMessaging.subscribeCalled)
//        XCTAssertEqual(testMessaging.lastTopic, "test2")
//    }
//
//    func testUnsubscribe() {
//
//        sut.unsubscribe(from: "test")
//
//        XCTAssertTrue(testMessaging.unsubscribeCalled)
//        XCTAssertEqual(testMessaging.lastTopic, "test")
//    }
//
//    func testUnsubscribes() {
//
//        sut.unsubscribe(from: ["test", "test2"])
//
//        XCTAssertTrue(testMessaging.unsubscribeCalled)
//        XCTAssertEqual(testMessaging.lastTopic, "test2")
//    }
//
//    func testRegisteredForNotifications() {
//
//        sut.registeredForNotifications(with: "test".data(using: .utf8)!)
//
//        XCTAssertEqual(testMessaging.apnsToken, "test".data(using: .utf8)!)
//    }
//
//    func testCopyTokenToClipboard() {
//
//        sut.copyTokenToClipboard()
//
//        XCTAssertTrue(testMessaging.tokenCalled)
//    }

    func testExtractArticleKey() {

        let info = ["article_key": "5902625498202112"]

        let key = sut.extractArticleKey(from: info)

        XCTAssertEqual(key, 5902625498202112)
    }

    func testExtractArticleKey_fails() {

        let info = ["article_ke": "5902625498202112"]

        let key = sut.extractArticleKey(from: info)

        XCTAssertNil(key)
    }

    func testGetSubscriptions() {

        _ = sut.getSubscriptions()

        XCTAssertTrue(testDefaults.getSubscriptionsCalled)
    }

    func testGetGlobalSubscriptionsStatus() {

        _ = sut.getLocalSubscriptionStatus()

        XCTAssertTrue(testDefaults.getSubscriptionsStatusCalled)
    }

    func testUnsubscribeFromAll() {

        sut.unsubscribeFromAll()

        XCTAssertTrue(testDefaults.getSubscriptionsCalled)
//        XCTAssertTrue(testMessaging.unsubscribeCalled)
//        XCTAssertTrue(testDefaults.setSubscriptionsCalled)
    }
}
