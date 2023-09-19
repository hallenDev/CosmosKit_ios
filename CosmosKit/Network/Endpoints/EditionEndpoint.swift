// swiftlint:disable line_length
import Foundation

struct EditionEndpoint: Endpoint {
    let config: CosmosConfig
    var urlString: String

    init(config: CosmosConfig, date: Date, section: String) {
        self.config = config
        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/pub/articles/get-all?limit=1&page=1&publication=\(config.publication.id)&section=\(section)&date_to=\(Int(date.timeIntervalSince1970))&compute_embedded_articles_list=1"
        if let token = Keychain.getAccessTokenValue() {
            self.urlString += "&access_token=\(token)"
        }
    }

    init(config: CosmosConfig, key: Int64) {
        self.config = config
        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/pub/articles/get?key=\(key)&publication=\(config.publication.id)&compute_embedded_articles_list=1"
        if let token = Keychain.getAccessTokenValue() {
            self.urlString += "&access_token=\(token)"
        }
    }
}

struct MinimalEditionEndpoint: Endpoint {
    let config: CosmosConfig
    var urlString: String

    init(config: CosmosConfig, date: Date, section: String) {
        self.config = config
        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/pub/articles/get-all?limit=1&page=1&publication=\(config.publication.id)&section=\(section)&date_to=\(Int(date.timeIntervalSince1970))&exclude_fields=widgets,related_articles,plain_text,blob_key,images,image,image_thumbnail"
        if let token = Keychain.getAccessTokenValue() {
            self.urlString += "&access_token=\(token)"
        }
    }
}
