import Foundation

public struct LastUpdate: Codable {
    public let modified: Int64

    public var date: Date {
        return Date(timeIntervalSince1970: Double(modified/1000))
    }

    enum CodingKeys: String, CodingKey {
        case modified
    }
}
