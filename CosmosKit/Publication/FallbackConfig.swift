import Foundation

public struct FallbackConfig {

    public static let defaultFallback = Fallback(title: LanguageManager.shared.translate(key: .noResult),
                                                 body: LanguageManager.shared.translate(key: .noResultTryAgain),
                                                 image: nil)

    let noNetworkFallback: Fallback
    let apiErrorFallback: Fallback
    let articleFallback: Fallback
    let searchFallback: Fallback
    let editionFallback: Fallback
    let sectionFallback: Fallback
    let bookmarksFallback: Fallback
    let pastEditionFallback: Fallback
    let articleListFallback: Fallback
    let videoFallback: Fallback
    let authorsFallback: Fallback
    let authorFallback: Fallback

    public init(noNetworkFallback: FallbackConfigurable? = nil,
                apiErrorFallback: FallbackConfigurable? = nil,
                articleFallback: FallbackConfigurable? = nil,
                searchFallback: FallbackConfigurable? = nil,
                editionFallback: FallbackConfigurable? = nil,
                sectionFallback: FallbackConfigurable? = nil,
                bookmarksFallback: FallbackConfigurable? = nil,
                pastEditionFallback: FallbackConfigurable? = nil,
                articleListFallback: FallbackConfigurable? = nil,
                videoFallback: FallbackConfigurable? = nil,
                authorsFallback: FallbackConfigurable? = nil,
                authorFallback: FallbackConfigurable? = nil) {

        let defaultFallback = FallbackConfig.defaultFallback
        self.noNetworkFallback = noNetworkFallback?.fallback ?? defaultFallback
        self.apiErrorFallback = apiErrorFallback?.fallback ?? defaultFallback
        self.articleFallback = articleFallback?.fallback ?? defaultFallback
        self.searchFallback = searchFallback?.fallback ?? defaultFallback
        self.editionFallback = editionFallback?.fallback ?? defaultFallback
        self.sectionFallback = sectionFallback?.fallback ?? defaultFallback
        self.bookmarksFallback = bookmarksFallback?.fallback ?? defaultFallback
        self.pastEditionFallback = pastEditionFallback?.fallback ?? defaultFallback
        self.articleListFallback = articleListFallback?.fallback ?? defaultFallback
        self.videoFallback = videoFallback?.fallback ?? defaultFallback
        self.authorsFallback = authorsFallback?.fallback ?? defaultFallback
        self.authorFallback = authorFallback?.fallback ?? defaultFallback
    }
}
