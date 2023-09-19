//swiftlint:disable line_length
import XCTest
@testable import CosmosKit

class AttributedTextTests: XCTestCase {

    func testSetsItalic() {
        let html = "normal<em>test</em>"

        let sut = String.attributedString(html: html,
                                          font: UIFont(name: "Lato-Regular", size: 9),
                                          italicFont: "Lato-Italic")

        //for whatever reason this test fails with the default font even if the default font has been overriden
        XCTAssertEqual((sut!.attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.font] as? UIFont)?.fontName, "Lato-Regular")
        XCTAssertEqual((sut!.attributes(at: 7, effectiveRange: nil)[NSAttributedString.Key.font] as? UIFont)?.fontName, "Lato-Italic")
    }

    func testSetsBold() {
        let html = "normal<strong>test</strong>"

        let sut = String.attributedString(html: html,
                                          font: UIFont(name: "Lato-Regular", size: 9),
                                          italicFont: "Lato-Italic",
                                          boldFont: "Lato-Bold")

        //for whatever reason this test fails with the default font even if the default font has been overriden
        XCTAssertEqual((sut!.attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.font] as? UIFont)?.fontName, "Lato-Regular")
        XCTAssertEqual((sut!.attributes(at: 7, effectiveRange: nil)[NSAttributedString.Key.font] as? UIFont)?.fontName, "Lato-Bold")
    }

}
