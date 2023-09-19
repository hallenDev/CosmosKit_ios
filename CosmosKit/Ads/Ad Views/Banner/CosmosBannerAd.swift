import UIKit
import GoogleMobileAds

class CosmosBannerAd: UIView, CosmosAd {

    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height)
    }

    var featured: Bool!
    var position: AdPosition!
    var placement: Int!
    var isLoaded = false
    weak var cosmosDelegate: CosmosAdDelegate?

    @IBOutlet var bannerWidthConstraint: NSLayoutConstraint!
    @IBOutlet var bannerHeightConstraint: NSLayoutConstraint!
    @IBOutlet var banner: GAMBannerView!

    func configure(unitID: String, sizes: [GADAdSize], root viewController: UIViewController, delegate: CosmosAdDelegate? = nil) {
        banner.validAdSizes = sizes.map { NSValueFromGADAdSize($0) }
        banner.rootViewController = viewController
        banner.adUnitID = unitID
        banner.adSizeDelegate = self
        banner.delegate = self
        cosmosDelegate = delegate
    }

    func setupConstraints(width: CGFloat, height: CGFloat) {
        banner.translatesAutoresizingMaskIntoConstraints = false
        bannerHeightConstraint.constant = height
        bannerWidthConstraint.constant = width
        self.frame = CGRect(x: 0, y: 0, width: width, height: height)
        setNeedsLayout()
    }

    func loadAd(pos: String, target: String?) {
        let adRequest = GAMRequest()
        adRequest.addTargeting(pos)
        if let target = target {
            adRequest.customTargeting?["Article"] = target
        }
        banner.load(adRequest)
    }

    func recordImpression() {
        banner.recordImpression()
    }
}

extension CosmosBannerAd: GADBannerViewDelegate {

    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner Ad Did Receive Ad")
        setupConstraints(width: bannerView.frame.width, height: bannerView.frame.height)
        isLoaded = true
        cosmosDelegate?.bannerAdReceived?(self)
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("Banner Ad did Fail To Receive Ad With Error: \(error.localizedDescription)")
        isLoaded = false
        cosmosDelegate?.bannerAdFailed?()
    }
}

extension CosmosBannerAd: GADAdSizeDelegate {
    func adView(_ bannerView: GADBannerView, willChangeAdSizeTo size: GADAdSize) {
        print("Banner Ad Will will change size \(size)")
        self.setupConstraints(width: size.size.width, height: size.size.height)
    }
}
