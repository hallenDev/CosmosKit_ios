// swiftlint:disable line_length
import Foundation

struct ArticleEndpoint: Endpoint {
    var config: CosmosConfig
    var urlString: String

    init(config: CosmosConfig, slug: String) {
        self.config = config
        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/pub/articles/get?slug=\(slug)&compute_related=1"
        if let token = Keychain.getAccessTokenValue() {
            self.urlString += "&access_token=\(token)"
        }
    }

    init(config: CosmosConfig, key: Int64) {
        self.config = config
        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/pub/articles/get?key=\(key)&compute_related=1"
        if let token = Keychain.getAccessTokenValue() {
            self.urlString += "&access_token=\(token)"
        }
    }
}

struct AllArticlesEndpoint: Endpoint {
    var config: CosmosConfig
    var urlString: String

    init(config: CosmosConfig, page: Int) {
        self.config = config
        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/pub/articles/get-all?trim_featured_list=false&exclude_fields=widgets,related_articles,plain_text&page=\(page)&publication=\(config.publication.id)"
        if self.config.publication.isEdition {
            self.urlString += "&date_to=\(Int(Date().timeIntervalSince1970))"
        }
        if let token = Keychain.getAccessTokenValue() {
            self.urlString += "&access_token=\(token)"
        }
    }

    init(config: CosmosConfig, section: String, publication: String, page: Int? = nil) {
        self.config = config

        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/pub/articles/get-all?page=\(page ?? 1)&section=\(section)&publication=\(publication)&compute_related=1"
        if self.config.publication.isEdition {
            self.urlString += "&date_to=\(Int(Date().timeIntervalSince1970))"
        }
        if let token = Keychain.getAccessTokenValue() {
            self.urlString += "&access_token=\(token)"
        }
    }

    init(config: CosmosConfig, section: String, subSection: String, publication: String, page: Int? = nil) {
        self.config = config

        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/pub/articles/get-all?page=\(page ?? 1)&section=\(section)&subsection=\(subSection)&publication=\(publication)&compute_related=1"
        if self.config.publication.isEdition {
            self.urlString += "&date_to=\(Int(Date().timeIntervalSince1970))"
        }
        if let token = Keychain.getAccessTokenValue() {
            self.urlString += "&access_token=\(token)"
        }
    }
}

struct ArticleAccessEndpoint: Endpoint {
    var config: CosmosConfig
    var urlString: String

    init(config: CosmosConfig, key: Int64) {
        self.config = config
        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/pub/articles/get?key=\(key)&exclude_fields=widgets,related_articles,plain_text"
        if let token = Keychain.getAccessTokenValue() {
            self.urlString += "&access_token=\(token)"
        }
    }
}
