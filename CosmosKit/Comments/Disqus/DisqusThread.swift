import Foundation

struct DisqusThread: Codable {
    let posts: Int
}

struct DisqusResponse: Codable {
    let response: [DisqusThread]
}
