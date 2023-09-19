// swiftlint:disable force_cast cyclomatic_complexity
import Foundation

public struct Widget: Codable {
    public let id: String?
    public let type: WidgetType
    public let data: WidgetData?

    enum CodingKeys: CodingKey {
        case type
        case data
        case id
    }

    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.type = try container.decode(WidgetType.self, forKey: .type)
            self.id = try container.decode(String.self, forKey: .id)
            switch self.type {
            case .oovvuu:
                self.data = try container.decode(OovvuuWidgetData.self, forKey: .data)
            case .image:
                self.data = try container.decode(ImageWidgetData.self, forKey: .data)
            case .text, .html, .crossword:
                self.data = try container.decode(TextWidgetData.self, forKey: .data)
            case .tweet, .instagram, .iframely, .facebookPost, .facebookVideo, .infogram, .soundcloud, .issuu, .scribd, .polldaddy:
                self.data = try container.decode(WebWidgetData.self, forKey: .data)
            case .jwplayer:
                self.data = try container.decode(JWPlayerWidgetData.self, forKey: .data)
            case .youtube:
                self.data = try container.decode(YoutubeWidgetData.self, forKey: .data)
            case .quote:
                self.data = try container.decode(QuoteWidgetData.self, forKey: .data)
            case .infoblock:
                self.data = try container.decode(InfoBlockWidgetData.self, forKey: .data)
            case .relatedArticles:
                self.data = try container.decode(RelatedArticlesWidgetData.self, forKey: .data)
            case .articleList:
                self.data = try container.decode(ArticleListWidgetData.self, forKey: .data)
            case .gallery:
                self.data = try container.decode(GalleryWidgetData.self, forKey: .data)
            case .googleMaps:
                self.data = try container.decode(GoogleMapsWidgetData.self, forKey: .data)
            case .accordion:
                self.data = try container.decode(AccordionWidgetData.self, forKey: .data)
            case .iono:
                self.data = try container.decode(IonoWidgetData.self, forKey: .data)
            case .teaser:
                self.data = try container.decode(Teaser.self, forKey: .data)
            case .giphy:
                self.data = try container.decode(GiphyWidgetData.self, forKey: .data)
            case .bibliodam:
                self.data = try container.decode(BibliodamWidgetData.self, forKey: .data)
            case .divider, .unsupported, .marketData, .url:
                self.data = nil
            }
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type.rawValue, forKey: .type)
        switch self.type {
        case .oovvuu:
            try container.encode(data as! OovvuuWidgetData, forKey: .data)
        case .image:
            try container.encode(data as! ImageWidgetData, forKey: .data)
        case .text, .html, .crossword:
            try container.encode(data as! TextWidgetData, forKey: .data)
        case .tweet, .instagram, .iframely, .facebookPost, .facebookVideo, .infogram, .soundcloud, .issuu, .scribd, .polldaddy:
            try container.encode(data as! WebWidgetData, forKey: .data)
        case .jwplayer:
            try container.encode(data as! JWPlayerWidgetData, forKey: .data)
        case .youtube:
            try container.encode(data as! YoutubeWidgetData, forKey: .data)
        case .quote:
            try container.encode(data as! QuoteWidgetData, forKey: .data)
        case .infoblock:
            try container.encode(data as! InfoBlockWidgetData, forKey: .data)
        case .relatedArticles:
            try container.encode(data as! RelatedArticlesWidgetData, forKey: .data)
        case .articleList:
            try container.encode(data as! ArticleListWidgetData, forKey: .data)
        case .gallery:
            try container.encode(data as! GalleryWidgetData, forKey: .data)
        case .googleMaps:
            try container.encode(data as! GoogleMapsWidgetData, forKey: .data)
        case .accordion:
            try container.encode(data as! AccordionWidgetData, forKey: .data)
        case .iono:
            try container.encode(data as! IonoWidgetData, forKey: .data)
        case .teaser:
            try container.encode(data as! Teaser, forKey: .data)
        case .giphy:
            try container.encode(data as! GiphyWidgetData, forKey: .data)
        case .bibliodam:
            try container.encode(data as! BibliodamWidgetData, forKey: .data)
        case .divider, .unsupported, .marketData, .url:
            break
        }
    }

    public func getViewModel() -> WidgetViewModel? {
        switch self.type {
        case .oovvuu:
            return WebViewModel.create(from: self)
        case .image:
            return ImageViewModel.create(from: self)
        case .text, .html, .crossword:
            return TextViewModel.create(from: self)
        case .tweet, .instagram, .iframely, .facebookPost, .facebookVideo, .infogram, .soundcloud, .giphy, .issuu, .scribd, .polldaddy:
            return WebViewModel.create(from: self)
        case .jwplayer:
            return JWPlayerViewModel.create(from: self)
        case .youtube:
            return YoutubeViewModel.create(from: self)
        case .quote:
            return QuoteViewModel.create(from: self)
        case .infoblock:
            return InfoBlockViewModel.create(from: self)
        case .relatedArticles:
            return RelatedArticlesViewModel.create(from: self)
        case .gallery:
            return GalleryViewModel.create(from: self)
        case .googleMaps:
            return GoogleMapsViewModel.create(from: self)
        case .accordion:
            return AccordionViewModel.create(from: self)
        case .divider:
            return DividerViewModel()
        case .iono:
            return IonoViewModel.create(from: self)
        case .teaser:
            return TeaserViewModel.create(from: self)
        case .bibliodam:
            return BibliodamViewModel.create(from: self)
        case .articleList:
            return ArticleListViewModel.create(from: self)
        case .unsupported, .marketData, .url:
            return nil
        }
    }
}

extension Widget {
    init(_ imageData: ImageWidgetData) {
        self.type = .image
        self.data = imageData
        self.id = nil
    }

    init(_ textData: TextWidgetData) {
        self.type = .text
        self.data = textData
        self.id = nil
    }

    init(_ youtubeData: YoutubeWidgetData) {
        self.type = .youtube
        self.data = youtubeData
        self.id = nil
    }

    init(_ webData: WebWidgetData) {
        self.type = .instagram
        self.data = webData
        self.id = nil
    }

    init(_ quoteData: QuoteWidgetData) {
        self.type = .quote
        self.data = quoteData
        self.id = nil
    }

    init(_ infoBlockData: InfoBlockWidgetData) {
        self.type = .infoblock
        self.data = infoBlockData
        self.id = nil
    }

    init(_ relatedData: RelatedArticlesWidgetData) {
        self.type = .relatedArticles
        self.data = relatedData
        self.id = nil
    }

    init(_ galleryData: GalleryWidgetData) {
        self.type = .gallery
        self.data = galleryData
        self.id = nil
    }

    init(_ mapsData: GoogleMapsWidgetData) {
        self.type = .googleMaps
        self.data = mapsData
        self.id = nil
    }

    init(_ accordionData: AccordionWidgetData) {
        self.type = .accordion
        self.data = accordionData
        self.id = nil
    }

    init(_ type: WidgetType) {
        self.type = type
        self.data = nil
        self.id = nil
    }
}
