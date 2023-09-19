@testable import CosmosKit
import XCTest

class TestAnalytics: AnalyticsLogable {
    var events = [CosmosEvent]()
    var errors = [NSError]()

    func log(event: CosmosEvent) {
        events.append(event)
    }

    func log(error: NSError) {
        errors.append(error)
    }
}

class VideoCellTests: XCTestCase {

    let sut = TestableListTable().createExpandedVideoCell()
    var testCosmos: TestableCosmos!
    var publication: Publication!
    var fallbackConfig: FallbackConfig!
    var config: CosmosConfig!
    let analytics = TestAnalytics()

    override func setUp() {
        super.setUp()
        fallbackConfig = FallbackConfig(noNetworkFallback: TestFallback(),
                                        articleFallback: TestFallback(),
                                        searchFallback: TestFallback())
        publication = TestPublication(fallbackConfig: fallbackConfig)

        config = CosmosConfig(publication: publication)
        let client = TestableCosmosClient(apiConfig: config)
        testCosmos = TestableCosmos(client: client, apiConfig: config, logger: analytics)
    }

    func testCreate() {

        let exp = expectation(description: "VideoListViewModelTests")
        let json = readJSONData("BibliodamVideo")
        guard let video = try? JSONDecoder().decode(Media.self, from: json),
              let viewModel = MediaViewModel(video) else {
            XCTFail("failed to parse")
            return
        }

        sut.configure(for: viewModel, cosmos: testCosmos) { key in
            XCTAssertEqual(key, 5283960088166400)
            exp.fulfill()
        }

        sut.titleSelected()
        XCTAssertEqual(analytics.events.first?.name, "video_article_open")
        XCTAssertEqual(analytics.events.first?.parameters(online: true, cosmos: testCosmos)["article_headline"] as? String, "WATCH: Stock picks — Ferrari and cash")
        XCTAssertEqual(analytics.events.first?.parameters(online: true, cosmos: testCosmos)["article_key"] as? String, "5283960088166400")

        wait(for: [exp], timeout: 0.1)
    }

}
