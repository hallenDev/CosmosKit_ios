import Foundation

struct SwitchSetting {
    let id: String
    let title: String
    let enabled: Bool
}

protocol SwitchSettingViewModel {
    var title: String { get }
    var info: String { get }
    var values: [SwitchSetting] { get set }
    var cosmos: Cosmos { get set }
    var rows: Int { get }

    func retrieveValues(completion: @escaping EmptyCallBack)
    func valueChanged(enabled: Bool, at indexPath: IndexPath, completion: @escaping BooleanCallback)
    func getValue(at indexPath: IndexPath) -> SwitchSetting?
}

extension SwitchSettingViewModel {
    var theme: Theme { cosmos.theme }
}

class PushNotificationsSettingsViewModel: SwitchSettingViewModel {
    let title: String
    let info: String
    var cosmos: Cosmos
    var values = [SwitchSetting]()
    let pushNotifications: FirebasePushNotifications
    let defaultValue: Bool
    var pushesEnabled: Bool
    private let allOn = (id: "all_on",
                         title: LanguageManager.shared.translate(key: .turnOnAlerts))

    var rows: Int {
        pushesEnabled ? values.count : (values.count == 0 ? 0 : 1)
    }

    init(cosmos: Cosmos) {
        self.cosmos = cosmos
        self.pushNotifications = cosmos.pushNotifications
        self.defaultValue = cosmos.settingsConfig.pushNotifConfig.defaultValue
        self.title = LanguageManager.shared.translateUppercased(key: .manageNotifications)
        self.info = cosmos.settingsConfig.pushNotifConfig.info
        self.pushesEnabled = cosmos.pushNotifications.getLocalSubscriptionStatus()
    }

    func getValue(at indexPath: IndexPath) -> SwitchSetting? {
        guard 0..<rows ~= indexPath.row else { return nil }
        return values[indexPath.row]
    }

    func retrieveValues(completion: @escaping EmptyCallBack) {
        let storedSubscriptions = pushNotifications.getSubscriptions()
        values.removeAll()

        for topic in cosmos.settingsConfig.pushNotifConfig.topics {
            if let storedValue = storedSubscriptions[topic.id] {
                values.append(SwitchSetting(id: topic.id, title: topic.name, enabled: storedValue))
            } else {
                values.append(SwitchSetting(id: topic.id, title: topic.name, enabled: defaultValue))
                if defaultValue { // actually subscribe as well
                    pushNotifications.subscribe(to: topic.id)
                }
            }
        }

        let local = pushNotifications.getLocalSubscriptionStatus()
        pushNotifications.getOSSubscriptionsStatus { [weak self] OSEnabled in
            guard let sself = self else {
                completion()
                return
            }

            var isAllOnEnabled: Bool
            if local {
                if OSEnabled {
                    isAllOnEnabled = true
                } else {
                    isAllOnEnabled = false
                }
            } else {
                isAllOnEnabled = false
            }

            let allOff = SwitchSetting(id: sself.allOn.id,
                                       title: sself.allOn.title,
                                       enabled: isAllOnEnabled)
            sself.values.insert(allOff, at: 0)
            sself.pushesEnabled = isAllOnEnabled
            completion()
        }
    }

    func valueChanged(enabled: Bool, at indexPath: IndexPath, completion: @escaping BooleanCallback) {
        guard let topicId = getValue(at: indexPath)?.id else { return }
        if topicId == allOn.id {
            if enabled {
                pushNotifications.getOSSubscriptionsStatus { [weak self] osAllowed in
                    self?.pushNotifications.subscribeToAll()
                    self?.pushNotifications.alterSubscriptions(enabled: true)
                    completion(true)
                    if !osAllowed {
                        self?.openSettings()
                    }
                }
            } else {
                pushNotifications.alterSubscriptions(enabled: false)
                pushNotifications.unsubscribeFromAll()
                completion(true)
            }
        } else {
            if enabled {
                pushNotifications.subscribe(to: topicId)
            } else {
                pushNotifications.unsubscribe(from: topicId)
            }
            completion(true)
        }
    }

    fileprivate func openSettings() {
        DispatchQueue.main.async {
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        }
    }
}

class NewslettersSettingsViewModel: SwitchSettingViewModel {
    let title: String
    let info: String
    var cosmos: Cosmos
    var values = [SwitchSetting]()

    var rows: Int { values.count }

    init(cosmos: Cosmos) {
        self.cosmos = cosmos
        self.title = LanguageManager.shared.translateUppercased(key: .manageNewsletters)
        self.info = cosmos.settingsConfig.newslettersConfig.info
    }

    func getValue(at indexPath: IndexPath) -> SwitchSetting? {
        guard 0..<rows ~= indexPath.row else { return nil }
        return values[indexPath.row]
    }

    func retrieveValues(completion: @escaping EmptyCallBack) {
        // TODO: API call
        // TODO: handle master off switch?
        completion()
    }

    func valueChanged(enabled: Bool, at indexPath: IndexPath, completion: @escaping BooleanCallback) {
        completion(true)
    }
}
