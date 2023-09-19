import Foundation

public struct PastEditionViewModel {

    let key: Int64
    let title: String
    let articleCount: String
    let publishDate: Date
    let image: ImageViewModel?
    let lastModified: Date

    var isPersisted: Bool {
        return LocalStorage().isPersisted(key: key)
    }

    init(from edition: PastEdition, theme: Theme) {
        let cleanedTitle = edition.title.replacingOccurrences(of: ", ", with: "\n")
        let cleanedArticleCount =  "\(edition.articleCount) " + LanguageManager.shared.translate(key: .articles)

        self.publishDate = edition.publishDate
        if let articleImage = edition.image {
            self.image = ImageViewModel(from: articleImage)
        } else {
            self.image = nil
        }
        if theme.editionTheme?.pastEditionTheme.uppercasePastEditionText ?? false {
            self.title = cleanedTitle.uppercased()
            self.articleCount = cleanedArticleCount.uppercased()
        } else {
            self.title = cleanedTitle
            self.articleCount = cleanedArticleCount
        }
        self.key = edition.key
        self.lastModified = edition.lastModified
    }

    init(from edition: Edition, theme: Theme) {
        let pastEdition = PastEdition(key: edition.key,
                                      title: edition.title,
                                      articleCount: edition.articles.count,
                                      published: edition.published,
                                      image: edition.image,
                                      modified: edition.modified)
        self.init(from: pastEdition, theme: theme)
    }
}
