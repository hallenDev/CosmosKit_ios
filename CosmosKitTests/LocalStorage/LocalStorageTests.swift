//swiftlint:disable line_length
//swiftlint:disable force_try
import XCTest
@testable import CosmosKit

class LocalStorageTests: XCTestCase {

    var article = Article(title: "title",
                          sectionTitle: "sectionTitle",
                          title2: "title2",
                          title3: "title3",
                          section: Section(name: "section", id: "section"),
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
                          slug: "lsug",
                          readDuration: 1,
                          contentType: "premium",
                          shareURL: "/test",
                          access: true,
                          comments: true,
                          externalUrl: nil,
                          videoCount: 0,
                          hideInApp: false,
                          sponsor: nil,
                          marketData: nil)

    let sut = LocalStorage()

    func testPersistEdition() {

        do {
            let edition = try JSONDecoder().decode(Edition.self, from: readJSONData("Edition"))
            let saved = sut.persist(edition)
            XCTAssertTrue(saved)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testReadEdition() {

        let edition = Edition(title: "1", widgets: [], articles: [], published: 1, image: nil, key: 1234, modified: 1234)

        if sut.persist(edition) {
            let savedEdition = sut.edition(key: 1234)
            XCTAssertNotNil(savedEdition)
        } else {
            XCTFail("Couldnt save edition")
        }
    }

    func testPersistArticle() {

        do {
            let article = try JSONDecoder().decode(Article.self, from: readJSONData("Article"))
            XCTAssertTrue(sut.persist(article))
        } catch {
            XCTFail(error.localizedDescription)
        }

        XCTAssertTrue(sut.removeArticle(key: 5688160465977344))
    }

    func testRemoveArticle() {

        XCTAssertTrue(sut.persist(article))

        XCTAssertTrue(sut.removeArticle(key: 0))
        XCTAssertTrue(sut.removeArticle(key: 123))
    }

    func testRemoveEdition() {

        let edition = Edition(title: "1", widgets: [], articles: [], published: 1, image: nil, key: 1234, modified: 1234)

        XCTAssertTrue(sut.persist(edition))

        XCTAssertTrue(sut.removeEdition(key: 1234))
        XCTAssertTrue(sut.removeEdition(key: 123))
    }

    func testRemovePersistedEditions() {

        let oldEdition = Edition(title: "1", widgets: [], articles: [], published: 1, image: nil, key: 1234, modified: 1234)
        let newEdition = Edition(title: "1", widgets: [], articles: [], published: 1530707512123, image: nil, key: 12345, modified: 1530707512123)

        XCTAssertTrue(sut.persist(oldEdition))
        XCTAssertTrue(sut.persist(newEdition))

        sut.removePersistedEditions(excluding: [12345])

        XCTAssertFalse(sut.isPersisted(key: 1234))
        XCTAssertTrue(sut.isPersisted(key: 12345))

        XCTAssertTrue(sut.removeEdition(key: 12345))
    }

    func testExists() {

        let manager = FileManager.default
        var url = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
        url = url.appendingPathComponent("bookmarks")
        do {
            if manager.fileExists(atPath: url.path) {
                try manager.removeItem(atPath: url.path)
            }
        } catch {
            XCTFail(error.localizedDescription)
        }

        XCTAssertTrue(sut.persist(article))

        XCTAssertTrue(sut.exists(at: url.appendingPathComponent("0.json").path))
        XCTAssertFalse(sut.exists(at: url.appendingPathComponent("123.json").path))
    }

    func testReadArticle() {

        if sut.persist(article) {
            let savedArticle = sut.article(key: 0)
            XCTAssertNotNil(savedArticle)
        } else {
            XCTFail("Couldnt save edition")
        }
    }

    func testGetBookmarks() {

        XCTAssertTrue(sut.persist(article))

        XCTAssertEqual(sut.getBookmarks()?.count, 1)
        XCTAssertEqual(sut.getBookmarks()?.first, 0)

        XCTAssertTrue(sut.removeArticle(key: 0)) //cleanup
    }

    func testGetBookmarks_empty() {

        XCTAssertEqual(sut.getBookmarks()?.count, 0)
    }

    func testIsPersisted() {

        let edition = Edition(title: "1", widgets: [], articles: [], published: 1, image: nil, key: 1234, modified: 1530707512123)
        XCTAssertTrue(sut.persist(edition))

        XCTAssertTrue(sut.isPersisted(key: 1234))
        XCTAssertFalse(sut.isPersisted(key: 12345))
    }

    func testIsBookmark() {

        XCTAssertTrue(sut.persist(article))

        XCTAssertTrue(sut.isBookmark(key: 0))
        XCTAssertFalse(sut.isBookmark(key: 123))

        XCTAssertTrue(sut.removeArticle(key: 0)) //cleanup
    }
}
