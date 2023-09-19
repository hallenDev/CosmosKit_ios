import Foundation
import Reachability
import YoutubePlayer_in_WKWebView

class ArticleYoutube: UIView {

    @IBOutlet var player: WKYTPlayerView! {
        didSet {
            player.delegate = self
        }
    }

    let reachability = try? Reachability()

    init(_ viewModel: YoutubeViewModel) {
        super.init(frame: CGRect.zero)
        let view: ArticleYoutube? = fromNib()
        view?.configure(with: viewModel)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    fileprivate func loadOffline(_ youtube: YoutubeViewModel) {
        let offline: ArticleOffline = ArticleOffline.instanceFromNib()
        offline.configure(frame: self.frame, type: .youtube, reload: {
            self.configure(with: youtube)
            offline.removeFromSuperview()
        })
        self.addSubview(offline)
    }

    private func configure(with youtube: YoutubeViewModel) {
        if reachability?.connection == .unavailable {
            loadOffline(youtube)
        } else {
            let vars = ["playsinline": 1,
                        "origin": "http://www.youtube.com"] as [String: Any]
            if let youtubeID = youtube.id {
                player.load(withVideoId: youtubeID, playerVars: vars)
            } else if let playlist = youtube.playlistId {
                player.load(withPlaylistId: playlist, playerVars: vars)
            } else {
                loadOffline(youtube)
            }
        }
    }
}

extension ArticleYoutube: WKYTPlayerViewDelegate {
    func playerViewPreferredInitialLoading(_ playerView: WKYTPlayerView) -> UIView? {
        let image = UIImageView(image: UIImage(cosmosName: .videoPlaceholder))
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .black
        return image
    }

    func playerViewPreferredWebViewBackgroundColor(_ playerView: WKYTPlayerView) -> UIColor {
        return .black
    }
}
