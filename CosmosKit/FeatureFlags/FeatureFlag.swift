import Foundation

enum FeatureFlag: String, CaseIterable {
    case newWelcomeFlow = "New Welcome Flow 🤩"
    case managePushNotifications = "Manage Notifications Screen 📳"
    case manageNewsletters = "Manage Newsletters Screen 🗞"

    var defaultsKey: String {
        var key = "featureflag."
        switch self {
        case .newWelcomeFlow:
            key.append("newwelcomeflow")
        case .managePushNotifications:
            key.append("managepushnotifications")
        case .manageNewsletters:
            key.append("managenewsletters")
        }
        return key
    }

    var isEnabled: Bool {
        switch self {
        case .managePushNotifications: return true
        default: return UserDefaults.standard.bool(forKey: self.defaultsKey)
        }
    }

    func toggle() {
        UserDefaults.standard.setValue(!isEnabled, forKey: self.defaultsKey)
    }
}
