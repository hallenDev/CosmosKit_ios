import Foundation

public struct AdConfig {
    var base: String
    var articleListPlacements: [AdPlacement]?
    var articlePlacements: [AdPlacement]?
    var articlePagerPlacement: AdPlacement?
    var articlePagerInitialPlacement: AdPlacement?

    public init(base: String,
                articleListPlacements: [AdPlacement]? = nil,
                articlePlacements: [AdPlacement]? = nil,
                articlePagerInitialPlacement: AdPlacement? = nil,
                articlePagerPlacement: AdPlacement? = nil) {
        self.base = base
        self.articleListPlacements = articleListPlacements
        self.articlePlacements = articlePlacements
        self.articlePagerInitialPlacement = articlePagerInitialPlacement
        self.articlePagerPlacement = articlePagerPlacement
    }
}
