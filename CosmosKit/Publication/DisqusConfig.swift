import Foundation

public protocol CommentProvider {}

public struct DisqusConfig: CommentProvider {
    let shortname: String
    let apiKey: String
    let domain: String

    public init(shortname: String, domain: String, apiKey: String) {
        self.shortname = shortname
        self.apiKey = apiKey
        self.domain = domain
    }
}

public struct ViafouraConfig: CommentProvider {
    public init() {}
}
