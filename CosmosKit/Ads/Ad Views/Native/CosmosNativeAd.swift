import UIKit
import GoogleMobileAds

class CosmosNativeAd: UIView {

    @IBOutlet var image: UIImageView!

    var viewModel: NativeAdModalable!

    func configure(viewModel: NativeAdViewModel) {
        self.image.image = viewModel.image
        self.viewModel = viewModel
    }

    func recordImpression() {
        viewModel.recordImpression()
    }

    func performClickOnAsset(with key: String) {
        viewModel.performClickOnAsset(with: key)
    }

    class func instanceFromNib(viewModel: NativeAdViewModel) -> CosmosNativeAd {
        // swiftlint:disable:next force_cast
        let view = Bundle.cosmos.loadNibNamed(String(describing: self), owner: nil)?[0] as! CosmosNativeAd
        view.configure(viewModel: viewModel)
        return view
    }
}
