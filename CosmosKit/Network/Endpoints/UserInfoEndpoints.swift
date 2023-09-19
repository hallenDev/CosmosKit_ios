import Foundation

struct UserInfoEndpoint: Endpoint {
    let config: CosmosConfig
    let urlString: String

    init(config: CosmosConfig, accessToken: String) {
        self.config = config
        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/user/me?access_token=\(accessToken)"
    }
}

struct UpdateUserProfileEndpoint: Endpoint {
    let config: CosmosConfig
    let urlString: String

    init(config: CosmosConfig, accessToken: String) {
        self.config = config
        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/user/update-profile?access_token=\(accessToken)"
    }
}

struct UpdateUserEndpoint: Endpoint {
    let config: CosmosConfig
    let urlString: String

    init(config: CosmosConfig, accessToken: String) {
        self.config = config
        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/user/update?access_token=\(accessToken)"
    }
}

struct DeleteUserEndpoint: Endpoint {
    let config: CosmosConfig
    let urlString: String

    init(config: CosmosConfig, accessToken: String) {
        self.config = config
        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/user/deactivate?access_token=\(accessToken)"
    }
}
