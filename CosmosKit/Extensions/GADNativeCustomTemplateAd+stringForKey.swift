import Foundation
import GoogleMobileAds

extension GADCustomNativeAd {
    func string(for key: NativeAdFields) -> String? {
        return self.string(forKey: key.rawValue)
    }
}
