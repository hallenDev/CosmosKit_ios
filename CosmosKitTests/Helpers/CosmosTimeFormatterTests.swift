@testable import CosmosKit
import XCTest

class CosmosTimeFormatterTests: XCTestCase {

    func testTimeAgo_months() {

        let months = Calendar.current.date(byAdding: .month, value: -2, to: Date())!
        let month = Calendar.current.date(byAdding: .month, value: -1, to: Date())!

        XCTAssertEqual(CosmosTimeFormatter.timeAgo(for: months, shortened: false), "2 months ago")
        XCTAssertEqual(CosmosTimeFormatter.timeAgo(for: months, shortened: true), "2 months ago")
        XCTAssertEqual(CosmosTimeFormatter.timeAgo(for: month, shortened: false), "1 month ago")
        XCTAssertEqual(CosmosTimeFormatter.timeAgo(for: month, shortened: true), "1 month ago")
    }

    func testTimeAgo_days() {

        let days = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        let day = Calendar.current.date(byAdding: .day, value: -1, to: Date())!

        XCTAssertEqual(CosmosTimeFormatter.timeAgo(for: days, shortened: false), "2 days ago")
        XCTAssertEqual(CosmosTimeFormatter.timeAgo(for: days, shortened: true), "2 days ago")
        XCTAssertEqual(CosmosTimeFormatter.timeAgo(for: day, shortened: false), "1 day ago")
        XCTAssertEqual(CosmosTimeFormatter.timeAgo(for: day, shortened: true), "1 day ago")
    }

    func testTimeAgo_hours() {

        let hours = Calendar.current.date(byAdding: .hour, value: -2, to: Date())!
        let hour = Calendar.current.date(byAdding: .hour, value: -1, to: Date())!

        XCTAssertEqual(CosmosTimeFormatter.timeAgo(for: hours, shortened: false), "2 hours ago")
        XCTAssertEqual(CosmosTimeFormatter.timeAgo(for: hours, shortened: true), "2 hrs ago")
        XCTAssertEqual(CosmosTimeFormatter.timeAgo(for: hour, shortened: false), "1 hour ago")
        XCTAssertEqual(CosmosTimeFormatter.timeAgo(for: hour, shortened: true), "1 hr ago")
    }

    func testTimeAgo_minutes() {

        let minutes = Calendar.current.date(byAdding: .minute, value: -2, to: Date())!
        let minute = Calendar.current.date(byAdding: .minute, value: -1, to: Date())!

        XCTAssertEqual(CosmosTimeFormatter.timeAgo(for: minutes, shortened: false), "2 minutes ago")
        XCTAssertEqual(CosmosTimeFormatter.timeAgo(for: minutes, shortened: true), "2 mins ago")
        XCTAssertEqual(CosmosTimeFormatter.timeAgo(for: minute, shortened: false), "1 minute ago")
        XCTAssertEqual(CosmosTimeFormatter.timeAgo(for: minute, shortened: true), "1 min ago")
    }

    func testTimeAgo_seconds() {

        let seconds = Calendar.current.date(byAdding: .second, value: -2, to: Date())!
        let second = Calendar.current.date(byAdding: .second, value: -1, to: Date())!

        XCTAssertEqual(CosmosTimeFormatter.timeAgo(for: seconds, shortened: false), "2 seconds ago")
        XCTAssertEqual(CosmosTimeFormatter.timeAgo(for: seconds, shortened: true), "2 secs ago")
        XCTAssertEqual(CosmosTimeFormatter.timeAgo(for: second, shortened: false), "1 second ago")
        XCTAssertEqual(CosmosTimeFormatter.timeAgo(for: second, shortened: true), "1 sec ago")
    }

    func testTimeAgo_nil() {

        XCTAssertNil(CosmosTimeFormatter.timeAgo(for: Date(), shortened: false))
        XCTAssertNil(CosmosTimeFormatter.timeAgo(for: Date(), shortened: true))
    }
}
