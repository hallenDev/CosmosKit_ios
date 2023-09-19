import XCTest
@testable import CosmosKit

class ArticleSummaryViewModelTests: XCTestCase {
    
    func testCreateFromArticleSummary() {
        
        let article = ArticleSummary(title: "article title",
                                     titleText: nil,
                                     sectionTitle: "section title",
                                     section: Section(name: "Section", id: "section"),
                                     subSection: nil,
                                     adSections: nil,
                                     synopsis: "synopsis",
                                     image: Image(filepath: "filePath",
                                                  title: "title",
                                                  description: "description",
                                                  author: "author",
                                                  height: 100,
                                                  width: 100,
                                                  blur: nil),
                                     published: 1,
                                     modified: 2,
                                     author: nil,
                                     authors: ["Tom Test"],
                                     publication: ArticlePublication(identifier: "test"),
                                     key: 1,
                                     slug: "slug",
                                     shareURL: "test",
                                     access: true,
                                     comments: true,
                                     externalUrl: "test url",
                                     videoCount: 0,
                                     readDuration: 60,
                                     contentType: nil,
                                     sponsor: nil,
                                     marketData: nil)
        
        let sut = ArticleSummaryViewModel(from: article, as: .live)
        
        XCTAssertEqual(sut.title, "article title")
        XCTAssertEqual(sut.synopsis, "synopsis")
        XCTAssertEqual(sut.section!.name, "SECTION")
        XCTAssertEqual(sut.image?.imageURL, "https:filePath")
        XCTAssertEqual(sut.sectionTitle, "section title")
        XCTAssertEqual(sut.publication, "test")
        XCTAssertEqual(sut.renderType, .live)
        XCTAssertEqual(sut.key, 1)
        XCTAssertEqual(sut.slug, "slug")
        XCTAssertEqual(sut.publishInterval, 1)
        XCTAssertEqual(sut.shareURL, "test")
        XCTAssertTrue(sut.access)
        XCTAssertTrue(sut.commentsEnabled)
        XCTAssertEqual(sut.externalUrl, "test url")
        XCTAssertFalse(sut.hasVideoContent)
        XCTAssertEqual(sut.author?.name, "by Tom Test")
        XCTAssertEqual(sut.readingTime, "1 min read")
        XCTAssertEqual(sut.listRead, "1 MIN READ")
    }
    
    func testCreate_author() {
        
        let article = ArticleSummary(title: "article title",
                                     titleText: nil,
                                     sectionTitle: "section title",
                                     section: Section(name: "Section", id: "section"),
                                     subSection: nil,
                                     adSections: nil,
                                     synopsis: "synopsis",
                                     image: Image(filepath: "filePath",
                                                  title: "title",
                                                  description: "description",
                                                  author: "author",
                                                  height: 100,
                                                  width: 100,
                                                  blur: nil),
                                     published: 1,
                                     modified: 2,
                                     author: Author(name: "tom test",
                                                    title: "director",
                                                    image: Image(filepath: "test//",
                                                                 title: "Author image",
                                                                 description: "imggf",
                                                                 author: "tom test",
                                                                 height: 67,
                                                                 width: 67, blur: "https://blur.com")),
                                     authors: nil,
                                     publication: ArticlePublication(identifier: "test"),
                                     key: 1,
                                     slug: "slug",
                                     shareURL: "test",
                                     access: true,
                                     comments: true,
                                     externalUrl: "test url",
                                     videoCount: 0,
                                     readDuration: 60,
                                     contentType: nil,
                                     sponsor: nil,
                                     marketData: nil)
        
        let sut = ArticleSummaryViewModel(from: article, as: .live)
        
        XCTAssertEqual(sut.author?.name, "tom test")
        XCTAssertEqual(sut.author?.title, "director")
        XCTAssertNotNil(sut.author?.imageURL)
    }
    
