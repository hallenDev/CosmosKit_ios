import Foundation

public protocol WidgetData: Codable {}

public struct ImageWidgetData: WidgetData {
    let image: Image
}

public struct GalleryWidgetData: WidgetData {
    let images: [Image]
}

public struct IonoWidgetData: WidgetData {
    public let html: String?
    public let provider: String?
    public let title: String?
    public let thumbnail: String?
    public let height: Int

    enum CodingKeys: String, CodingKey {
        case html
        case provider = "provider_url"
        case title
        case thumbnail = "thumbnail_url"
        case height
    }
}

public struct TextWidgetData: WidgetData {
    let html: String?
    let text: String?
}

struct CosmosImage: Codable {
    let filepath: String?
}

struct CosmosVideoListing: Codable {
    let aggregate: Bool?
    let image: CosmosImage?
    let title: String?
    let description: String?
    let author: String?
}

public struct OovvuuWidgetData: WidgetData {
    let embedCode: String?
    let articleId: Int64?
    let listing: CosmosVideoListing?
}

public struct WebWidgetData: WidgetData {
    let meta: WebViewWidgetMetaData
    let url: String?
}

public struct WebViewWidgetMetaData: WidgetData {
    let html: String
}

public struct JWPlayerMetaData: WidgetData {
    let html: String
    let description: String?
}

public struct JWPlayerWidgetData: WidgetData {
    let meta: JWPlayerMetaData
    let url: String
    let id: String
}

public struct YoutubeWidgetData: WidgetData {
    let id: String?
    let pid: String?
    let meta: YoutubeMetaData
    let url: String?
}

public struct YoutubeMetaData: Codable {
    let title: String
    let thumbnail: String
}

public struct QuoteWidgetData: WidgetData {
    let quote: String
    let cite: String?
}

public struct InfoBlockWidgetData: WidgetData {
    let title: String?
    let description: String?
}

public struct RelatedArticlesWidgetData: WidgetData {
    let articles: [ArticleSummary]?
    let meta: RelatedArticlesMetaData
}

public struct RelatedArticlesMetaData: Codable {
    let title: String
}

public struct GoogleMapsWidgetData: WidgetData {
    let zoom: Int
    let coordinates: String
    let address: String
    let type: String
}

public struct ArticleListWidgetData: WidgetData {
    let articleIds: [Int64]
    let articles: [ArticleSummary]?
    let heading: String?
    let subHeading: String?
    let readMore: String?

    enum CodingKeys: String, CodingKey {
        case articleIds = "article_ids"
        case articles
        case heading
        case subHeading = "sub_heading"
        case readMore = "read_more_link"
    }
}

public struct AccordionWidgetData: WidgetData {
    let accordions: [AccordionData]
    let title: String

    enum CodingKeys: String, CodingKey {
        case accordions = "accordions"
        case title = "widgetTitle"
    }
}

struct AccordionData: Codable {
    let text: String
    let title: String
}

struct GiphyWidgetMetaData: WidgetData {
    let embedUrl: String

    enum CodingKeys: String, CodingKey {
        case embedUrl = "embed_url"
    }
}

struct GiphyWidgetData: WidgetData {
    let gif: GiphyWidgetMetaData
}

public struct BibliodamWidgetData: WidgetData {
    let url: String?
    let thumbnail: String?
    let title: String?

    func notNil() -> Bool {
        url != nil && thumbnail != nil && title != nil
    }
}
