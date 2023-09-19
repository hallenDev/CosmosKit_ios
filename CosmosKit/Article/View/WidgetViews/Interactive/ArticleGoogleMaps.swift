import Foundation

class ArticleGoogleMaps: UIView {

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 180)
    }

    @IBOutlet var mapImageView: UIImageView!
    var viewModel: GoogleMapsViewModel?

    init(_ viewModel: GoogleMapsViewModel, cosmos: Cosmos) {
        super.init(frame: CGRect.zero)
        let view: ArticleGoogleMaps? = fromNib()
        view?.configure(with: viewModel, cosmos: cosmos)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func configure(with map: GoogleMapsViewModel, cosmos: Cosmos) {
        self.viewModel = map
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapMap))
        mapImageView.addGestureRecognizer(tap)
        mapImageView.kf.setImage(with: map.getMapURL(key: cosmos.publication.mapsApiKey), completionHandler: { [weak self] result in
            switch result {
            case .success: break
            case .failure:
                let offline: ArticleOffline = ArticleOffline.instanceFromNib()
                offline.configure(frame: self?.frame ?? .zero, type: .googleMaps, reload: {
                    self?.configure(with: map, cosmos: cosmos)
                    offline.removeFromSuperview()
                })
                self?.addSubview(offline)
            }
            self?.invalidateIntrinsicContentSize()
        })
    }

    @objc func didTapMap() {
        if let urlString = viewModel?.mapOpenUrl,
           let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
