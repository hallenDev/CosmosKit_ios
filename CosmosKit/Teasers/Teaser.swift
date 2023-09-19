import Foundation

public struct Teaser: WidgetData {
    let key: Int64
    let heading: String
    let subHeading: String?
    let template: String
    let readMoreUrl: String?
    let articles: [Article]

    enum CodingKeys: String, CodingKey {
        case key
        case heading
        case subHeading = "subheading"
        case template
        case readMoreUrl = "more_url"
        case articles
    }
}
