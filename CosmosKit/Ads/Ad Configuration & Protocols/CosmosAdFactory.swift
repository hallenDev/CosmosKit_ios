// swiftlint:disable function_parameter_count
import Foundation
import GoogleMobileAds

class CosmosAdFactory {

    let config: AdConfig!

    init?(cosmos: Cosmos) {
        guard cosmos.adsEnabled, let config = cosmos.adConfig else { return nil }
        if Environment.isSimulator() {
            GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["kGADSimulatorID"]
        }
        self.config = config
    }

    func create(from placement: AdPlacement,
                path: String,
                target: String?,
                root: UIViewController,
                frame: CGRect = .zero,
                delegate: CosmosAdDelegate? = nil,
                preventLoad: Bool = false) -> CosmosAd {

        switch placement.type {
        case .interscroller:
            return createNative(path: path,
                                target: target,
                                placement: placement,
                                frame: frame,
                                root: root,
                                delegate: delegate,
                                preventLoad: preventLoad)

        case .banner:
            return createBanner(path: path,
                                target: target,
                                placement: placement,
                                sizes: placement.sizes,
                                type: placement.type,
                                root: root,
                                delegate: delegate,
                                preventLoad: preventLoad)
        }
    }

    func createBanner(path: String,
                      target: String?,
                      placement: AdPlacement,
                      sizes: [GADAdSize],
                      type: AdType,
                      root: UIViewController,
                      delegate: CosmosAdDelegate? = nil,
                      preventLoad: Bool = false) -> CosmosBannerAd {

        let unitId = config.base + path
        print("&&&&& Serving Banner ad with \(unitId)")
        let banner: CosmosBannerAd = CosmosBannerAd.instanceFromNib()
        banner.configure(unitID: unitId, sizes: sizes, root: root, delegate: delegate)

        if !preventLoad {
            banner.loadAd(pos: placement.adId, target: target)
        }

        return banner
    }

    func createNative(path: String,
                      target: String?,
                      placement: AdPlacement,
                      frame: CGRect,
                      root: UIViewController,
                      delegate: CosmosAdDelegate? = nil,
                      preventLoad: Bool = false) -> CosmosNativeAdView {

        guard let placement = placement as? CosmosNativeAdPlacement else {
            return CosmosNativeAdView(frame: frame,
                                      unitID: "/6499/example/native",
                                      templateIds: ["10104090"],
                                      root: root,
                                      delegate: delegate)
        }

        var unitId = config.base + placement.adId
        if let override = placement.customPath {
            unitId = override
        }

        print("&&&&& Serving Native ad with \(unitId) and templates: \(placement.templateIds)")
        let native = CosmosNativeAdView(frame: frame,
                                        unitID: unitId,
                                        templateIds: placement.templateIds,
                                        root: root,
                                        delegate: delegate)

        if !preventLoad {
            native.loadAd(pos: placement.adId, target: target)
        }

        return native
    }
}
