import Foundation

public protocol Publication {

    // MARK: keys

    var consumerKey: String { get }
    var consumerSecret: String { get }
    
    var mapsApiKey: String { get }
    var facebookClientId: String? { get }
    var facebookAppId: String? { get }

    // MARK: pub details

    var stagingDomain: String { get }
    var liveDomain: String { get }
    var id: String { get }
    var name: String { get }
    var isEdition: Bool { get }

    // MARK: configs

    var loadingIndicator: LoadingIndicatorConfig? { get }
    var authConfig: AuthConfig? { get }
    var settingsConfig: SettingsConfig { get }
    var commentConfig: CommentProvider { get }
    var adConfig: AdConfig? { get }
    var editionConfig: EditionConfig? { get }
    var fallbackConfig: FallbackConfig { get }
    var narratiiveConfig: NarratiiveConfig { get }

    // MARK: UI 

    var theme: Theme { get }
    var uiConfig: CosmosUIConfig { get }
}

extension Publication {
    var domain: String {
        if CosmosDefaults().isStagingEnabled() {
            return stagingDomain
        } else {
            return liveDomain
        }
    }
}
