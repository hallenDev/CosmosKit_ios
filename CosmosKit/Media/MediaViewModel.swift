import Foundation

struct MediaViewModel: Equatable {

    enum MediaType {
        case bibliodam
        case youtube
        case iono
        case oovvuu
    }

    public static func == (lhs: MediaViewModel, rhs: MediaViewModel) -> Bool {
        lhs.articleKey == rhs.articleKey
    }

    // Shared
    let mediaType: MediaType
    let title: String
    let section: String?
    let thumbnail: String?
    let articleKey: Int64
    let published: String?

    // Bibliodam Specific
    let url: String?

    // Youtube Specific
    let id: String?
    let pid: String?

    init?(_ media: Media) {
        switch media.widgetData.type {
        case .bibliodam:
            guard let data = media.widgetData.data as? BibliodamWidgetData, data.notNil() else { return nil }
            mediaType = .bibliodam
            title = data.title ?? ""
            thumbnail = data.thumbnail
            url = data.url
            id = nil
            pid = nil
        case .youtube:
            guard let data = media.widgetData.data as? YoutubeWidgetData else { return nil }
            mediaType = .youtube
            title = data.meta.title
            thumbnail = data.meta.thumbnail
            id = data.id
            pid = data.pid
            url = data.url
        case .iono:
            guard let data = media.widgetData.data as? IonoWidgetData else { return nil }
            mediaType = .iono
            title = media.articleTitle ?? data.title ?? ""
            thumbnail = data.thumbnail
            id = nil
            pid = nil
            url = data.provider
        case .oovvuu:
            guard let data = media.widgetData.data as? OovvuuWidgetData else { return nil }
            mediaType = .oovvuu
            title = media.articleTitle ?? ""
            id = nil
            pid = nil
            url = "\(Cosmos.sharedInstance!.apiConfig.publication.liveDomain)/render-widget/videos/\(media.widgetData.id ?? "")"
            thumbnail = "https:\(data.listing?.image?.filepath ?? "")"
        default:
            print("Unsupported Video Widget")
            return nil
        }

        guard let key = Int64(media.articleKey) else { return nil }
        articleKey = key
        section = media.articleSection?.uppercased()
        if let date = media.publishedDate {
            published = CosmosTimeFormatter.timeAgo(for: date, shortened: true)
        } else {
            published = nil
        }
    }
}
