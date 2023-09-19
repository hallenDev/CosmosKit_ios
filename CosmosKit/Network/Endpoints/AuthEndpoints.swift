// swiftlint:disable line_length
import Foundation

struct RequestTokenEndpoint: Endpoint {
    let config: CosmosConfig
    let urlString: String

    init(config: CosmosConfig) {
        self.config = config
        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/auth/issue-request-token?agent=\(config.publication.id)_app_ios_v1.0&consumer_key=\(config.publication.consumerKey)"
    }
}

struct AccessTokenEndpoint: Endpoint {
    let config: CosmosConfig
    let urlString: String

    init(config: CosmosConfig, username: String, password: String, requestToken: String) {
        self.config = config
        let emailParam = AccessTokenEndpoint.encodeURL(value: username, using: .urlUserAllowed)
        let pwordParam = AccessTokenEndpoint.encodeURL(value: password, using: .urlPasswordAllowed)
        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/auth/issue-access-token?username=\(emailParam)&password=\(pwordParam)&request_token=\(requestToken)"
    }
}

struct RegisterUserEndpoint: Endpoint {
    let config: CosmosConfig
    var urlString: String

    init(config: CosmosConfig, username: String) {
        self.config = config
        let emailParam = AccessTokenEndpoint.encodeURL(value: username, using: .urlUserAllowed)
        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/user/create?email=\(emailParam)&bypass_activation=true"
    }
}

struct ResetPasswordEndpoint: Endpoint {
    let config: CosmosConfig
    let urlString: String

    init(config: CosmosConfig, username: String) {
        self.config = config
        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/user/resetmail?email=\(username)"
    }
}
