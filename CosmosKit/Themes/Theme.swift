import Foundation

protocol SubTheme {
    func applyColors(parent: Theme)
    func applyFonts(parent: Theme)
}

extension SubTheme {
    func apply(_ parent: Theme) {
        applyColors(parent: parent)
        applyFonts(parent: parent)
    }
}

public enum HeaderStyle {
    case bold
    case compressed
}

public struct Theme {

    // MARK: Colors
    static let captionBlack = UIColor(color: .codGray)
    static let cellBorderGray = UIColor(color: .alto)

    // MARK: Required Sub Themes

    public let articleTheme: ArticleTheme
    public let articleHeaderTheme: ArticleHeaderTheme
    public let quoteTheme: QuoteTheme
    public let authorTheme: AuthorTheme
    public let relatedArticleTheme: RelatedArticleTheme
    public let articleListTheme: ArticleListTheme
    public let sectionsTheme: SectionsTheme
    public let viewHeaderTheme: ViewHeaderTheme
    public let searchTheme: SearchTheme
    public let settingsTheme: SettingsTheme
    public let authTheme: AuthorizationTheme
    public let legacyAuthTheme: LegacyAuthorizationTheme?
    public let navigationTheme: NavigationTheme
    public let fallbackTheme: FallbackTheme

    // MARK: Optional Sub Themes

    public let editionTheme: EditionTheme?
    public let videosTheme: VideosTheme?
    public let authorsTheme: AuthorsTheme?

    // MARK: App wide theme variables

    public let textColor: UIColor
    public let separatorColor: UIColor
    public let backgroundColor: UIColor
    public let accentColor: UIColor
    public let logo: UIImage

    public init(textColor: UIColor,
                separatorColor: UIColor,
                backgroundColor: UIColor,
                accentColor: UIColor,
                logo: UIImage,
                articleTheme: ArticleTheme,
                articleHeaderTheme: ArticleHeaderTheme,
                quoteTheme: QuoteTheme,
                authorTheme: AuthorTheme,
                relatedArticleTheme: RelatedArticleTheme,
                articleListTheme: ArticleListTheme,
                sectionsTheme: SectionsTheme,
                viewHeaderTheme: ViewHeaderTheme,
                searchTheme: SearchTheme,
                settingsTheme: SettingsTheme,
                authTheme: AuthorizationTheme,
                legacyAuthTheme: LegacyAuthorizationTheme?,
                navigationTheme: NavigationTheme,
                fallbackTheme: FallbackTheme,
                editionTheme: EditionTheme? = nil,
                videosTheme: VideosTheme? = nil,
                authorsTheme: AuthorsTheme? = nil) {
        self.textColor = textColor
        self.separatorColor = separatorColor
        self.backgroundColor = backgroundColor
        self.accentColor = accentColor
        self.logo = logo
        self.articleTheme = articleTheme
        self.articleHeaderTheme = articleHeaderTheme
        self.quoteTheme = quoteTheme
        self.authorTheme = authorTheme
        self.relatedArticleTheme = relatedArticleTheme
        self.articleListTheme = articleListTheme
        self.sectionsTheme = sectionsTheme
        self.viewHeaderTheme = viewHeaderTheme
        self.searchTheme = searchTheme
        self.settingsTheme = settingsTheme
        self.authTheme = authTheme
        self.legacyAuthTheme = legacyAuthTheme
        self.navigationTheme = navigationTheme
        self.fallbackTheme = fallbackTheme
        self.editionTheme = editionTheme
        self.videosTheme = videosTheme
        self.authorsTheme = authorsTheme
    }

    public init() {
        self.textColor = .black
        self.backgroundColor = .white
        self.accentColor = .orange
        self.separatorColor = .lightGray
        self.logo = UIImage()
        self.articleTheme = ArticleTheme()
        self.articleHeaderTheme = ArticleHeaderTheme()
        self.quoteTheme = QuoteTheme()
        self.authorTheme = AuthorTheme()
        self.relatedArticleTheme = RelatedArticleTheme()
        self.articleListTheme = ArticleListTheme()
        self.sectionsTheme = SectionsTheme()
        self.viewHeaderTheme = ViewHeaderTheme()
        self.searchTheme = SearchTheme()
        self.settingsTheme = SettingsTheme()
        self.authTheme = AuthorizationTheme()
        self.legacyAuthTheme = LegacyAuthorizationTheme()
        self.navigationTheme = NavigationTheme()
        self.fallbackTheme = FallbackTheme()
        self.editionTheme = nil
        self.videosTheme = VideosTheme()
        self.authorsTheme = AuthorsTheme()
    }

    func apply() {
        applyColors()
        applyFonts()
        articleTheme.apply(self)
        articleHeaderTheme.apply(self)
        quoteTheme.apply(self)
        authorTheme.apply(self)
        relatedArticleTheme.apply(self)
        articleListTheme.apply(self)
        sectionsTheme.apply(self)
        searchTheme.apply(self)
        viewHeaderTheme.apply(self)
        settingsTheme.apply(self)
        authTheme.apply(self)
        legacyAuthTheme?.apply(self)
        navigationTheme.apply(self)
        fallbackTheme.apply(self)
        editionTheme?.apply(self)
        videosTheme?.apply(self)
        authorsTheme?.apply(self)
    }

    fileprivate func applyColors() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = accentColor
    }

    fileprivate func applyFonts() {
        LineSpacedLabel.theme = self
    }
}
