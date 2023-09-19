import Foundation

public struct PushNotificationConfig {

    public struct PushTopic {
        public init(id: String, name: String) {
            self.id = id
            self.name = name
        }

        let id: String
        let name: String
    }

    public init(info: String, topics: [PushTopic], defaultValue: Bool = true) {
        self.info = info
        self.topics = topics
        self.defaultValue = defaultValue
    }

    let info: String
    let topics: [PushTopic]
    let defaultValue: Bool
}
