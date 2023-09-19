//swiftlint:disable force_try
@testable import CosmosKit
import XCTest

class SectionTests: XCTestCase {

    func testCreate_idSection() {

        let data = readJSONData("section1")

        let sut = try! JSONDecoder().decode(Section.self, from: data)

        XCTAssertEqual(sut.name, "Politics")
        XCTAssertEqual(sut.id, "politics")
        XCTAssertNil(sut.subSections)
        XCTAssertNil(sut.link)
        XCTAssertNil(sut.hideApp)
        XCTAssertNil(sut.articleSlug)
        XCTAssertNil(sut.sectionId)
        XCTAssertNil(sut.publicationId)
    }

    func testCreate_hidden() {

        let data = readJSONData("section2")

        let sut = try! JSONDecoder().decode(Section.self, from: data)

        XCTAssertEqual(sut.name, "ANC Conference 2017")
        XCTAssertEqual(sut.id, "anc-conference-2017")
        XCTAssertNil(sut.subSections)
        XCTAssertNil(sut.link)
        XCTAssertNil(sut.hideApp)
        XCTAssertNil(sut.articleSlug)
        XCTAssertNil(sut.sectionId)
        XCTAssertNil(sut.publicationId)
    }

    func testCreate_appHidden() {

        let data = readJSONData("section3")

        let sut = try! JSONDecoder().decode(Section.self, from: data)

        XCTAssertEqual(sut.name, "E-Edition")
        XCTAssertNil(sut.id)
        XCTAssertNil(sut.subSections)
        XCTAssertEqual(sut.link, "/e-edition/")
        XCTAssertTrue(sut.hideApp!)
        XCTAssertNil(sut.articleSlug)
        XCTAssertNil(sut.sectionId)
        XCTAssertNil(sut.publicationId)
    }

    func testCreate_valid_core_section() {

        let data = readJSONData("section5")

        let sut = try! JSONDecoder().decode(Section.self, from: data)

        XCTAssertEqual(sut.name, "News")
        XCTAssertEqual(sut.id, "news")
        XCTAssertEqual(sut.subSections!.count, 6)
        XCTAssertNil(sut.link)
        XCTAssertNil(sut.hideApp)
        XCTAssertNil(sut.articleSlug)
        XCTAssertNil(sut.sectionId)
        XCTAssertNil(sut.publicationId)
    }

    func testCreate_link_section() {

        let data = readJSONData("section6")

        let sut = try! JSONDecoder().decode(Section.self, from: data)

        XCTAssertEqual(sut.name, "Books")
        XCTAssertNil(sut.id)
        XCTAssertNil(sut.subSections)
        XCTAssertEqual(sut.link, "http://bookslive.co.za/")
        XCTAssertNil(sut.hideApp)
        XCTAssertNil(sut.articleSlug)
        XCTAssertNil(sut.sectionId)
        XCTAssertNil(sut.publicationId)
    }

    func testCreate_otherPub_section() {

        let data = readJSONData("section7")

        let sut = try! JSONDecoder().decode(Section.self, from: data)

        XCTAssertEqual(sut.name, "Business")
        XCTAssertNil(sut.id)
        XCTAssertNil(sut.subSections)
        XCTAssertEqual(sut.link, "/sunday-times/business/")
        XCTAssertNil(sut.hideApp)
        XCTAssertNil(sut.articleSlug)
        XCTAssertEqual(sut.sectionId, "business")
        XCTAssertEqual(sut.publicationId, "sunday-times")
    }

    func testCreate_article_section() {

        let data = readJSONData("section8")

        let sut = try! JSONDecoder().decode(Section.self, from: data)

        XCTAssertEqual(sut.name, "Puzzles")
        XCTAssertNil(sut.id)
        XCTAssertNil(sut.subSections)
        XCTAssertEqual(sut.link, "/sunday-times/pages/puzzles/")
        XCTAssertNil(sut.hideApp)
        XCTAssertEqual(sut.articleSlug, "puzzles")
        XCTAssertNil(sut.sectionId)
        XCTAssertNil(sut.publicationId)
    }
}
