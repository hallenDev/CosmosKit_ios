import Foundation

struct DisqusThreadEndpoint: Endpoint {
    var config: CosmosConfig
    var urlString: String

    init(config: CosmosConfig, disqusConfig: DisqusConfig, shareUrl: String, slug: String) {
        self.config = config
        let thread = disqusConfig.domain + shareUrl
        self.urlString = "https://disqus.com/api/3.0/forums/listThreads?" +
            "api_key=\(disqusConfig.apiKey)&" +
            "thread:link=\(thread)&" +
            "forum=\(disqusConfig.shortname)&" +
        "thread:ident=\(slug)"
    }
}

struct DisqusAuthEndpoint: Endpoint {
    var config: CosmosConfig
    var urlString: String

    init(config: CosmosConfig, token: String) {
        self.config = config
        self.urlString = "\(config.publication.domain)/apiv\(config.apiVersion)/user/disqusauth?access_token=\(token)"
    }
}
