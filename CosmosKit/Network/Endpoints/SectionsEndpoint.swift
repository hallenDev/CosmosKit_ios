import Foundation

struct SectionsEndpoint: Endpoint {
    let config: CosmosConfig
    var urlString: String

    init(config: CosmosConfig) {
        self.config = config
        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/pub/sections/get-all?publication=\(config.publication.id)"
        if let token = Keychain.getAccessTokenValue() {
            self.urlString += "&access_token=\(token)"
        }
    }
}
