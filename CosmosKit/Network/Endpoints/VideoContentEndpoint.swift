// swiftlint:disable line_length
import Foundation

struct VideoContentEndpoint: Endpoint {
    let config: CosmosConfig
    var urlString: String

    init(config: CosmosConfig, page: Int) {
        self.config = config
        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/pub/articles/get-all?page=\(page)&publication=\(config.publication.id)&doc_types=videos"
        if let token = Keychain.getAccessTokenValue() {
            self.urlString += "&access_token=\(token)"
        }
    }
}
