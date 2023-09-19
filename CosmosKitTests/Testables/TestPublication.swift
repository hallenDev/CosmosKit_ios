//swiftlint:disable identifier_name
import XCTest
@testable import CosmosKit

struct TestPublication: Publication {
    var facebookClientId: String?
    var facebookAppId: String?
    var narratiiveConfig: NarratiiveConfig
    var fallbackConfig: FallbackConfig
    var theme: Theme
    var uiConfig: CosmosUIConfig
    var loadingIndicator: LoadingIndicatorConfig?
    var editionConfig: EditionConfig?
    var authConfig: AuthConfig?
    var mapsApiKey: String
    var id: String
    var commentConfig: CommentProvider
    var settingsConfig: SettingsConfig
    var consumerKey: String
    var stagingDomain: String
    var liveDomain: String
    var name: String
    var isEdition: Bool
    var adConfig: AdConfig?

    init(authConfig: AuthConfig? = nil,
         consumerKey: String = "test",
         liveDomain: String = "test.co.za",
         stagingDomain: String = "test.co.za",
         mapsApiKey: String = "test",
         id: String = "test",
         name: String = "test",
         theme: Theme = Theme(),
         fallbackConfig: FallbackConfig = FallbackConfig(),
         uiConfig: CosmosUIConfig = CosmosUIConfig(logo: UIImage(), shouldNavHideLogo: false),
         loadingIndicator: LoadingIndicatorConfig = LoadingIndicatorConfig(lightMode: "spinner"),
         commentConfig: CommentProvider = DisqusConfig(shortname: "test", domain: "test", apiKey: "test"),
         adConfig: AdConfig = AdConfig(base: "test"),
         settingsConfig: SettingsConfig = SettingsConfig(pushNotificationConfig: PushNotificationConfig(info: "test",
                                                                                                        topics: [PushNotificationConfig.PushTopic(id: "test", name: "Test"), PushNotificationConfig.PushTopic(id: "test2", name: "Test 2")],
                                                                                                        defaultValue: false),
                                                         newslettersConfig: NewslettersConfig(info: "test")),
         isEdition: Bool = false,
         editionConfig: EditionConfig? = nil,
         narratiiveConfig: NarratiiveConfig? = nil) {

        self.consumerKey = consumerKey
        self.stagingDomain = stagingDomain
        self.liveDomain = liveDomain
        self.id = id
        self.name = name
        self.isEdition = isEdition
        self.settingsConfig = settingsConfig
        self.commentConfig = commentConfig
        self.loadingIndicator = loadingIndicator
        self.mapsApiKey = ""
        self.adConfig = adConfig
        self.authConfig = authConfig
        self.editionConfig = editionConfig
        self.theme = theme
        self.uiConfig = uiConfig
        self.fallbackConfig = fallbackConfig
        self.narratiiveConfig = narratiiveConfig ?? NarratiiveConfig(baseUrl: "http://nar.com", host: "m-test.com", hostKey: "lalala")
        facebookClientId = nil
        facebookAppId = nil
    }
}
