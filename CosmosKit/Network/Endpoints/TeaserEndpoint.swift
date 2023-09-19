// swiftlint:disable line_length
import Foundation

struct TeaserEndpoint: Endpoint {
    var config: CosmosConfig
    var urlString: String

    init(config: CosmosConfig, section: String, subSection: String? = nil) {
        self.config = config
        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/teaser/get-all?section=\(section)&publication=\(config.publication.id)&active=1&allow_future_articles=0"
        if let subsection = subSection {
            self.urlString += "&subsection=\(subsection)"
        }
        if let token = Keychain.getAccessTokenValue() {
            self.urlString += "&access_token=\(token)"
        }
    }
}
