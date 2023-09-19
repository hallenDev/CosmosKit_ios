import Foundation

public extension Bundle {
    static var cosmos: Bundle {
        if let bundleURL = Bundle(for: Cosmos.self).url(forResource: "CosmosKit", withExtension: "bundle"),
            let podBundle = Bundle(url: bundleURL) {
            return podBundle
        } else {
            return Bundle(for: Cosmos.self)
        }
    }
}
