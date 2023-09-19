//swiftlint:disable function_body_length
import XCTest
@testable import CosmosKit

class ArticleListViewModelTests: XCTestCase {

    func testCreateFromArticleList() {

        let articles = [
            Article(title: "title1",
                    sectionTitle: "sectionTitle",
                    title2: "title2",
                    title3: "title3",
                    section: Section(name: "section", id: "section"),
                    subSection: nil,
                    adSections: nil,
                    published: Int64(1524488220000.0),
                    modified: 2,
                    publication: ArticlePublication(identifier: "test"),
                    authors: [],
                    author: nil,
                    intro: "intro",
                    synopsis: "synopsis",
                    headerImage: Image(filepath: "//filepath",
                                       title: "image",
                                       description: "description",
                                       author: "author",
                                       height: 100,
                                       width: 200,
                                       blur: nil),
                    widgets: [],
                    images: [],
                    key: 0,
                    slug: "test",
                    readDuration: 120,
                    contentType: "free",
                    shareURL: "/test",
                    access: true,
                    comments: true,
                    externalUrl: nil,
                    videoCount: 0,
                    hideInApp: false,
                    sponsor: nil,
                    marketData: nil),
            Article(title: "title2",
                    sectionTitle: "sectionTitle2",
                    title2: "title22",
                    title3: "title23",
                    section: Section(name: "Section", id: "section"),
                    subSection: nil,
                    adSections: nil,
                    published: Int64(1524488220000.0),
                    modified: 2,
                    publication: ArticlePublication(identifier: "test"),
                    authors: [],
                    author: nil,
                    intro: "intro",
                    synopsis: "synopsis",
                    headerImage: Image(filepath: "//filepath",
                                       title: "image",
                                       description: "description",
                                       author: "author",
                                       height: 100,
                                       width: 200,
                                       blur: nil),
                    widgets: [],
                    images: [],
                    key: 0,
                    slug: "test",
                    readDuration: 120,
                    contentType: "free",
                    shareURL: "/test",
                    access: true,
                    comments: true,
                    externalUrl: nil,
                    videoCount: 0,
                    hideInApp: false,
                    sponsor: nil,
                    marketData: nil)
        ]

        let sut = ArticleListViewModel(from: articles)

        XCTAssertEqual(sut.articles.count, 2)
    }
}
