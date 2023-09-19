import Foundation

struct LastUpdatedEndpoint: Endpoint {
    let config: CosmosConfig
    var urlString: String

    init(config: CosmosConfig, key: Int64) {
        self.config = config
        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/article/check-status?key=\(key)"
        if let token = Keychain.getAccessTokenValue() {
            self.urlString += "&access_token=\(token)"
        }
    }
}
