import Foundation
import UIKit

class PagerAdViewController: UIViewController {

    var identifier: AdArticle!
    var placement: AdPlacement?
    var ad: CosmosBannerAd? {
        didSet {
            DispatchQueue.main.async {
                self.ad?.removeFromSuperview()
                self.applyConstraints()
            }
        }
    }
    var cosmos: Cosmos!

    var loaded: Bool {
        return ad?.isLoaded ??  false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let placement = placement, let factory = CosmosAdFactory(cosmos: cosmos) {
            self.ad = factory.create(from: placement, path: "", target: nil, root: self, delegate: self) as? CosmosBannerAd
        }
        view.backgroundColor = cosmos.theme.backgroundColor
    }

    func applyConstraints() {
        guard let adView = self.ad else { return }

        adView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(adView)
        adView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        adView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
}

extension PagerAdViewController: CosmosAdDelegate {
    func bannerAdReceived(_ ad: CosmosBannerAd) {
        self.ad = ad
    }
}
