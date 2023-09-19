import XCTest
@testable import CosmosKit

class QuoteViewModelTests: XCTestCase {

    func testCreate_Full() {

        let quoteData = QuoteWidgetData(quote: "quote", cite: "cite")

        let sut = QuoteViewModel(from: quoteData)

        XCTAssertEqual(sut.quote, "\u{201C} quote \u{201D}")
        XCTAssertEqual(sut.cite, "- cite")
    }
    
    func testCreate_WithoutCite() {

        let quoteData = QuoteWidgetData(quote: "test quote", cite: nil)

        let sut = QuoteViewModel(from: quoteData)

        XCTAssertEqual(sut.quote, "\u{201C} test quote \u{201D}")
        XCTAssertNil(sut.cite)
    }
}
