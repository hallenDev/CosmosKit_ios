import Foundation
import GoogleMobileAds

public enum AdPosition {
    case above
    case below
}

public enum AdType {
    case banner
    case interscroller
}

public protocol AdPlacement {
    var adId: String { get }
    var type: AdType { get }
    var featured: Bool { get }
    var position: AdPosition { get }
    var placement: Int { get }
    var sizes: [GADAdSize] { get }
}

extension AdPlacement {
    var isInterscroller: Bool {
        return self.type == .interscroller
    }

    var isBanner: Bool {
        return self.type == .banner
    }

}

public struct CosmosAdPlacement: AdPlacement {
    public let adId: String
    public let type: AdType
    public let featured: Bool
    public let position: AdPosition
    public let placement: Int
    public let sizes: [GADAdSize]

    public init(adId: String, type: AdType, featured: Bool, position: AdPosition, placement: Int, sizes: [GADAdSize]) {
        self.adId = adId
        self.type = type
        self.featured = featured
        self.position = position
        self.placement = placement
        self.sizes = sizes
    }
}

public struct CosmosNativeAdPlacement: AdPlacement {
    public let adId: String
    public let type: AdType
    public let featured: Bool
    public let position: AdPosition
    public let placement: Int
    public let sizes: [GADAdSize]
    public let templateIds: [String]
    public let customPath: String?

    // swiftlint:disable:next line_length
    public init(templateIds: [String], adId: String, customPath: String? = nil, type: AdType, featured: Bool, position: AdPosition, placement: Int, sizes: [GADAdSize]) {
        self.templateIds = templateIds
        self.adId = adId
        self.type = type
        self.featured = featured
        self.position = position
        self.placement = placement
        self.sizes = sizes
        self.customPath = customPath
    }
}
