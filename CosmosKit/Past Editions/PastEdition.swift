import Foundation

public struct PastEdition: Decodable {

    public let key: Int64
    public let title: String
    public var articleCount: Int
    var published: Int64
    public var image: Image?
    public let modified: Int64

    public var lastModified: Date {
        return Date(timeIntervalSince1970: Double(modified/1000))
    }

    public var publishDate: Date {
        return Date(timeIntervalSince1970: TimeInterval((published/1000) + 1))
    }

    public var isPersisted: Bool {
        return LocalStorage().isPersisted(key: key)
    }

    enum CodingKeys: String, CodingKey {
        case title = "title_text"
        case articleCount = "count_embedded_articles"
        case published
        case image
        case key
        case modified
    }
}
