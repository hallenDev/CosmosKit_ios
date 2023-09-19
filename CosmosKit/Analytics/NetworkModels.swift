import Foundation

struct TokenRequestBody: Codable {
    let host: String
    let hostKey: String
}

struct EventRequestBody: Codable {
    let token: String
    let host: String
    let hostKey: String
    let path: String
}

struct TokenResponse: Codable {
    let token: String
}
