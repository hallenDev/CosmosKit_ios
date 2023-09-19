import Foundation

public struct NarratiiveConfig {
    let baseUrl: String
    let host: String
    let hostKey: String

    public init(baseUrl: String, host: String, hostKey: String) {
        self.baseUrl = baseUrl
        self.host = host
        self.hostKey = hostKey
    }
}
