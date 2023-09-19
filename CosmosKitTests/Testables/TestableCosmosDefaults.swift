@testable import CosmosKit
import XCTest

class TestableCosmosDefaults: CosmosDefaults {

    var setLastStoredEditionKeyCalled = false
    override func setLastStoredEditionKey(_ key: Int64?) {
        setLastStoredEditionKeyCalled = true
    }

    var lastStoredEditionKey: Int64?
    var getLastStoredEditionKeyCalled = false
    override func getLastStoredEditionKey() -> Int64? {
        getLastStoredEditionKeyCalled = true
        return lastStoredEditionKey
    }

    var removeLastStoredEditionKeyCalled = false
    override func removeLastStoredEditionKey() {
        removeLastStoredEditionKeyCalled = true
    }

    var setBodyFontSizeCalled = false
    override func setBodyFontSize(_ size: UIFont.TextStyle) {
        setBodyFontSizeCalled = true
    }

    var getBodyFontSizeCalled = false
    override func getBodyFontSize() -> UIFont.TextStyle {
        getBodyFontSizeCalled = true
        return .body
    }

    var enableStagingCalled = false
    override func enableStaging() {
        enableStagingCalled = true
    }

    var disableStagingCalled = false
    override func disableStaging() {
        disableStagingCalled = true
    }

    var isStagingEnabledCalled = false
    override func isStagingEnabled() -> Bool {
        isStagingEnabledCalled = true
        return false
    }

    var setSubscriptionsCalled = false
    override func setSubscriptions(_ subscriptions: [String: Bool]) {
        setSubscriptionsCalled = true
    }

    var getSubscriptionsCalled = false
    override func getSubscriptions() -> [String: Bool] {
        getSubscriptionsCalled = true
        return ["test": true]
    }

    var getSubscriptionsStatusCalled = false
    override func getSubscriptionsStatus() -> Bool {
        getSubscriptionsStatusCalled = true
        return true
    }

    var testhasRunPNMigration = false
    var hasRunPNMigrationCalled = false
    override func hasRunPNMigration() -> Bool {
        hasRunPNMigrationCalled = true
        return testhasRunPNMigration
    }

    var testhasRunGUIDMigration = false
    var hasRunGUIDMigrationCalled = false
    override func hasRunGUIDMigration() -> Bool {
        hasRunGUIDMigrationCalled = true
        return testhasRunGUIDMigration
    }

    var markPNMigrationAsDoneCalled = false
    override func markPNMigrationAsDone() {
        markPNMigrationAsDoneCalled = true
    }

    var markGUIDMigrationAsDoneCalled = false
    override func markGUIDMigrationAsDone() {
        markGUIDMigrationAsDoneCalled = true
    }
}
