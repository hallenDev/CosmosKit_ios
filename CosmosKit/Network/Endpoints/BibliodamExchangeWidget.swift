import Foundation

struct BibliodamExchangeEndpoint: Endpoint {

    var config: CosmosConfig
    var urlString: String
    let baseUrl = "https://tiso-media.imigino.com/video/1/getIOS?videoUrl="

    init(config: CosmosConfig, url: String) {
        self.config = config
        let formattedUrl = BibliodamExchangeEndpoint.encodeURL(value: url)
        self.urlString = baseUrl + formattedUrl
    }
}
