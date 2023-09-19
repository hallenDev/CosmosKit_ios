import Foundation
@testable import CosmosKit

class TestableFirebasePushNotifications: FirebasePushNotifications {

    var testLocalSubs = true

    override func getSubscriptions() -> [String : Bool] {
        ["test": true, "test2": false]
    }

    override func getLocalSubscriptionStatus() -> Bool {
        return testLocalSubs
    }

    var unsubscribeFromAllCalled = false
    override func unsubscribeFromAll() {
        unsubscribeFromAllCalled = true
    }

    var subscribeCalled = false
    override func subscribe(to topic: String) {
        subscribeCalled = true
    }

    var unsubscribeCalled = false
    override func unsubscribe(from topic: String) {
        unsubscribeCalled = true
    }

    var getOSSubscriptionsStatusCalled = false
    var getOSSubscriptionsStatusResponse = true
    override func getOSSubscriptionsStatus(completion: @escaping (Bool) -> Void) {
        getOSSubscriptionsStatusCalled = true
        completion(getOSSubscriptionsStatusResponse)
    }
}
