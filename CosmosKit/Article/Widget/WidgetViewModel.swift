// swiftlint:disable force_cast
import Foundation

public typealias RelatedSelectedCallback = (Int64) -> Void

public enum EditionItemType {
    case article
    case widget
}

public protocol EditionItem {
    var displayType: EditionItemType { get }
}

public protocol WidgetViewModel: EditionItem {
    var type: WidgetType { get }
    static func create(from widget: Widget) -> WidgetViewModel
}

extension WidgetViewModel {

    public var displayType: EditionItemType {
        return .widget
    }

    var isWebType: Bool {
        return type == .tweet ||
            type == .instagram ||
            type == .iframely ||
            type == .facebookPost ||
            type == .facebookVideo ||
            type == .infogram ||
            type == .soundcloud ||
            type == .giphy ||
            type == .issuu ||
            type == .marketData ||
            type == .polldaddy
    }

    var isVideoType: Bool {
        return type == .tweet ||
        type == .instagram ||
        type == .iframely ||
        type == .facebookPost ||
        type == .facebookVideo ||
        type == .youtube ||
        type == .jwplayer ||
        type == .html
    }

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    func getView(cosmos: Cosmos,
                 as renderType: ArticleRenderType,
                 relatedSelected: @escaping RelatedSelectedCallback) -> UIView {

        switch type {
        case .oovvuu:
            return ArticleWebView(self as! WebViewModel, cosmos: cosmos)
        case .text:
            return ArticleText.instanceFromNib(viewModel: self as! TextViewModel, cosmos: cosmos)
        case .image:
            return ArticleImage(self as! ImageViewModel)
        case .instagram, .iframely, .facebookPost, .facebookVideo, .infogram,
             .soundcloud, .issuu, .giphy, .tweet, .marketData, .url, .scribd, .polldaddy:
            return ArticleWebView(self as! WebViewModel, cosmos: cosmos)
        case .html:
            if let webData = self as? TextViewModel,
                let html = webData.html {
                if webData.isCrossword {
                    return ArticleCrossword(html, cosmos: cosmos)
                } else {
                    let webData = WebViewModel(html: html, url: "", type: .html)
                    return ArticleWebView(webData, cosmos: cosmos)
                }
            } else {
                return UIView()
            }
        case .crossword:
            if let webData = self as? TextViewModel,
                let html = webData.html {
                return ArticleCrossword(html, cosmos: cosmos)
            } else {
                return UIView()
            }
        case .iono:
            if let webData = self as? IonoViewModel,
                let html = webData.html,
                let provider = webData.provider {
                let viewmodel = WebViewModel(html: html, url: provider, type: .iono)
                return ArticleWebView(viewmodel, cosmos: cosmos)
            } else {
                return UIView()
            }
        case .jwplayer:
            return ArticleJWPlayer(self as! JWPlayerViewModel)
        case .youtube:
            return ArticleYoutube(self as! YoutubeViewModel)
        case .quote:
            return ArticleQuote(self as! QuoteViewModel, theme: cosmos.quoteTheme)
        case .infoblock:
            return ArticleQuote(self as! InfoBlockViewModel, theme: cosmos.quoteTheme)
        case .relatedArticles:
            let oldViewModel = self as! RelatedArticlesViewModel
            let newViewModel = RelatedArticlesViewModel(from: oldViewModel, as: renderType)
            return ArticleRelatedArticles(newViewModel,
                                          cosmos: cosmos,
                                          selected: relatedSelected)
        case .divider:
            return ArticleDivider()
        case .gallery:
            return ArticleGallery(self as! GalleryViewModel)
        case .googleMaps:
            return ArticleGoogleMaps(self as! GoogleMapsViewModel, cosmos: cosmos)
        case .teaser:
            return BasicTeaser(self as! TeaserViewModel)
        case .bibliodam:
            return ArticleBibliodam(self as! BibliodamViewModel, cosmos: cosmos)
        case .articleList:
            return ArticleListWidget(viewModel: self as! ArticleListViewModel, cosmos: cosmos, selected: relatedSelected)
        case .unsupported, .accordion:
            break
        }
        let view = UIView()
        view.backgroundColor = .red
        view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        return view
    }
}
