// swiftlint:disable line_length
import Foundation

struct PastEditionsEndpoint: Endpoint {
    let config: CosmosConfig
    var urlString: String
    let limit: Int
    let page: Int

    init(config: CosmosConfig, section: String, limit: Int, page: Int) {
        self.config = config
        self.limit = limit
        self.page = page
        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/pub/articles/get-all?page=\(page)&publication=\(config.publication.id)&section=\(section)&exclude_fields=widgets,related_articles,plain_text,blur,blob_key,images&limit=\(limit)"
        if self.config.publication.isEdition {
            self.urlString += "&date_to=\(Int(Date().timeIntervalSince1970))"
        }
        if let token = Keychain.getAccessTokenValue() {
            self.urlString += "&access_token=\(token)"
        }
    }
}
