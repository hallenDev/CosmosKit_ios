import Foundation

public protocol AnalyticsLogable {
    func log(event: CosmosEvent)
    func log(error: NSError)
}

public protocol CosmosEvent {
    var name: String { get }
    func parameters(online: Bool, cosmos: Cosmos) -> [String: Any]
}

public enum CosmosEvents: CosmosEvent {

    case notificationOpen(slug: String, headline: String)
    case notificationFailed(articleKey: String)
    case notificationMalformed
    case error(description: String)
    case search(term: String)
    case bookmarks
    case bookmarked(slug: String)
    case bookmarkRemoved(slug: String)
    case homePage
    case section(section: String)
    case forgotPassword
    case forgotPasswordConfirm
    case signIn
    case register
    case adLoadError(articleIndex: Int, articleCount: Int)
    case article(articleKey: String)
    case edition(key: String)
    case pastEditions
    case settings
    case sections
    case authors
    case author(key: String)
    case videos
    case videoArticleOpened(key: String, title: String)
    case videoPlayed(key: String, url: String)
    case audio
    case audioArticleOpened(key: String, title: String)
    case audioPlayed(key: String, url: String)
    case comments(slug: String)

    public enum Parameters: String {
        case articleSlug = "article_slug"
        case articleHeadline = "article_headline"
        case articleKey = "article_key"
        case videoUrl = "video_url"
        case description
        case term
        case section
        case articleIndex = "article_index"
        case articleCount = "article_count"
        case editionKey = "edition_key"
        case authorKey = "author_key"
        case isOnline = "is_online"
        case isLogged = "is_logged"
        case guid
    }

    public var name: String {
        switch self {
        case .notificationOpen: return "notification_opened"
        case .notificationFailed: return "notification_failed"
        case .notificationMalformed: return "notification_malformed"
        case .error: return "Error"
        case .search: return "screen_search"
        case .bookmarks: return "screen_bookmarks"
        case .bookmarked: return "bookmark_added"
        case .bookmarkRemoved: return "bookmark_removed"
        case .homePage: return "screen_homepage"
        case .section: return "screen_section"
        case .forgotPassword: return "screen_forgot_password"
        case .forgotPasswordConfirm: return "screen_forgot_password_confirm"
        case .adLoadError: return "ad_load_error"
        case .article: return "screen_article"
        case .edition: return "screen_edition"
        case .pastEditions: return "screen_past_editions"
        case .settings: return "screen_settings"
        case .signIn: return "screen_signIn"
        case .register: return "screen_register"
        case .sections: return "screen_sections"
        case .authors: return "screen_authors"
        case .author: return "screen_author"
        case .videos: return "screen_videos"
        case .audio: return "screen_audio"
        case .videoPlayed: return "video_play"
        case .audioPlayed: return "audio_play"
        case .comments: return "screen_comments"
        case .videoArticleOpened: return "video_article_open"
        case .audioArticleOpened: return "audio_article_open"
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
    public func parameters(online: Bool, cosmos: Cosmos) -> [String: Any] {
        var params: [String: Any] = [:]
        switch self {
        case .notificationOpen(let slug, let headline):
            params = [Parameters.articleHeadline.rawValue: headline,
                    Parameters.articleSlug.rawValue: slug]
        case .videoArticleOpened(let key, let title), .audioArticleOpened(let key, let title):
            params = [Parameters.articleHeadline.rawValue: title,
                    Parameters.articleKey.rawValue: key]
        case .notificationFailed(let key), .article(let key):
            params = [Parameters.articleKey.rawValue: key]
        case .error(let description):
            params = [Parameters.description.rawValue: description]
        case .search(let term):
            params = [Parameters.term.rawValue: term]
        case .section(let section):
            params = [Parameters.section.rawValue: section]
        case .adLoadError(let index, let count):
            params = [Parameters.articleIndex.rawValue: index,
                    Parameters.articleCount.rawValue: count]
        case .edition(let key):
            params = [Parameters.editionKey.rawValue: key]
        case .author(let key):
            params = [Parameters.authorKey.rawValue: key]
        case .bookmarked(let slug), .bookmarkRemoved(let slug), .comments(let slug):
            params = [Parameters.articleSlug.rawValue: slug]
        case .videoPlayed(let key, let url), .audioPlayed(let key, let url):
            params = [Parameters.articleKey.rawValue: key,
                      Parameters.videoUrl.rawValue: url]
        default: break
        }
        params[Parameters.isOnline.rawValue] = online.description
        params[Parameters.isLogged.rawValue] = cosmos.isLoggedIn.description
        if let guid = cosmos.user?.guid {
            params[Parameters.guid.rawValue] = guid
        }
        return params
    }
}
