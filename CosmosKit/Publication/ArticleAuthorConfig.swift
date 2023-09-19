import Foundation

public struct ArticleAuthorConfig {
    let shouldOpenAuthorPage: Bool
    let capitalizeAuthor: Bool

    public init(shouldOpenAuthorPage: Bool = false, capitalizeAuthor: Bool = false) {
        self.shouldOpenAuthorPage = shouldOpenAuthorPage
        self.capitalizeAuthor = capitalizeAuthor
    }
}