    func testCreateFromArticleSummary_UsesTitleTextFirst() {
        
        let article = ArticleSummary(title: "article title",
                                     titleText: nil,
                                     sectionTitle: "article title text",
                                     section: Section(name: "Section", id: "section"),
                                     subSection: nil,
                                     adSections: nil,
                                     synopsis: "synopsis",
                                     image: Image(filepath: "filePath",
                                                  title: "title",
                                                  description: "description",
                                                  author: "author",
                                                  height: 100,
                                                  width: 100,
                                                  blur: nil),
                                     published: 1,
                                     modified: 2,
                                     author: nil,
                                     authors: ["Tom Test"],
                                     publication: ArticlePublication(identifier: "test"),
                                     key: 1,
                                     slug: "slug",
                                     shareURL: "test",
                                     access: true,
                                     comments: true,
                                     externalUrl: nil,
                                     videoCount: 0,
                                     readDuration: 100,
                                     contentType: nil,
                                     sponsor: nil,
                                     marketData: nil)
        
        let sut = ArticleSummaryViewModel(from: article, as: .live)
        
        XCTAssertEqual(sut.title, "article title")
        XCTAssertEqual(sut.sectionTitle, "article title text")
        XCTAssertEqual(sut.synopsis, "synopsis")
        XCTAssertEqual(sut.section!.name, "SECTION")
        XCTAssertEqual(sut.image?.imageURL, "https:filePath")
    }
    
    func testCreateFromArticleSummary_TILTForNoSection() {
        
        let article = ArticleSummary(title: "article title",
                                     titleText: nil,
                                     sectionTitle: "nil",
                                     section: Section(name: "Section", id: "section"),
                                     subSection: nil,
                                     adSections: nil,
                                     synopsis: "synopsis",
                                     image: Image(filepath: "filePath",
                                                  title: "title",
                                                  description: "description",
                                                  author: "author",
                                                  height: 100,
                                                  width: 100,
                                                  blur: nil),
                                     published: 1,
                                     modified: 2,
                                     author: nil,
                                     authors: ["Tom Test"],
                                     publication: ArticlePublication(identifier: "test"),
                                     key: 1,
                                     slug: "slug",
                                     shareURL: "test",
                                     access: true, comments: true,
                                     externalUrl: nil,
                                     videoCount: 0,
                                     readDuration: 100,
                                     contentType: nil,
                                     sponsor: nil,
                                     marketData: nil)
        
        let sut = ArticleSummaryViewModel(from: article, as: .live)
        
        XCTAssertEqual(sut.title, "article title")
        XCTAssertEqual(sut.synopsis, "synopsis")
        XCTAssertEqual(sut.section!.name, "SECTION")
        XCTAssertEqual(sut.image?.imageURL, "https:filePath")
    }
    
    func testCreate_MoreThanAMonthAgo() {
        let article = ArticleSummary(title: "",
                                     titleText: nil,
                                     sectionTitle: "nil",
                                     section: Section(name: "Section", id: "section"),
                                     subSection: nil,
                                     adSections: nil,
                                     synopsis: "",
                                     image: nil,
                                     published: Int64(Int(Date(timeIntervalSinceNow: -6194000).timeIntervalSince1970*1000)),
                                     modified: 2,
                                     author: nil,
                                     authors: ["Tom Test"],
                                     publication: ArticlePublication(identifier: "test"),
                                     key: 0,
                                     slug: "slug",
                                     shareURL: "test",
                                     access: true,
                                     comments: true,
                                     externalUrl: nil,
                                     videoCount: 0,
                                     readDuration: 100,
                                     contentType: nil,
                                     sponsor: nil,
                                     marketData: nil)
        
        let sut = ArticleSummaryViewModel(from: article, as: .live)
        
        XCTAssertEqual(sut.publishedString, "2 months ago")
    }
    
    func testCreate_LessThanAMonthAgo() {
        let article = ArticleSummary(title: "",
                                     titleText: nil,
                                     sectionTitle: "nil",
                                     section: Section(name: "Section", id: "section"),
                                     subSection: nil,
                                     adSections: nil,
                                     synopsis: "",
                                     image: nil,
                                     published: Int64(Int(Date(timeIntervalSinceNow: -518400).timeIntervalSince1970)*1000),
                                     modified: 2,
                                     author: nil,
                                     authors: ["Tom Test"],
                                     publication: ArticlePublication(identifier: "test"),
                                     key: 0,
                                     slug: "slug",
                                     shareURL: "test",
                                     access: true,
                                     comments: true,
                                     externalUrl: nil,
                                     videoCount: 0,
                                     readDuration: 100,
                                     contentType: nil,
                                     sponsor: nil,
                                     marketData: nil)
        
        let sut = ArticleSummaryViewModel(from: article, as: .live)
        
        XCTAssertEqual(sut.publishedString, "6 days ago")
    }
    
