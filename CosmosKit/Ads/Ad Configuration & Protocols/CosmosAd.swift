import UIKit
import GoogleMobileAds

public protocol CosmosAd {
    var isLoaded: Bool { get }
    func loadAd(pos: String, target: String?)
    func recordImpression()
}
