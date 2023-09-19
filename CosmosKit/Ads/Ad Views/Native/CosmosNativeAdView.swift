import Foundation
import GoogleMobileAds

class CosmosNativeAdView: UIView, CosmosAd {

    weak var cosmosDelegate: CosmosAdDelegate?
    var nativeAd: CosmosNativeAd!
    var adLoader: GADAdLoader!
    var templateIds = [String]()
    var isLoaded = false

    init(frame: CGRect,
         unitID: String,
         templateIds: [String],
         root viewController: UIViewController,
         delegate: CosmosAdDelegate? = nil) {

        super.init(frame: frame)

        self.templateIds = templateIds
        self.cosmosDelegate = delegate
        adLoader = GADAdLoader(adUnitID: unitID,
                               rootViewController: viewController,
                               adTypes: [.customNative],
                               options: [])
        adLoader.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadAd(pos: String, target: String?) {
        let adRequest = GAMRequest()
        adRequest.addTargeting(pos)
        if target != nil {
            adRequest.customTargeting?["Article"] = "FICAug2020"
        }
        adLoader.load(adRequest)
    }

    func recordImpression() {
        nativeAd.recordImpression()
    }

    func performClickOnAsset(with key: String) {
        nativeAd.performClickOnAsset(with: key)
    }
}

extension CosmosNativeAdView: GADCustomNativeAdLoaderDelegate {

    func customNativeAdFormatIDs(for adLoader: GADAdLoader) -> [String] {
        templateIds
    }

    func adLoader(_ adLoader: GADAdLoader, didReceive customNativeAd: GADCustomNativeAd) {
        print("adLoader did Receive native Custom Template Ad")
        if let viewModel = NativeAdViewModel(template: customNativeAd) {
            nativeAd = CosmosNativeAd.instanceFromNib(viewModel: viewModel)
            isLoaded = true
            insertAd()
            cosmosDelegate?.nativeAdReceived?()
        } else {
            print("failed to create viewmodel from native ad")
            failed()
        }
    }

    func insertAd() {
        DispatchQueue.main.async {
            self.addSubview(self.nativeAd)
            self.nativeAd.translatesAutoresizingMaskIntoConstraints = false
            self.nativeAd.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            self.nativeAd.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            self.nativeAd.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            self.nativeAd.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        }
    }

    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("adLoader did Fail To Receive Ad With Error \(error.localizedDescription)")
        failed()
    }

    func failed() {
        cosmosDelegate?.nativeAdFailed?()
        isLoaded = false
    }
}

extension GAMRequest {
    func addTargeting(_ pos: String) {
        print("&&&&& Loading ad with \(["Pos": pos])")
        self.customTargeting = ["Pos": pos]
    }
}
