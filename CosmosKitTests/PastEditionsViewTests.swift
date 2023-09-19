//swiftlint:disable force_cast line_length
@testable import CosmosKit
import Reachability
import XCTest

class PastEditionsViewTests: XCTestCase {

    var sut: PastEditionsViewController!
    let reachability = TestableReachability(reachable: false)
    var cosmos: TestableCosmos!
    let testFallback = TestFallback()

    override func setUp() {
        super.setUp()

        let fallbackConfig = FallbackConfig(noNetworkFallback: testFallback, articleFallback: testFallback, searchFallback: testFallback)
        let editionConfig = EditionConfig(featureLastPastEdition: false, showAllPastEditions: false)
        let publication = TestPublication(liveDomain: "https://select.timeslive.co.za", id: "times-select", fallbackConfig: fallbackConfig, editionConfig: editionConfig)
        let apiConfig = CosmosConfig(publication: publication)
        cosmos = TestableCosmos(client: TestableCosmosClient(apiConfig: apiConfig), apiConfig: apiConfig)
        sut = CosmosStoryboard.loadViewController()
        sut.reachability = reachability
        sut.setupController(cosmos: cosmos, fallback: fallbackConfig.pastEditionFallback, event: CosmosEvents.pastEditions)
    }

    func testLoadApiCall_whenOffline_noViewModel() {
        
        _ = sut.view

        XCTAssertFalse(cosmos.getOfflinePastEditionsCalled)
    }

    func testLoadApiCall_whenOnline_noViewModel() {

        reachability.connection = .wifi

        _ = sut.view

        XCTAssertFalse(cosmos.getPastEditionsCalled)
    }

    func testLoadApiCall_whenOffline() {

        sut.viewModel = PastEditionsViewModel(section: "editions", cosmos: cosmos)

        _ = sut.view

        XCTAssertTrue(cosmos.getOfflinePastEditionsCalled)
    }

    func testLoadApiCall_whenOnline() {

        reachability.connection = .wifi
        sut.viewModel = PastEditionsViewModel(section: "editions", cosmos: cosmos)

        _ = sut.view

        XCTAssertTrue(cosmos.getPastEditionsCalled)
    }
}

class TestableReachability: Reachable {
    var whenReachable: Reachability.NetworkReachable?
    var whenUnreachable: Reachability.NetworkUnreachable?
    var connection: Reachability.Connection = .unavailable

    init(reachable: Bool) {
        connection = reachable ? .wifi : .unavailable
    }
}
