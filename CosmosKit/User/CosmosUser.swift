import Foundation

public struct CosmosUser: Codable {
    public let firstname: String?
    public let lastname: String?
    public let email: String
    public let profile_complete: Bool
    // TODO - User GUID Migration: this can be required once the users have been migrated
    public let guid: String?
//    public var premium: Bool {
//        return email == "flatcircle@guerrillamail.info"
//    }

    enum CodingKeys: String, CodingKey {
        case firstname = "first_name"
        case lastname = "last_name"
        case email
        case guid
        case profile_complete
    }
}
