import Foundation
import AVKit

class ArticleBibliodam: UIView {

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: 360)
    }

    @IBOutlet var playerThumbnail: UIImageView!
    @IBOutlet var reloadButton: UIButton!
    @IBOutlet var thumbnailAspectRatio: NSLayoutConstraint!

    var player: AVPlayer!
    var avController: AVPlayerViewController!
    var cosmos: Cosmos!
    let defaultPlaceholder = UIImage(cosmosName: .videoPlaceholder)
    var viewModel: BibliodamViewModel!

    init(_ viewModel: BibliodamViewModel, cosmos: Cosmos) {
        super.init(frame: CGRect.zero)
        let view: ArticleBibliodam? = fromNib()
        view?.cosmos = cosmos
        view?.viewModel = viewModel
        view?.configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @IBAction func reload(_ sender: Any) {
        self.configure()
    }

    func configure() {
        self.reloadButton.isHidden = true
        playerThumbnail.image = defaultPlaceholder
        if let thumbnail = viewModel.thumbnail {
            playerThumbnail.kf.setImage(with: thumbnail, placeholder: defaultPlaceholder, completionHandler: { [weak self] result in
                switch result {
                case .success(let image):
                    if let strongSelf = self {
                        let aspect = image.image.size.width/image.image.size.height
                        strongSelf.thumbnailAspectRatio = strongSelf.thumbnailAspectRatio.changeMultiplier(to: aspect)
                    }
                case.failure: break
                }
            })

        }
        if let url = viewModel.url {
            cosmos.getBibliodamUrl(url: url) { [weak self] videoUrl, _ in
                DispatchQueue.main.async {
                    if let tempUrl = videoUrl {
                        self?.configurePlayer(with: tempUrl)
                    } else {
                        self?.widgetFailedToLoad()
                    }
                }
            }
        } else {
            widgetFailedToLoad()
        }
    }

    fileprivate func configurePlayer(with url: String) {
        if let endPointUrl = URL(string: url) {
            player = AVPlayer(url: endPointUrl)
            avController = AVPlayerViewController()
            avController.player = player
            avController.view.frame = self.bounds
            self.addSubview(avController.view)
        } else {
            widgetFailedToLoad()
        }
    }

    fileprivate func widgetFailedToLoad() {
        reloadButton.isHidden = false
    }
}
