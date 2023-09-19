//swiftlint:disable force_try
@testable import CosmosKit
import XCTest

class SectionViewModelTests: XCTestCase {

    func testFilterSections_valid() {

        let data = readJSONData("section5")
        let section = try! JSONDecoder().decode(Section.self, from: data)

        let sut = SectionViewModel(section: section)

        XCTAssertEqual(sut!.subSections?.count, 5)
        XCTAssertEqual(sut!.name, "NEWS")
        XCTAssertEqual(sut!.id, "news")
        XCTAssertNil(sut!.publication)
        XCTAssertNil(sut!.link)
        XCTAssertNil(sut!.articleSlug)
        XCTAssertEqual(sut!.subSections?.first?.name, "SOUTH AFRICA")
        XCTAssertEqual(sut!.subSections?.last?.name, "SCI-TECH")
    }

    func testFilterSections_valid_articleSection() {

        let data = readJSONData("section8")
        let section = try! JSONDecoder().decode(Section.self, from: data)

        let sut = SectionViewModel(section: section)

        XCTAssertTrue(sut!.isArticleSection)
        XCTAssertEqual(sut!.name, "PUZZLES")
        XCTAssertNil(sut!.id)
        XCTAssertNil(sut!.publication)
        XCTAssertEqual(sut!.link, "/sunday-times/pages/puzzles/")
        XCTAssertEqual(sut!.articleSlug, "puzzles")
        XCTAssertNil(sut!.subSections)
    }

    func testFilterSections_valid_linkSection() {

        let data = readJSONData("section6")
        let section = try! JSONDecoder().decode(Section.self, from: data)

        let sut = SectionViewModel(section: section)

        XCTAssertTrue(sut!.isLinkSection)
        XCTAssertEqual(sut!.name, "BOOKS")
        XCTAssertNil(sut!.id)
        XCTAssertNil(sut!.publication)
        XCTAssertEqual(sut!.link, "http://bookslive.co.za/")
        XCTAssertNil(sut!.articleSlug)
        XCTAssertNil(sut!.subSections)
    }

    func testFilterSections_valid_foreignPublicationSection() {

        let data = readJSONData("section7")
        let section = try! JSONDecoder().decode(Section.self, from: data)

        let sut = SectionViewModel(section: section)

        XCTAssertTrue(sut!.isForeignSection)
        XCTAssertEqual(sut!.name, "BUSINESS")
        XCTAssertEqual(sut!.id, "business")
        XCTAssertEqual(sut!.publication, "sunday-times")
        XCTAssertEqual(sut!.link, "/sunday-times/business/")
        XCTAssertNil(sut!.articleSlug)
        XCTAssertNil(sut!.subSections)
    }

    func testFilterSections_subsectionHidden() {

        let data = readJSONData("section5")
        let section = try! JSONDecoder().decode(Section.self, from: data)

        let sut = SectionViewModel(section: section)

        XCTAssertNotNil(sut)
        XCTAssertEqual(sut!.subSections!.count, 5)
    }

    func testFilterSections_noName() {

        let data = readJSONData("section4")
        let section = try! JSONDecoder().decode(Section.self, from: data)

        let sut = SectionViewModel(section: section)

        XCTAssertNil(sut)
    }
}
