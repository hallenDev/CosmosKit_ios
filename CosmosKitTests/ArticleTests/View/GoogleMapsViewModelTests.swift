//swiftlint:disable line_length
@testable import CosmosKit
import XCTest

class GoogleMapsViewModelTests: XCTestCase {

    func testCreate() {

        let infoData = GoogleMapsWidgetData(zoom: 16, coordinates: "1234,1234", address: "234", type: "road")

        let sut = GoogleMapsViewModel(from: infoData)

        XCTAssertEqual(sut.zoom, 16)
        XCTAssertEqual(sut.coordinates, "1234,1234")
        XCTAssertEqual(sut.address, "234")
        XCTAssertEqual(sut.mapType, "road")
        XCTAssertEqual(sut.size, "\(Int(UIScreen.main.bounds.width))x180")
        XCTAssertEqual(sut.base, "https://maps.googleapis.com/maps/api/staticmap?")
        XCTAssertEqual(sut.getMapURL(key: "1234"), URL(string: "https://maps.googleapis.com/maps/api/staticmap?center=1234,1234&zoom=16&maptype=road&size=\(Int(UIScreen.main.bounds.width))x180&markers=color:red%7C1234,1234&key=1234"))
    }
}