    func testCreate_editionDoesntHaveDate() {
        let article = ArticleSummary(title: "",
                                     titleText: nil,
                                     sectionTitle: "nil",
                                     section: Section(name: "Section", id: "section"),
                                     subSection: nil,
                                     adSections: nil,
                                     synopsis: "",
                                     image: nil,
                                     published: Int64(Int(Date(timeIntervalSinceNow: -518400).timeIntervalSince1970)*1000),
                                     modified: 2,
                                     author: nil,
                                     authors: ["Tom Test"],
                                     publication: ArticlePublication(identifier: "test"),
                                     key: 0,
                                     slug: "slug",
                                     shareURL: "test",
                                     access: true,
                                     comments: true,
                                     externalUrl: nil,
                                     videoCount: 0,
                                     readDuration: 100,
                                     contentType: nil,
                                     sponsor: nil,
                                     marketData: nil)
        
        let sut = ArticleSummaryViewModel(from: article, as: .edition)
        
        XCTAssertNil(sut.publishedString)
    }
    
    func testCreate_staticDoesntHaveDate() {
        let article = ArticleSummary(title: "",
                                     titleText: nil,
                                     sectionTitle: "nil",
                                     section: Section(name: "Section", id: "section"),
                                     subSection: nil,
                                     adSections: nil,
                                     synopsis: "",
                                     image: nil,
                                     published: Int64(Int(Date(timeIntervalSinceNow: -518400).timeIntervalSince1970)*1000),
                                     modified: 2,
                                     author: nil,
                                     authors: ["Tom Test"],
                                     publication: ArticlePublication(identifier: "test"),
                                     key: 0,
                                     slug: "slug",
                                     shareURL: "test",
                                     access: true,
                                     comments: true,
                                     externalUrl: nil,
                                     videoCount: 0,
                                     readDuration: 100,
                                     contentType: nil,
                                     sponsor: nil,
                                     marketData: nil)
        
        let sut = ArticleSummaryViewModel(from: article, as: .staticPage)
        
        XCTAssertNil(sut.publishedString)
    }
    
    func testSectionName_section() {
        let article = ArticleSummary(title: "",
                                     titleText: nil,
                                     sectionTitle: "nil",
                                     section: Section(name: "Section", id: "section"),
                                     subSection: nil,
                                     adSections: nil,
                                     synopsis: "",
                                     image: nil,
                                     published: Int64(Int(Date(timeIntervalSinceNow: -518400).timeIntervalSince1970)*1000),
                                     modified: 2,
                                     author: nil,
                                     authors: ["Tom Test"],
                                     publication: ArticlePublication(identifier: "test"),
                                     key: 0,
                                     slug: "slug",
                                     shareURL: "test",
                                     access: true,
                                     comments: true,
                                     externalUrl: nil,
                                     videoCount: 0,
                                     readDuration: 100,
                                     contentType: nil,
                                     sponsor: nil,
                                     marketData: nil)
        
        let sut = ArticleSummaryViewModel(from: article, as: .live)
        
        XCTAssertEqual(sut.sectionName, "SECTION")
    }
    
    func testSectionName_subsection() {
        let article = ArticleSummary(title: "",
                                     titleText: nil,
                                     sectionTitle: "nil",
                                     section: Section(name: "Section", id: "section"),
                                     subSection: Section(name: "SubSection", id: "section"),
                                     adSections: nil,
                                     synopsis: "",
                                     image: nil,
                                     published: Int64(Int(Date(timeIntervalSinceNow: -518400).timeIntervalSince1970)*1000),
                                     modified: 2,
                                     author: nil,
                                     authors: ["Tom Test"],
                                     publication: ArticlePublication(identifier: "test"),
                                     key: 0,
                                     slug: "slug",
                                     shareURL: "test",
                                     access: true,
                                     comments: true,
                                     externalUrl: nil,
                                     videoCount: 0,
                                     readDuration: 100,
                                     contentType: nil,
                                     sponsor: nil,
                                     marketData: nil)
        
        let sut = ArticleSummaryViewModel(from: article, as: .live)
        
        XCTAssertEqual(sut.sectionName, "SUBSECTION")
    }
}
