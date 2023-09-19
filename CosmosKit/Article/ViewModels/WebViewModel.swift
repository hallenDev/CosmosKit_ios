import Foundation

public struct WebViewModel: WidgetViewModel {

    public var type: WidgetType

    public static func create(from widget: Widget) -> WidgetViewModel {
        if let data = widget.data as? WebWidgetData {
            return WebViewModel(from: data, type: widget.type)
        } else if let data = widget.data as? GiphyWidgetData {
            return WebViewModel(from: data)
        } else if let data = widget.data as? OovvuuWidgetData {
            return WebViewModel(from: data, widgetId: widget.id ?? "")
        } else {
            fatalError("failed to parse data")
        }
    }

    let html: String?
    let baseURL: URL?
    var isInstagram: Bool {
        return type == .instagram || baseURL?.absoluteString.contains("www.instagr") ?? false
    }

    var isFacebookPost: Bool {
        return type == .facebookPost
    }

    var isOovvuuVideo: Bool {
        return type == .oovvuu
    }

    init(from webData: WebWidgetData, type: WidgetType) {
        self.html = webData.meta.html.replacingOccurrences(of: "src=\"//", with: "src=\"https://")
        if let url = webData.url {
            self.baseURL = URL(string: url)
        } else {
            self.baseURL = nil
        }
        self.type = type
    }

    init(html: String, url: String, type: WidgetType) {
        self.html = html.replacingOccurrences(of: "src=\"//", with: "src=\"https://")
        self.baseURL = URL(string: url)
        self.type = type
    }

    init(from giphyData: GiphyWidgetData) {
        self.type = .giphy
        self.html = nil
        self.baseURL = URL(string: giphyData.gif.embedUrl)
    }

    init(from oovvuuData: OovvuuWidgetData, widgetId: String) {
        self.type = .oovvuu
        self.html = oovvuuData.embedCode

        if let token = Keychain.getAccessTokenValue() {
            self.baseURL = URL(string: "\(Cosmos.sharedInstance!.apiConfig.publication.liveDomain)/render-widget/\(String(describing: oovvuuData.articleId!))/\(widgetId)/?access_token=\(token)")

        } else {
            self.baseURL = URL(string: "\(Cosmos.sharedInstance!.apiConfig.publication.liveDomain)/render-widget/\(String(describing: oovvuuData.articleId!))/\(widgetId)/")
        }
    }

    init(from marketData: MarketData) {
        self.type = .marketData
        self.html = nil
        let marketUrl = "https://www.profiledata.co.za/brokersites/businesslive/components/TopMarketHeader.aspx?c="
        self.baseURL = URL(string: String(format: "%@%@", marketUrl, marketData.symbol))
    }

    public init(url: URL, type: WidgetType) {
        self.html = nil
        self.baseURL = url
        self.type = type
    }
}
