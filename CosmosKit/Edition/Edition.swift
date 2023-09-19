import Foundation

public struct Edition: Codable {
    public let title: String
    public let widgets: [Widget]?
    public let articles: [Article]
    public let published: Int64
    public let image: Image?
    public let key: Int64
    public let modified: Int64

    public var lastModified: Date {
        return Date(timeIntervalSince1970: Double(modified/1000))
    }

    enum CodingKeys: String, CodingKey {
        case title = "title_text"
        case widgets
        case articles = "embedded_articles_list_compute"
        case published
        case image
        case key
        case modified
    }
}
