import Foundation

struct InstagramEmbedEndpoint: Endpoint {
    var config: CosmosConfig
    var urlString: String
    let base = "https://graph.facebook.com/v9.0/instagram_oembed"

    init(config: CosmosConfig, appID: String, clientID: String, postURL: String, width: Int) {
        self.config = config
        let auth = String(format: "%@|%@", appID, clientID)
        let query = String(format: "url=%@&access_token=%@&maxwidth=%d", postURL, auth, width)
        let combined = String(format: "%@?%@", base, query)
        let encoded = combined.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? combined
        self.urlString = encoded
    }
}
