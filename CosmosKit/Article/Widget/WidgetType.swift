import Foundation

public enum WidgetType: String, Codable {

    case image
    case text
    case unsupported
    case tweet
    case instagram
    case divider = "hr"
    case youtube
    case quote
    case infoblock
    case relatedArticles = "related_articles"
    case articleList = "article_list"
    case gallery
    case iframely
    case facebookPost = "facebook_post"
    case facebookVideo = "facebook_video"
    case googleMaps = "google_map"
    case jwplayer
    case html
    case accordion
    case iono
    case crossword = "crossword_html"
    case teaser
    case infogram
    case soundcloud
    case giphy
    case issuu
    case oovvuu
    case bibliodam = "bibliodam_video"
    case marketData
    case url
    case scribd
    case polldaddy

    public init(from decoder: Decoder) throws {
        let type = try decoder.singleValueContainer().decode(String.self)
        self = WidgetType(rawValue: type) ?? .unsupported
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }

    var reloadDescription: String {
        switch self {
        case .tweet:
            return LanguageManager.shared.translate(key: .widgetTwitter)
        case .instagram:
            return "Instagram"
        case .youtube:
            return "Youtube"
        case .facebookVideo, .facebookPost:
            return "Facebook"
        case .jwplayer, .bibliodam:
            return "Video"
        case .iframely, .html, .infogram, .soundcloud, .issuu, .giphy:
            return LanguageManager.shared.translate(key: .widgetWebContent)
        case .googleMaps:
            return LanguageManager.shared.translate(key: .widgetGoogleMap)
        case .iono:
            return LanguageManager.shared.translate(key: .widgetPodcast)
        case .teaser:
            return "Teaser"
        case .crossword:
            return LanguageManager.shared.translate(key: .widgetCrossword)
        default:
            return LanguageManager.shared.translate(key: .widgetContent)
        }
    }
}
