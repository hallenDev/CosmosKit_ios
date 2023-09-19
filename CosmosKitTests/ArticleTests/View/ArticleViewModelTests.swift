//swiftlint:disable line_length
//swiftlint:disable function_body_length
//swiftlint:disable type_body_length
import XCTest
@testable import CosmosKit

public class ArticleViewModelTests: XCTestCase {

    static var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM YYYY - HH:mm"
        return formatter
    }()

    func testCreate() {
        let article = Article(title: "title",
                              sectionTitle: "section title",
                              title2: "title2",
                              title3: "title3",
                              section: Section(name: "Section", id: "section"),
                              subSection: nil,
                              adSections: nil,
                              published: Int64(1524488220000.0),
                              modified: 2,
                              publication: ArticlePublication(identifier: "times-live"),
                              authors: ["author1"],
                              author: Author(name: "author",
                                             title: "cat",
                                             image: Image(filepath: "//path",
                                                          title: "",
                                                          description: "",
                                                          author: "",
                                                          height: 1,
                                                          width: 1,
                                                          blur: "/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAUDBAQEAQUEBAQFBQUGBwwIBwcHBw8LCwkMEQ8SEhEPERETFhwXExQaFRERGCEYGh0dHx8fExciJCIeJBweHx4BBQUFBwYHDggIDhIUERQeHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eFR4eHh4eEv/AABEIAAsAEAMBIgACEQEDEQH/xAAVAAEBAAAAAAAAAAAAAAAAAAAGB//EACUQAAEDAgUEAwAAAAAAAAAAAAECAxEEBQAHEhMxBiGBoRZBUf/EABUBAQEAAAAAAAAAAAAAAAAAAAUE/8QAHBEAAQMFAAAAAAAAAAAAAAAAAQMhMQACEROh/9oADAMBAAIRAxEAPwBhdbcHsrrt8fS29eKFvQEogKSrsookiJI9xxgXdOo7RY8g6TqK+Wl56tqK1VAkJ0bzWkQrdUTCQIPP1AOFfUyjT5i6GIbS+85uhIjXCUqE+VE+cQrP29XWozSrLM9XOqoAyzWbEwkvLDepRjuZ/OJJPJxCkReo4jNJr26k2M4PK//Z")),
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
                              readDuration: 1,
                              contentType: "premium",
                              shareURL: "/test",
                              access: true,
                              comments: true,
                              externalUrl: "test url",
                              videoCount: 0,
                              hideInApp: false,
                              sponsor: nil,
                              marketData: nil)

        let sut = ArticleViewModel(from: article, as: .live)

        XCTAssertEqual(sut.section!.name, "SECTION")
        XCTAssertEqual(sut.title, "title")
        XCTAssertEqual(sut.overHeadTitle, "title2")
        XCTAssertEqual(sut.underHeadTitle, "title3")
        XCTAssertEqual(sut.datePublished, ArticleViewModel.dateFormatter.string(from: Date(timeIntervalSince1970: 1524488220)))
        XCTAssertEqual(sut.author?.name, "author")
        XCTAssertEqual(sut.author?.title, "cat")
        XCTAssertEqual(sut.author?.imageURL, URL(string: "https://path"))
        XCTAssertNotNil(sut.author?.blur)
        XCTAssertEqual(sut.headerImageURL, URL(string: "https://filepath"))
        XCTAssertEqual(sut.readingTime, "0 min read")
        XCTAssertTrue(sut.access)
        XCTAssertTrue(sut.commentsEnabled)
        XCTAssertFalse(sut.isBookmarked)
        XCTAssertEqual(sut.externalUrl, "test url")
    }

    func testCreate_withoutImage() {
        let article = Article(title: "title",
                              sectionTitle: "sectionTitle",
                              title2: "title2",
                              title3: "title3",
                              section: Section(name: "Section", id: "section"),
                              subSection: nil,
                              adSections: nil,
                              published: Int64(1524488220000.0),
                              modified: 2,
                              publication: ArticlePublication(identifier: "times-live"),
                              authors: ["author1"],
                              author: Author(name: "author",
                                             title: "cat",
                                             image: Image()),
                              intro: "intro",
                              synopsis: "synopsis",
                              headerImage: nil,
                              widgets: [],
                              images: [],
                              key: 0,
                              slug: "test",
                              readDuration: 1,
                              contentType: "free",
                              shareURL: "/test",
                              access: true,
                              comments: true,
                              externalUrl: nil,
                              videoCount: 0,
                              hideInApp: false,
                              sponsor: nil,
                              marketData: nil)

        let sut = ArticleViewModel(from: article, as: .live)

        XCTAssertNil(sut.headerImageURL)
    }

    func testCreate_TwoAuthors() {
        let article = Article(title: "title",
                              sectionTitle: "sectionTitle",
                              title2: "title2",
                              title3: "title3",
                              section: Section(name: "Section", id: "section"),
                              subSection: nil,
                              adSections: nil,
                              published: Int64(1524488220000.0),
                              modified: 2,
                              publication: ArticlePublication(identifier: "times-live"),
                              authors: ["author1", "author2"],
                              author: nil,
                              intro: "intro",
                              synopsis: "synopsis",
                              headerImage: Image(filepath: "/filepath",
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
                              readDuration: 1,
                              contentType: "free",
                              shareURL: "/test",
                              access: true,
                              comments: true,
                              externalUrl: nil,
                              videoCount: 0,
                              hideInApp: false,
                              sponsor: nil,
                              marketData: nil)

        let sut = ArticleViewModel(from: article, as: .live)

        XCTAssertEqual(sut.author?.name, "by author1 and author2")
    }

    func testCreate_ThreeAuthors() {
        let article = Article(title: "title",
                              sectionTitle: "sectionTitle",
                              title2: "title2",
                              title3: "title3",
                              section: Section(name: "Section", id: "section"),
                              subSection: nil,
                              adSections: nil,
                              published: Int64(1524488220000.0),
                              modified: 2,
                              publication: ArticlePublication(identifier: "times-live"),
                              authors: ["author1", "author2", "author3"],
                              author: nil,
                              intro: "intro",
                              synopsis: "synopsis",
                              headerImage: Image(filepath: "/filepath",
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
                              readDuration: 1,
                              contentType: "free",
                              shareURL: "/test",
                              access: true,
                              comments: true,
                              externalUrl: nil,
                              videoCount: 0,
                              hideInApp: false,
                              sponsor: nil,
                              marketData: nil)

        let sut = ArticleViewModel(from: article, as: .edition)

        XCTAssertEqual(sut.author?.name, "by author1, author2 and author3")
    }

    func testLoadingState_WhenInitFromSlug() {
        let sut = ArticleViewModel(key: 0, as: .live)

        XCTAssertEqual(sut.state, .loading)
    }

    func testCreateEditionArticle() {
        func testCreate() {
            let article = Article(title: "title",
                                  sectionTitle: "sectionTitle",
                                  title2: "title2",
                                  title3: "title3",
                                  section: Section(name: "Section", id: "section"),
                                  subSection: nil,
                                  adSections: nil,
                                  published: Int64(1524488220000.0),
                                  modified: 2,
                                  publication: ArticlePublication(identifier: "times-live"),
                                  authors: ["author1"],
                                  author: Author(name: "author",
                                                 title: "cat",
                                                 image: Image(filepath: "//path",
                                                              title: "",
                                                              description: "",
                                                              author: "",
                                                              height: 1,
                                                              width: 1,
                                                              blur: "/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAUDBAQEAQUEBAQFBQUGBwwIBwcHBw8LCwkMEQ8SEhEPERETFhwXExQaFRERGCEYGh0dHx8fExciJCIeJBweHx4BBQUFBwYHDggIDhIUERQeHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eFR4eHh4eEv/AABEIAAsAEAMBIgACEQEDEQH/xAAVAAEBAAAAAAAAAAAAAAAAAAAGB//EACUQAAEDAgUEAwAAAAAAAAAAAAECAxEEBQAHEhMxBiGBoRZBUf/EABUBAQEAAAAAAAAAAAAAAAAAAAUE/8QAHBEAAQMFAAAAAAAAAAAAAAAAAQMhMQACEROh/9oADAMBAAIRAxEAPwBhdbcHsrrt8fS29eKFvQEogKSrsookiJI9xxgXdOo7RY8g6TqK+Wl56tqK1VAkJ0bzWkQrdUTCQIPP1AOFfUyjT5i6GIbS+85uhIjXCUqE+VE+cQrP29XWozSrLM9XOqoAyzWbEwkvLDepRjuZ/OJJPJxCkReo4jNJr26k2M4PK//Z")),
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

            let sut = ArticleViewModel(from: article, as: .edition)

            XCTAssertEqual(sut.readingTime, "2 min read")
            XCTAssertEqual(sut.listRead, "2 MIN READ")
            XCTAssertTrue(sut.access)
            XCTAssertFalse(sut.isBookmarked)
        }
    }

    func testCreate_NoAuthors() {
        func testCreate() {
            let article = Article(title: "title",
                                  sectionTitle: "sectionTitle",
                                  title2: "title2",
                                  title3: "title3",
                                  section: Section(name: "Section", id: "section"),
                                  subSection: nil,
                                  adSections: nil,
                                  published: Int64(1524488220000.0),
                                  modified: 2,
                                  publication: ArticlePublication(identifier: "times-live"),
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

            let sut = ArticleViewModel(from: article, as: .edition)

            XCTAssertEqual(sut.author?.name, "")
        }
    }

    func testCreate_EditionDateNoTime() {
        let article = Article(title: "title",
                              sectionTitle: "sectionTitle",
                              title2: "title2",
                              title3: "title3",
                              section: Section(name: "Section", id: "section"),
                              subSection: nil,
                              adSections: nil,
                              published: Int64(1524488220000.0),
                              modified: 2,
                              publication: ArticlePublication(identifier: "times-live"),
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

        let sut = ArticleViewModel(from: article, as: .edition)

        XCTAssertEqual(sut.datePublished, "23 April 2018")
    }

    func testCreate_StaticPage() {
        let article = Article(title: "title",
                              sectionTitle: "sectionTitle",
                              title2: "title2",
                              title3: "title3",
                              section: Section(name: "Section", id: "section"),
                              subSection: nil,
                              adSections: nil,
                              published: Int64(1524488220000.0),
                              modified: 2,
                              publication: ArticlePublication(identifier: "times-live"),
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

        let sut = ArticleViewModel(from: article, as: .staticPage)

        XCTAssertNil(sut.datePublished)
        XCTAssertNil(sut.section)
        XCTAssertNil(sut.author)
        XCTAssertNil(sut.readingTime)
        XCTAssertNil(sut.listRead)
    }

    func testSection_section() {
        let article = Article(title: "title",
                              sectionTitle: "sectionTitle",
                              title2: "title2",
                              title3: "title3",
                              section: Section(name: "Section", id: "section"),
                              subSection: nil,
                              adSections: nil,
                              published: Int64(1524488220000.0),
                              modified: 2,
                              publication: ArticlePublication(identifier: "times-live"),
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

        let sut = ArticleViewModel(from: article, as: .live)

        XCTAssertEqual(sut.sectionName, "SECTION")
    }

    func testSection_subSection() {
        let article = Article(title: "title",
                              sectionTitle: "sectionTitle",
                              title2: "title2",
                              title3: "title3",
                              section: Section(name: "Section", id: "section"),
                              subSection: Section(name: "Subsection", id: "Subsection"),
                              adSections: nil,
                              published: Int64(1524488220000.0),
                              modified: 2,
                              publication: ArticlePublication(identifier: "times-live"),
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

        let sut = ArticleViewModel(from: article, as: .live)

        XCTAssertEqual(sut.sectionName, "SUBSECTION")
    }
}
