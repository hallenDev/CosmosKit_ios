// swiftlint:disable line_length
import Foundation

struct AuthorListEndpoint: Endpoint {

    var config: CosmosConfig
    var urlString: String

    init(config: CosmosConfig, page: Int) {
        self.config = config
        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/author/get-all?publication=\(config.publication.id)&page=\(page)&limit=25"
        if let token = Keychain.getAccessTokenValue() {
            self.urlString += "&access_token=\(token)"
        }
    }
}

struct AuthorArticlesEndpoint: Endpoint {

    var config: CosmosConfig
    var urlString: String

    init(config: CosmosConfig, author: Int64, page: Int) {
        self.config = config
        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/pub/articles/get-all?page=\(page)&publication=\(config.publication.id)&compute_related=1&author=\(author)"
        if self.config.publication.isEdition {
            self.urlString += "&date_to=\(Int(Date().timeIntervalSince1970))"
        }
        if let token = Keychain.getAccessTokenValue() {
            self.urlString += "&access_token=\(token)"
        }
    }
}
