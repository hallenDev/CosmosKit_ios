import Foundation
import FirebaseMessaging

extension Notification.Name {
    public static let FCMTokenRefresh = Notification.Name("FCMToken")
}

public class FirebasePushNotifications: NSObject, MessagingDelegate {

    private let defaults: CosmosDefaults
    private let debugTopic = "debug"
    private let releaseTopic = "all"
    private let pushDecodeKey = "article_key"
    private let messaging: Messaging

    init(defaults: CosmosDefaults? = nil) {
        self.defaults = defaults ?? CosmosDefaults()
        self.messaging = Messaging.messaging()
        super.init()
        self.messaging.delegate = self
        subscribeToBaseTopic()
    }

    public func extractArticleKey(from info: [AnyHashable: Any]) -> Int64? {
        if let keyString = info[pushDecodeKey] as? String,
            let key = Int64(keyString) {
            return key
        } else {
            return nil
        }
    }

    func subscribeToBaseTopic() {
        if Environment.isDebug {
            messaging.subscribe(toTopic: debugTopic)
        } else {
            messaging.subscribe(toTopic: releaseTopic)
        }
    }

    func unsubscribeToBaseTopic() {
        if Environment.isDebug {
            messaging.unsubscribe(fromTopic: debugTopic)
        } else {
            messaging.unsubscribe(fromTopic: releaseTopic)
        }
    }

    func subscribe(to topic: String) {
        messaging.subscribe(toTopic: topic)
        defaults.setSubscription(topic, value: true)
    }

    func unsubscribe(from topic: String) {
        messaging.unsubscribe(fromTopic: topic)
        defaults.setSubscription(topic, value: false)
    }

    func unsubscribeFromAll() {
        defaults.getSubscriptions().forEach { unsubscribe(from: $0.key) }
        unsubscribeToBaseTopic()
    }

    func subscribeToAll() {
        defaults.getSubscriptions().forEach { subscribe(to: $0.key) }
        subscribeToBaseTopic()
    }

    func getSubscriptions() -> [String: Bool] {
        defaults.getSubscriptions()
    }

    func alterSubscriptions(enabled: Bool) {
        defaults.setSubscriptions(enabled: enabled)
    }

    func getLocalSubscriptionStatus() -> Bool {
        defaults.getSubscriptionsStatus()
    }

    func setupDefaultsOnFirstRun() {
        getOSSubscriptionsStatus { [weak self] isEnabled in
            self?.alterSubscriptions(enabled: isEnabled)
            self?.defaults.markPNMigrationAsDone()
        }
    }

    func getOSSubscriptionsStatus(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completion(settings.authorizationStatus == .authorized)
        }
    }

    public func registeredForNotifications(with deviceToken: Data) {
        messaging.apnsToken = deviceToken
    }

    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }
        let dataDict: [String: String] = ["token": token]
        NotificationCenter.default.post(name: .FCMTokenRefresh, object: nil, userInfo: dataDict)
    }

    func copyTokenToClipboard() {
        messaging.token { token, error in
            UIPasteboard.general.string = token ?? error?.localizedDescription ?? "NA"
        }
    }
}
