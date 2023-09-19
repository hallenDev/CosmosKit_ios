import Foundation

public struct Article: Codable {
    public let title: String
    public let sectionTitle: String?
    public let title2: String?
    public let title3: String?
    public let section: Section
    public let subSection: Section?
    public let adSections: [AdSection]?
    public let published: Int64
    let modified: Int64?
    public let publication: ArticlePublication
    public let authors: [String]?
    public var author: Author?
    public let intro: String
    public let synopsis: String
    public let headerImage: Image?
    public let widgets: [Widget]?
    public let images: [Image]
    public let key: Int64
    public let slug: String
    public let readDuration: Int
    public let contentType: String
    public let shareURL: String?
    public let access: Bool?
    public let comments: Bool
    public let externalUrl: String?
    public let videoCount: Int
    public let hideInApp: Bool?
    let sponsor: ArticleSponsor?
    public var isSponsored: Bool {
        sponsor != nil
    }
    public var customAdTag: String?
    public let marketData: [MarketData]?

    public var image: Image? {
        return images.first
    }

    enum CodingKeys: String, CodingKey {
        case title = "title_text"
        case sectionTitle = "title_section_text"
        case title2
        case title3
        case published
        case modified = "updated"
        case publication
        case authors
        case author
        case intro = "intro_text"
        case synopsis
        case headerImage = "image_header"
        case widgets
        case section
        case subSection = "subsection"
        case images
        case key
        case slug
        case readDuration = "read_duration"
        case contentType = "content_type"
        case shareURL = "pub_url"
        case access
        case comments = "comments_enabled"
        case videoCount = "count_video"
        case adSections = "sections"
        case externalUrl = "external_url"
        case hideInApp = "hide_in_app"
        case sponsor
        case customAdTag = "ad_tag_custom"
        case marketData = "companies"
    }
}
