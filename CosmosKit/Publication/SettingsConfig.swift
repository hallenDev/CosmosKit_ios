import Foundation

public struct SettingsConfig {
    let aboutUsSlug: String
    let contactUsSlug: String
    let termsSlug: String
    let privacySlug: String
    let aboutAndContactUsSlug: String
    let accountContent: [SettingsOption]
    var generalContent: [SettingsOption]
    let aboutContent: [SettingsOption]
    let pushNotifConfig: PushNotificationConfig
    let newslettersConfig: NewslettersConfig

    public init(aboutUsSlug: String = "about-us",
                contactUsSlug: String = "contact-us",
                termsSlug: String = "terms",
                privacySlug: String = "privacy-policy",
                aboutAndContactUsSlug: String = "about-us",
                accountContent: [SettingsOption]? = nil,
                generalContent: [SettingsOption]? = nil,
                aboutContent: [SettingsOption]? = nil,
                pushNotificationConfig: PushNotificationConfig,
                newslettersConfig: NewslettersConfig) {
        self.aboutUsSlug = aboutUsSlug
        self.contactUsSlug = contactUsSlug
        self.termsSlug = termsSlug
        self.privacySlug = privacySlug
        self.aboutAndContactUsSlug = aboutAndContactUsSlug
        self.accountContent = accountContent ?? [.account]
        self.generalContent = generalContent ?? [.pushNotifications, .fontSettings, .reviewApp]
        if FeatureFlag.managePushNotifications.isEnabled {
            self.generalContent.removeAll { $0 == .pushNotifications }
            self.generalContent.insert(.manageNotifications, at: 0)
        }
        if FeatureFlag.manageNewsletters.isEnabled {
            self.generalContent.insert(.manageNewsletters, at: 1)
        }
        self.aboutContent = aboutContent ?? [.about, .contactUs, .termsOfService, .privacyPolicy, .appVersion]
        self.pushNotifConfig = pushNotificationConfig
        self.newslettersConfig = newslettersConfig
    }
}
