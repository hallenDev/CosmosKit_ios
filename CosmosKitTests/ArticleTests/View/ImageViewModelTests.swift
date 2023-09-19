import XCTest
@testable import CosmosKit

class ImageViewModelTests: XCTestCase {

    func testCreate() {
        let image = Image(filepath: "//filePath",
                          title: "title",
                          description: "description",
                          author: "author",
                          height: 100,
                          width: 200,
                          blur: "asjdhgbsghjkvsfkjgn")
        let widgetData = ImageWidgetData(image: image)
        let sut = ImageViewModel(from: widgetData)

        XCTAssertEqual(sut.title, "title")
        XCTAssertEqual(sut.description, "description")
        XCTAssertEqual(sut.author, "Image: AUTHOR")
        XCTAssertEqual(sut.imageURL, URL(string: "https://filePath"))
        XCTAssertEqual(sut.imageHeight, CGFloat(100))
        XCTAssertEqual(sut.imageWidth, CGFloat(200))
        XCTAssertEqual(sut.blur, UIImage(data: "asjdhgbsghjkvsfkjgn".data(using: .utf8)!))
    }

    func testCreate_NoAuthor() {
        let image = Image(filepath: "//filePath",
                          title: "title",
                          description: "description",
                          author: "",
                          height: 100,
                          width: 200,
                          blur: nil)
        let widgetData = ImageWidgetData(image: image)
        let sut = ImageViewModel(from: widgetData)

        XCTAssertEqual(sut.title, "title")
        XCTAssertEqual(sut.description, "description")
        XCTAssertEqual(sut.author, "")
        XCTAssertEqual(sut.imageURL, URL(string: "https://filePath"))
        XCTAssertEqual(sut.imageHeight, CGFloat(100))
        XCTAssertEqual(sut.imageWidth, CGFloat(200))
    }
}
