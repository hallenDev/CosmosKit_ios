import Foundation

public struct ArticleSummary: Codable {

    let title: String?
    let titleText: String?
    let sectionTitle: String?
    let section: Section
    let subSection: Section?
    let adSections: [AdSection]?
    let synopsis: String
    var image: Image?
    let published: Int64
    let modified: Int64?
    var author: Author?
    let authors: [String]?
    let publication: ArticlePublication
    let key: Int64
    let slug: String?
    let shareURL: String?
    let access: Bool?
    let comments: Bool?
    let externalUrl: String?
    let videoCount: Int?
    let readDuration: Int?
    let contentType: String?
    let sponsor: ArticleSponsor?
    let marketData: [MarketData]?

    enum CodingKeys: String, CodingKey {
        case image
        case section
        case subSection = "subsection"
        case title
        case author
        case authors
        case titleText = "title_text"
        case sectionTitle = "title_section_text"
        case readDuration = "read_duration"
        case published
        case modified = "updated"
        case synopsis
        case key
        case publication
        case slug
        case shareURL = "pub_url"
        case comments = "comments_enabled"
        case videoCount = "count_video"
        case externalUrl = "external_url"
        case access
        case adSections = "sections"
        case contentType = "content_type"
        case sponsor
        case marketData = "companies"
    }
}
