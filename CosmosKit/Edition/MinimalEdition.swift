import Foundation

public struct MinimalEdition: Codable {
    public let key: Int64
    public let modified: Int64

    public var lastModified: Date {
        return Date(timeIntervalSince1970: Double(modified/1000))
    }

    enum CodingKeys: String, CodingKey {
        case key
        case modified
    }
}
