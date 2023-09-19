import Foundation

public struct ArticleTheme: SubTheme {
    // swiftlint:disable:next line_length
    public init(dateFormat: String, footerDividerColor: UIColor, bodyFontName: String, bodyItalicFontName: String?, bodyBoldFontName: String?) {
        self.dateFormat = dateFormat
        self.footerDividerColor = footerDividerColor
        self.bodyFontName = bodyFontName
        self.bodyItalicFontName = bodyItalicFontName
        self.bodyBoldFontName = bodyBoldFontName
    }

    public let dateFormat: String
    let footerDividerColor: UIColor
    let bodyFontName: String
    let bodyItalicFontName: String?
    let bodyBoldFontName: String?

    func applyColors(parent: Theme) {
        BodyLabel.appearance().textColor = parent.textColor
        BodyText.appearance().textColor = parent.textColor
        BodyText.appearance().tintColor = parent.accentColor
        ArticleFooter.appearance().backgroundColor = parent.backgroundColor
        ArticleFooterDividerLine.appearance().backgroundColor = footerDividerColor
        ArticleText.appearance().backgroundColor = parent.backgroundColor
        ArticleImage.appearance().backgroundColor = parent.backgroundColor
        ArticleHeader.appearance().backgroundColor = parent.backgroundColor
        ArticleDivider.appearance().backgroundColor = parent.backgroundColor
        ArticleYoutube.appearance().backgroundColor = parent.backgroundColor
        ArticleBackground.appearance().backgroundColor = parent.backgroundColor
        ArticleWebView.appearance().backgroundColor = parent.backgroundColor
        CosmosBannerAd.appearance().backgroundColor = parent.backgroundColor
        CosmosNativeAd.appearance().backgroundColor = parent.backgroundColor
        ArticleWebView.appearance().isOpaque = false
        JWPlayerLabel.appearance().textColor = parent.textColor
        ArticleDividerLine.appearance().backgroundColor = footerDividerColor
    }

    func applyFonts(parent: Theme) {
        ArticleViewModel.dateFormatter.dateFormat = dateFormat
        BodyLabel.appearance().font = UIFont(name: bodyFontName, textStyle: .body)!
        ImageCaptionLabel.appearance().font = UIFont(name: bodyFontName, textStyle: .caption1)!
        ImageCaptionTitleLabel.appearance().font = UIFont(name: bodyBoldFontName ?? bodyFontName, textStyle: .caption1)!
        JWPlayerLabel.appearance().font = UIFont(name: bodyFontName, textStyle: .footnote)!
        OfflineWidgetLabel.appearance().font = UIFont(name: bodyFontName, textStyle: .body)!
    }
}

extension ArticleTheme {
    public init() {
        dateFormat = "dd MMMM YYYY"
        footerDividerColor = .lightGray
        bodyFontName = "HelveticaNeue-Light"
        bodyItalicFontName = "HelveticaNeue-Italic"
        bodyBoldFontName = "HelveticaNeue-Bold"
    }
}
