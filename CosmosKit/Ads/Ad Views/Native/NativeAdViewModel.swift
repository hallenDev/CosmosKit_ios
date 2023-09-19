import Foundation
import GoogleMobileAds

enum NativeAdFields: String {
    case mainImage = "MainImage"
}

enum NativeWindowSize: String {
    case full
    case small
}

protocol NativeAdModalable {
    var template: GADCustomNativeAd { get }
}

extension NativeAdModalable {
    func recordImpression() {
        template.recordImpression()
    }

    func performClickOnAsset(with key: String) {
        template.performClickOnAsset(withKey: key)
    }
}

struct NativeAdViewModel: NativeAdModalable {
    let template: GADCustomNativeAd
    var image: UIImage?

    func clickReceived(_ itemKey: String) {
        print(itemKey)
    }
}

extension NativeAdViewModel {
    init?(template: GADCustomNativeAd) {
        guard let image = template.image(forKey: NativeAdFields.mainImage.rawValue) else { return nil }
        self.image = image.image
        self.template = template
    }
}
