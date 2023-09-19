import XCTest
@testable import CosmosKit

class GalleryViewModelTests: XCTestCase {

    func testCreate() {
        let image = Image(filepath: "//filePath",
                          title: "title",
                          description: "description",
                          author: "author",
                          height: 100,
                          width: 200,
                          blur: "asjdhgbsghjkvsfkjgn")

        let widgetData = GalleryWidgetData(images: [image])
        let sut = GalleryViewModel(from: widgetData)

        XCTAssertEqual(sut.images.count, 1)
        XCTAssertEqual(sut.images.first?.title, "title")
        XCTAssertEqual(sut.images.first?.description, "description")
        XCTAssertEqual(sut.images.first?.author, "Image: AUTHOR")
        XCTAssertEqual(sut.images.first?.imageURL, URL(string: "https://filePath"))
        XCTAssertEqual(sut.images.first?.imageHeight, CGFloat(100))
        XCTAssertEqual(sut.images.first?.imageWidth, CGFloat(200))
        XCTAssertEqual(sut.images.first?.blur, UIImage(data: "asjdhgbsghjkvsfkjgn".data(using: .utf8)!))
    }
}
