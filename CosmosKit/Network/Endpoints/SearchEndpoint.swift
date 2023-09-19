// swiftlint:disable line_length
import Foundation

struct SearchEndpoint: Endpoint {
    var config: CosmosConfig
    var urlString: String

    init(config: CosmosConfig, searchTerm: String, page: Int? = nil) {
        self.config = config
        let term = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/pub/articles/get-all?page=\(page ?? 1)&query=\(term)&limit=10&compute_related=1"
        if self.config.publication.isEdition {
            self.urlString += "&date_to=\(Int(Date().timeIntervalSince1970))"
        }
        if let token = Keychain.getAccessTokenValue() {
            self.urlString += "&access_token=\(token)"
        }
    }
}
