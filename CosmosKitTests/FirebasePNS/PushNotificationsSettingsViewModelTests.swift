@testable import CosmosKit
import XCTest

class PushNotificationsSettingsViewModelTests: XCTestCase {

    var testCosmos: TestableCosmos!
    var sut: PushNotificationsSettingsViewModel!

    let test1 = PushNotificationConfig.PushTopic(id: "test1", name: "test 1")
    let test2 = PushNotificationConfig.PushTopic(id: "test2", name: "test 2")
    let test3 = PushNotificationConfig.PushTopic(id: "test3", name: "test 3")

    override func setUp() {
        testCosmos = TestableCosmos()
        sut = PushNotificationsSettingsViewModel(cosmos: testCosmos)
    }

    func testCreate() {

        XCTAssertEqual(sut.title, LanguageManager.shared.translateUppercased(key: .manageNotifications))
        XCTAssertEqual(sut.info, "test")
    }

    func testRetrieveValues_enabled() {

        let exp = expectation(description: "testRetrieveValues")

        sut.retrieveValues {
            XCTAssertEqual(self.sut.rows, 3)
            XCTAssertEqual(self.sut.values[0].title, LanguageManager.shared.translate(key: .turnOnAlerts))
            XCTAssertTrue(self.sut.values[0].enabled)
            XCTAssertEqual(self.sut.values[1].title, "Test")
            XCTAssertEqual(self.sut.values[1].id, "test")
            XCTAssertTrue(self.sut.values[1].enabled)
            XCTAssertEqual(self.sut.values[2].title, "Test 2")
            XCTAssertEqual(self.sut.values[2].id, "test2")
            XCTAssertFalse(self.sut.values[2].enabled)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testRetrieveValues_disabled() {

        let exp = expectation(description: "testRetrieveValues_disabled")
        (testCosmos.pushNotifications as? TestableFirebasePushNotifications)?.testLocalSubs = false

        sut.retrieveValues {
            XCTAssertEqual(self.sut.rows, 1)
            XCTAssertEqual(self.sut.values[0].title, LanguageManager.shared.translate(key: .turnOnAlerts))
            XCTAssertFalse(self.sut.values[0].enabled)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testRetrieveValues_newtopic() {

        let exp = expectation(description: "testRetrieveValues_newtopic")

        let fallbackConfig = FallbackConfig(noNetworkFallback: TestFallback(),
                                        articleFallback: TestFallback(),
                                        searchFallback: TestFallback())
        let publication = TestPublication(fallbackConfig: fallbackConfig,
                                          settingsConfig: SettingsConfig(pushNotificationConfig: PushNotificationConfig(info: "test",
                                                                                                                        topics: [test1, test2, test3],
                                                                                                                        defaultValue: false),
                                                                         newslettersConfig: NewslettersConfig(info: "test")))
        let config = CosmosConfig(publication: publication)
        let client = TestableCosmosClient(apiConfig: config)
        let cosmos = Cosmos(client: client, apiConfig: config, errorDelegate: nil, eventDelegate: nil)
        cosmos.pushNotifications = TestableFirebasePushNotifications(defaults: TestableCosmosDefaults(location: UserDefaults.init(suiteName: "test")))
        sut = PushNotificationsSettingsViewModel(cosmos: cosmos)

        sut.retrieveValues {
            XCTAssertEqual(self.sut.rows, 4)
            XCTAssertEqual(self.sut.values[0].title, LanguageManager.shared.translate(key: .turnOnAlerts))
            XCTAssertEqual(self.sut.values[0].id, "all_on")
            XCTAssertTrue(self.sut.values[0].enabled)
            XCTAssertEqual(self.sut.values[1].title, "test 1")
            XCTAssertEqual(self.sut.values[1].id, "test1")
            XCTAssertFalse(self.sut.values[1].enabled)
            XCTAssertEqual(self.sut.values[2].title, "test 2")
            XCTAssertEqual(self.sut.values[2].id, "test2")
            XCTAssertFalse(self.sut.values[2].enabled)
            XCTAssertEqual(self.sut.values[3].title, "test 3")
            XCTAssertEqual(self.sut.values[3].id, "test3")
            XCTAssertFalse(self.sut.values[3].enabled)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testGetValue() {

        let exp = expectation(description: "testRetrieveValues_newtopic")

        sut.retrieveValues {
            XCTAssertNotNil(self.sut.getValue(at: IndexPath(row: 0, section: 0)))
            XCTAssertNotNil(self.sut.getValue(at: IndexPath(row: 1, section: 1)))
            XCTAssertNil(self.sut.getValue(at: IndexPath(row: -1, section: 0)))
            XCTAssertNil(self.sut.getValue(at: IndexPath(row: 3, section: 0)))
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testValueChanged_alloff_enabled() {

        let exp = expectation(description: "testValueChanged_alloff_enabled")

        sut.retrieveValues {
            self.sut.valueChanged(enabled: false, at: IndexPath(row: 0, section: 0)) { _ in
                XCTAssertTrue((self.testCosmos.pushNotifications as! TestableFirebasePushNotifications).unsubscribeFromAllCalled)
                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testValueChanged_enabled() {

        let exp = expectation(description: "testValueChanged_enabled")

        sut.retrieveValues {

            self.sut.valueChanged(enabled: true, at: IndexPath(row: 1, section: 0)) {_ in
                XCTAssertTrue((self.testCosmos.pushNotifications as! TestableFirebasePushNotifications).subscribeCalled)
                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testValueChanged_disabled() {

        let exp = expectation(description: "testValueChanged_enabled")

        sut.retrieveValues {
            self.sut.valueChanged(enabled: false, at: IndexPath(row: 1, section: 0)) { _ in
                XCTAssertTrue((self.testCosmos.pushNotifications as! TestableFirebasePushNotifications).unsubscribeCalled)
                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 0.1)
    }
}
