import Foundation

struct NewsletterEndpoint: Endpoint {
    let config: CosmosConfig
    var urlString: String

    init(config: CosmosConfig, token: String) {
        self.config = config
        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/newsletter/get-all?access_token=\(token)"
    }
}
