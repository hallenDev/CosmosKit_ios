// •••••••••••••••••••••••••••••••••••••••••••••••••••••
// • GENERATED FILE                                    •
// •••••••••••••••••••••••••••••••••••••••••••••••••••••

// • Cosmos
import UIKit

public enum CosmosImages {

    public enum Article: String, CaseIterable {
        case articleEnd = "article-End"
        case comments
        case share
        case sponsored
    }

    public enum ArticleImage: String, CaseIterable {
        case captionClose = "caption-Close"
        case caption
        case gallery
    }

    public enum Auth: String, CaseIterable {
        case authClose = "auth-Close"
    }

    public enum Authors: String, CaseIterable {
        case facebook
        case instagram
        case twitter
    }

    public enum Bookmarks: String, CaseIterable {
        case bookmarkSelected = "bookmark-Selected"
        case bookmarkUnselected = "bookmark-Unselected"
    }

    public enum Nav: String, CaseIterable {
        case navBack = "nav-Back"
    }

    public enum PastEditions: String, CaseIterable {
        case editionMark = "edition-Mark"
        case notPersisted = "not-Persisted"
    }

    public enum Search: String, CaseIterable {
        case searchLarge = "search-Large"
        case searchSmall = "search-Small"
    }

    public enum Sections: String, CaseIterable {
        case sectionClose = "section-Close"
        case sectionOpen = "section-Open"
        case specialReportStar = "special-Report-Star"
    }

    public enum Videos: String, CaseIterable {
        case play
    }

    public enum Widgets: String, CaseIterable {
        case arrowDown = "arrow-Down"
        case arrowRight = "arrow-Right"
        case puzzle
        case refresh
        case videoPlaceholder = "video-Placeholder"
        case widgetClose = "widget-Close"
    }

    static let bundle = Bundle.cosmos
}

extension UIImage {
    public convenience init(cosmosName name: CosmosImages.Article) {
        self.init(named: name.rawValue, in: CosmosImages.bundle, compatibleWith: nil)!
    }
    public convenience init(cosmosName name: CosmosImages.ArticleImage) {
        self.init(named: name.rawValue, in: CosmosImages.bundle, compatibleWith: nil)!
    }
    public convenience init(cosmosName name: CosmosImages.Auth) {
        self.init(named: name.rawValue, in: CosmosImages.bundle, compatibleWith: nil)!
    }
    public convenience init(cosmosName name: CosmosImages.Authors) {
        self.init(named: name.rawValue, in: CosmosImages.bundle, compatibleWith: nil)!
    }
    public convenience init(cosmosName name: CosmosImages.Bookmarks) {
        self.init(named: name.rawValue, in: CosmosImages.bundle, compatibleWith: nil)!
    }
    public convenience init(cosmosName name: CosmosImages.Nav) {
        self.init(named: name.rawValue, in: CosmosImages.bundle, compatibleWith: nil)!
    }
    public convenience init(cosmosName name: CosmosImages.PastEditions) {
        self.init(named: name.rawValue, in: CosmosImages.bundle, compatibleWith: nil)!
    }
    public convenience init(cosmosName name: CosmosImages.Search) {
        self.init(named: name.rawValue, in: CosmosImages.bundle, compatibleWith: nil)!
    }
    public convenience init(cosmosName name: CosmosImages.Sections) {
        self.init(named: name.rawValue, in: CosmosImages.bundle, compatibleWith: nil)!
    }
    public convenience init(cosmosName name: CosmosImages.Videos) {
        self.init(named: name.rawValue, in: CosmosImages.bundle, compatibleWith: nil)!
    }
    public convenience init(cosmosName name: CosmosImages.Widgets) {
        self.init(named: name.rawValue, in: CosmosImages.bundle, compatibleWith: nil)!
    }
}
