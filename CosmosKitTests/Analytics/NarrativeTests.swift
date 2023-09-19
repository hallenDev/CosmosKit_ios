import XCTest
@testable import CosmosKit

class NarratiiveTests: XCTestCase {

    var sut = NarratiiveLogger(config: NarratiiveConfig(baseUrl: "https://collector.effectivemeasure.net/app",
                               host: "m-test.com",
                               hostKey: "ZBoHfTTXf9jxqR7bC6lKBnxtAZ8="))
    let session = TestableURLSession()
    
    override func setUp() {
        sut.session = session
    }
    
    func testGetToken() {
        let exp = expectation(description: "Narratiive Token Request")
        let response = NarratiiveLogger.TokenResponse(token: "testToken")
        let task = TestableTask()
        task.testData = try? JSONEncoder().encode(response)
        session.testTasks = [task]
        
        sut.getToken { success in
            let request = self.session.requests.first!
            XCTAssertEqual(request.url?.absoluteString, "https://collector.effectivemeasure.net/app/tokens")
            let body = NarratiiveLogger.TokenRequestBody(host: "m-test.com", hostKey: "ZBoHfTTXf9jxqR7bC6lKBnxtAZ8=")
            let testBody = try! JSONEncoder().encode(body)
            XCTAssertEqual(request.httpBody, testBody)
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.value(forHTTPHeaderField: "User-Agent"), "Mozilla/5.0 iOS/\(UIDevice.current.systemVersion) (Mobile)")
            XCTAssertTrue(success)
            XCTAssertEqual(self.sut.currentToken, "testToken")
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func testSendEvent() {
        let exp = expectation(description: "Narratiive Send event")
        let response = NarratiiveLogger.TokenResponse(token: "newToken")
        let task = TestableTask()
        task.testData = try? JSONEncoder().encode(response)
        session.testTasks = [task]
        sut.currentToken = "oldToken"
        
        sut.sendEvent(path: "/slug/test") { success in
            let request = self.session.requests.first!
            XCTAssertEqual(request.url?.absoluteString, "https://collector.effectivemeasure.net/app/hits")
            let body = NarratiiveLogger.EventRequestBody(
                token: "oldToken",
                host: "m-test.com",
                hostKey: "ZBoHfTTXf9jxqR7bC6lKBnxtAZ8=",
                path: "/slug/test")
            let testBody = try! JSONEncoder().encode(body)
            XCTAssertEqual(request.httpBody, testBody)
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.value(forHTTPHeaderField: "User-Agent"), "Mozilla/5.0 iOS/\(UIDevice.current.systemVersion) (Mobile)")
            XCTAssertTrue(success)
            XCTAssertEqual(self.sut.currentToken, "newToken")
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.1)
    }
}
