//swiftlint:disable force_try
import XCTest
@testable import CosmosKit

class AuthorViewModelTests: XCTestCase {

    func testCreate_nil() {

        let sut = AuthorViewModel(authors: nil)

        XCTAssertNil(sut.name)
        XCTAssertNil(sut.blur)
        XCTAssertNil(sut.title)
        XCTAssertNil(sut.imageURL)
    }

    func testCreate_1_authors() {

        let sut = AuthorViewModel(authors: ["author1"])

        XCTAssertEqual(sut.name, "by author1")
        XCTAssertNil(sut.blur)
        XCTAssertNil(sut.title)
        XCTAssertNil(sut.imageURL)
    }

    func testCreate_2_authors() {

        let sut = AuthorViewModel(authors: ["author1", "author2"])

        XCTAssertEqual(sut.name, "by author1 and author2")
        XCTAssertNil(sut.blur)
        XCTAssertNil(sut.title)
        XCTAssertNil(sut.imageURL)
    }

    func testCreate_multiple_authors() {

        let sut = AuthorViewModel(authors: ["author1", "author2", "author3"])

        XCTAssertEqual(sut.name, "by author1, author2 and author3")
        XCTAssertNil(sut.blur)
        XCTAssertNil(sut.title)
        XCTAssertNil(sut.imageURL)
    }

    func testCreate_author_social() {

        let data = readJSONData("Author1")
        let info = try! JSONDecoder().decode(Author.self, from: data)

        let sut = AuthorViewModel(from: info)

        XCTAssertEqual(sut.name, "Max du Preez")
        XCTAssertEqual(sut.title, "Mede-redakteur")
        XCTAssertNotNil(sut.blur)
        XCTAssertNotNil(sut.imageURL)
        XCTAssertEqual(sut.key, 5681034041491456)
        XCTAssertEqual(sut.bio, "Max du Preez is mede-redakteur van Vrye Weekblad. Hy was stigtersredakteur van die oorspronklike Vrye Weekblad. Hy is die skrywer van 14 boeke oor Suid-Afrikaanse geskiedenis en politiek.")
        XCTAssertEqual(sut.twitter, "https://twitter.com/MaxduPreez")
        XCTAssertNil(sut.instagram)
        XCTAssertNil(sut.facebook)
        XCTAssertTrue(sut.hasSocial)
    }
    
    func testCreate_author_no_social() {

        let data = readJSONData("Author2")
        let info = try! JSONDecoder().decode(Author.self, from: data)

        let sut = AuthorViewModel(from: info)

        XCTAssertEqual(sut.name, "Melvyn Minnaar")
        XCTAssertEqual(sut.title, "Joernalis")
        XCTAssertNotNil(sut.blur)
        XCTAssertNotNil(sut.imageURL)
        XCTAssertEqual(sut.key, 4650614680190976)
        XCTAssertEqual(sut.bio, "Melvyn Minnaar skryf oor kultuur, wyn en kuns.")
        XCTAssertNil(sut.twitter)
        XCTAssertNil(sut.instagram)
        XCTAssertNil(sut.facebook)
        XCTAssertFalse(sut.hasSocial)
    }
}
