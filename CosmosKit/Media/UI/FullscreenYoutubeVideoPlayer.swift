import Foundation
import YoutubePlayer_in_WKWebView

class FullscreenYoutubeVideoPlayer: CosmosBaseViewController, MediaPlayable {

    var viewModel: MediaViewModel!
    private var player: WKYTPlayerView!
    private var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(cosmosName: .sectionClose), for: .normal)
        return button
    }()
    private let vars: [String: String] = ["playsinline": "0",
                                          "autoplay": "1",
                                          "modestbranding": "0",
                                          "origin": "http://www.youtube.com"]

    private struct Config {
        static let playerTopOffset: CGFloat = 20
        static let closeLeadingOffset: CGFloat = 16
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
        }
        configureCloseButton()
        guard reachability?.connection != .unavailable else {
            showNetworkFailure()
            return
        }
        addWebPlayer()
        configureWebPlayer()
    }

    fileprivate func addWebPlayer() {
        player = WKYTPlayerView()
        player.delegate = self
        player.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(player)
        NSLayoutConstraint.activate([
            player.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            player.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Config.playerTopOffset),
            player.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            player.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    fileprivate func configureWebPlayer() {
        if let youtubeID = viewModel.id {
            player.load(withVideoId: youtubeID, playerVars: vars)
        } else if let playlist = viewModel.pid {
            player.load(withPlaylistId: playlist, playerVars: vars)
        } else {
            showContentFailure()
        }
    }

    override func showContentFailure() {
        super.showContentFailure()
        view.bringSubviewToFront(closeButton)
    }

    override func showNetworkFailure() {
        super.showNetworkFailure()
        view.bringSubviewToFront(closeButton)
    }

    override func handleComingBackOnline() {
        super.handleComingBackOnline()
        if player == nil {
            addWebPlayer()
        }
        configureWebPlayer()
    }

    fileprivate func configureCloseButton() {
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Config.closeLeadingOffset),
                                     closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)])
        closeButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
    }

    @objc func hide() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: nil)
        dismiss(animated: true, completion: nil)
    }
}
extension FullscreenYoutubeVideoPlayer: WKYTPlayerViewDelegate {
    func playerViewPreferredInitialLoading(_ playerView: WKYTPlayerView) -> UIView? {
        let image = UIImageView(image: UIImage(cosmosName: .videoPlaceholder))
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .black
        return image
    }

    func playerViewPreferredWebViewBackgroundColor(_ playerView: WKYTPlayerView) -> UIColor {
        return .black
    }

    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
        player.playVideo()
    }
}
