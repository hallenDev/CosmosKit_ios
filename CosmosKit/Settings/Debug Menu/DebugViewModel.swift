import Foundation

struct DebugCategory {
    let title: String
    let options: [DebugOption]
}

struct DebugOption {
    let title: String
    let accessory: UITableViewCell.AccessoryType
}

struct DebugViewModel {
    let cosmos: Cosmos
    let theme: Theme
    private let defaults: CosmosDefaults
    private var content = [DebugCategory]()

    init(cosmos: Cosmos, defaults: CosmosDefaults? = nil) {
        self.theme = cosmos.theme
        self.cosmos = cosmos
        self.defaults = defaults ?? CosmosDefaults()
        refreshContent()
    }

    mutating func refreshContent() {
        content.removeAll()
        let apiEnv = DebugCategory(title: "API Environment", options: [
            DebugOption(title: "Staging", accessory: stagingEnabled() ? .checkmark : .none),
            DebugOption(title: "Live", accessory: stagingEnabled() ? .none : .checkmark)
        ])
        content.append(apiEnv)
        let pushNotif = DebugCategory(title: "Push Notifications",
                                      options: [DebugOption(title: "Copy Firebase Token", accessory: .detailButton)])
        content.append(pushNotif)
        let features = DebugCategory(title: "Feature Flags",
                                     options: FeatureFlag.allCases.map { DebugOption(title: $0.rawValue,
                                                                                     accessory: $0.isEnabled ? .checkmark : .none)})
        content.append(features)
    }

    func sectionTitle(in section: Int) -> String {
        guard 0..<sections() ~= section else { return "" }
        return content[section].title
    }

    func getOption(at indexPath: IndexPath) -> DebugOption? {
        guard 0..<sections() ~= indexPath.section else { return nil }
        guard 0..<rows(in: indexPath.section) ~= indexPath.row else { return nil }
        return content[indexPath.section].options[indexPath.row]
    }

    func sections() -> Int {
        content.count
    }

    func rows(in section: Int) -> Int {
        guard 0..<sections() ~= section else { return 0 }
        return content[section].options.count
    }

    private func toggleFeatureFlag(at indexPath: IndexPath) {
        guard let feature = getFeatureFlag(at: indexPath) else { return }
        feature.toggle()
    }

    private func getFeatureFlag(at indexPath: IndexPath) -> FeatureFlag? {
        guard let selectedTitle = getOption(at: indexPath)?.title else { return nil }
        return FeatureFlag(rawValue: selectedTitle)
    }

    func select(_ indexPath: IndexPath) {
        guard 0..<sections() ~= indexPath.section else { return }
        guard 0..<rows(in: indexPath.section) ~= indexPath.row else { return }
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            selectStaging()
            showPopup()
        case (0, 1):
            selectLive()
            showPopup()
        case (1, 0):
            copyFirebaseToken()
        case (2, _):
            toggleFeatureFlag(at: indexPath)
            showPopup()
        default: break
        }
    }

    private func showPopup() {
        Alerter.alert(translatedMessage: "Please restart the app for the feature to fully take effect.")
    }

    private func copyFirebaseToken() {
        cosmos.pushNotifications.copyTokenToClipboard()
    }

    private func selectStaging() {
        defaults.enableStaging()
        cosmos.logout()
    }

    private func selectLive() {
        defaults.disableStaging()
        cosmos.logout()
    }

    private func stagingEnabled() -> Bool {
        defaults.isStagingEnabled()
    }
}
