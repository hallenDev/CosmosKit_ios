import Foundation

class CosmosDefaults {

    private enum Keys: String {
        case lastStoredEditionKey
        case bodyFontSize
        case useStaging
        case firebaseTopics
        case subscriptions
        case guidMigration
        case pnMigration
        case forcedPNMigration
    }

    private let defaults: UserDefaults

    init(location: UserDefaults? = nil) {
        self.defaults = location ?? UserDefaults(suiteName: "Cosmos") ?? UserDefaults.standard
    }

    // MARK: GUID Migration

    func hasRunGUIDMigration() -> Bool {
        defaults.bool(forKey: Keys.guidMigration.rawValue)
    }

    func markGUIDMigrationAsDone() {
        defaults.setValue(true, forKey: Keys.guidMigration.rawValue)
    }

    // MARK: Push Notification Migration

    func hasRunPNMigration() -> Bool {
        defaults.bool(forKey: Keys.pnMigration.rawValue)
    }

    func markPNMigrationAsDone() {
        defaults.setValue(true, forKey: Keys.pnMigration.rawValue)
    }

    func hasRunForcedPNMigration() -> Bool {
        defaults.bool(forKey: Keys.forcedPNMigration.rawValue)
    }

    func markForcedPNMigrationAsDone() {
        defaults.setValue(true, forKey: Keys.forcedPNMigration.rawValue)
    }

    // MARK: Last Stored Edition

    func setLastStoredEditionKey(_ key: Int64?) {
        guard let key = key else { return }
        defaults.set(key, forKey: Keys.lastStoredEditionKey.rawValue)
    }

    func getLastStoredEditionKey() -> Int64? {
        defaults.object(forKey: Keys.lastStoredEditionKey.rawValue) as? Int64
    }

    func removeLastStoredEditionKey() {
        defaults.removeObject(forKey: Keys.lastStoredEditionKey.rawValue)
    }

    // MARK: Body font size

    func setBodyFontSize(_ size: UIFont.TextStyle) {
        defaults.set(size.rawValue, forKey: Keys.bodyFontSize.rawValue)
    }

    func getBodyFontSize() -> UIFont.TextStyle {
        guard let stored = defaults.object(forKey: Keys.bodyFontSize.rawValue) as? String else {
            return .body
        }
        return UIFont.TextStyle(rawValue: stored)
    }

    // MARK: Staging

    func enableStaging() {
        defaults.set(true, forKey: Keys.useStaging.rawValue)
    }

    func disableStaging() {
        defaults.removeObject(forKey: Keys.useStaging.rawValue)
    }

    func isStagingEnabled() -> Bool {
        defaults.bool(forKey: Keys.useStaging.rawValue)
    }

    // MARK: Firebase Push Notification Topics

    func setSubscriptions(_ subscriptions: [String: Bool]) {
        defaults.setValue(subscriptions, forKey: Keys.firebaseTopics.rawValue)
    }

    func setSubscription(_ subscription: String, value: Bool) {
        var stored = getSubscriptions()
        stored[subscription] = value
        setSubscriptions(stored)
    }

    func getSubscriptions() -> [String: Bool] {
        defaults.object(forKey: Keys.firebaseTopics.rawValue) as? [String: Bool] ?? [:]
    }

    func setSubscriptions(enabled: Bool) {
        defaults.setValue(enabled, forKey: Keys.subscriptions.rawValue)
    }

    func getSubscriptionsStatus() -> Bool {
        defaults.bool(forKey: Keys.subscriptions.rawValue)
    }
}
