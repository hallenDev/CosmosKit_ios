@testable import CosmosKit
import FirebaseMessaging

// NOTE: commented because Firebase does not allow init override and can't create this class
//class TestableFirebaseMessaging: Messaging {
//
//    init(test: Bool) {}
//
//    var lastTopic: String = ""
//
//    var subscribeCalled = false
//    override func subscribe(toTopic topic: String, completion: ((Error?) -> Void)? = nil) {
//        lastTopic = topic
//        subscribeCalled = true
//        completion?(nil)
//    }
//
//    var unsubscribeCalled = false
//    override func unsubscribe(fromTopic topic: String, completion: ((Error?) -> Void)? = nil) {
//        lastTopic = topic
//        unsubscribeCalled = true
//        completion?(nil)
//    }
//
//    var tokenCalled = false
//    override func token(completion: @escaping (String?, Error?) -> Void) {
//        tokenCalled = true
//        completion("test", nil)
//    }
//}
