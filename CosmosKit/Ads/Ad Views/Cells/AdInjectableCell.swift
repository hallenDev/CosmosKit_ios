import UIKit

public protocol AdInjectableCell {
    var topAdView: AdContainerView! { get set }
    var topAdViewHeightConstraint: NSLayoutConstraint! { get set }
    var bottomAdView: AdContainerView! { get set }
    var bottomAdViewHeightConstraint: NSLayoutConstraint! { get set }
    var interscrollerTapped: EmptyCallBack! { get set }
    func configureAd(placement: AdPlacement, ad: CosmosAd)
    func insertInterscrollerButton(for targetView: UIView)
}

extension AdInjectableCell {

    var adSpace: CGFloat {
        return 16
    }

    public func configureBannerAd(placement: AdPlacement, ad: CosmosAd) {
        guard let adView = ad as? UIView else { return }
        adView.translatesAutoresizingMaskIntoConstraints = false
        if placement.position == .above && ad.isLoaded {
            topAdView.addSubview(adView)
            adView.centerYAnchor.constraint(equalTo: topAdView.centerYAnchor).isActive = true
            adView.centerXAnchor.constraint(equalTo: topAdView.centerXAnchor).isActive = true
            topAdViewHeightConstraint.constant = adView.frame.height + (16 * 2)
        } else if ad.isLoaded {
            bottomAdView.addSubview(adView)
            adView.centerYAnchor.constraint(equalTo: bottomAdView.centerYAnchor).isActive = true
            adView.centerXAnchor.constraint(equalTo: bottomAdView.centerXAnchor).isActive = true
            bottomAdViewHeightConstraint.constant = adView.frame.height + (16 * 2)
        }
    }

    public func configureInterscroller(height: CGFloat, placement: AdPlacement, ad: CosmosAd) {
        if placement.position == .above && ad.isLoaded {
            topAdView.backgroundColor = .clear
            topAdViewHeightConstraint.constant = height + (adSpace * 2)
            insertInterscrollerButton(for: topAdView)
        } else if ad.isLoaded {
            bottomAdView.backgroundColor = .clear
            bottomAdViewHeightConstraint.constant = height + (adSpace * 2)
            insertInterscrollerButton(for: bottomAdView)
        }
    }

    public func createInterScrollerButton(for targetView: UIView) -> UIButton {
        let button = UIButton(frame: targetView.frame)
        button.setTitle(nil, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        targetView.addSubview(button)
        button.leadingAnchor.constraint(equalTo: targetView.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: targetView.trailingAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: targetView.bottomAnchor).isActive = true
        button.topAnchor.constraint(equalTo: targetView.topAnchor).isActive = true
        return button
    }
}
