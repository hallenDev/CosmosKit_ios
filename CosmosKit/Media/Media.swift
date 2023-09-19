import Foundation

struct VideoList: Codable {
    let videos: [Media]
}

struct AudioList: Codable {
    let audio: [Media]

    enum CodingKeys: String, CodingKey {
        case audio = "audios"
    }
}

public struct Media: Codable {
    let widgetData: Widget
    let articleKey: String
    let articleSection: String?
    let articleTitle: String?
    let published: Int64?

    var publishedDate: Date? {
        guard let date = published else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(date/1000))
    }

    enum CodingKeys: String, CodingKey {
        case widgetData = "widget_data"
        case articleKey = "article_key"
        case articleSection = "article_section"
        case articleTitle = "article_title"
        case published
    }
}
