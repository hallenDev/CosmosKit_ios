import Foundation

public enum SettingsOption {
    case debugMenu
    case account
    case bookmarks
    case pushNotifications
    case manageNotifications
    case manageNewsletters
    case reviewApp
    case clearAllEditions
    case about
    case contactUs
    case aboutAndContactUs
    case termsOfService
    case privacyPolicy
    case appVersion
    case fontSettings

    var translation: String {
        switch self {
        case .debugMenu:
            return "Debug Menu 🤓"
        case .account:
            return LanguageManager.shared.translate(key: .signIn)
        case .bookmarks:
            return LanguageManager.shared.translate(key: .headingBookmarks)
        case .pushNotifications:
            return LanguageManager.shared.translate(key: .pushNotifications)
        case .manageNotifications:
            return LanguageManager.shared.translate(key: .manageNotifications)
        case .manageNewsletters:
            return LanguageManager.shared.translate(key: .manageNewsletters)
        case .reviewApp:
            return LanguageManager.shared.translate(key: .reviewApp)
        case .clearAllEditions:
            return LanguageManager.shared.translate(key: .clearAllEditions)
        case .about:
            return LanguageManager.shared.translate(key: .aboutUs)
        case .contactUs:
            return LanguageManager.shared.translate(key: .contactUs)
        case .aboutAndContactUs:
            return LanguageManager.shared.translate(key: .aboutAndContactUs)
        case .termsOfService:
            return LanguageManager.shared.translate(key: .termsOfService)
        case .privacyPolicy:
            return LanguageManager.shared.translate(key: .privacyPolicyCapitalised)
        case .appVersion:
            return LanguageManager.shared.translate(key: .appVersion)
        case .fontSettings:
            return LanguageManager.shared.translate(key: .fontSettings)
        }
    }
}
