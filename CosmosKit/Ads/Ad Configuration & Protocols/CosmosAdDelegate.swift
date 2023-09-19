import Foundation
import GoogleMobileAds

@objc protocol CosmosAdDelegate: class {
    @objc optional func bannerAdReceived(_ ad: CosmosBannerAd)
    @objc optional func bannerAdFailed()
    @objc optional func interstitialAdReceived()
    @objc optional func interstitialAdFailed()
    @objc optional func nativeAdReceived()
    @objc optional func nativeAdFailed()
}
