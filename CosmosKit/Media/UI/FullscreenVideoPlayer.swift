import AVKit
import AVFoundation
import Reachability

protocol MediaPlayable: UIViewController {
    var viewModel: MediaViewModel! { get set }
}

class FullscreenVideoPlayer: AVPlayerViewController, MediaPlayable {

    var viewModel: MediaViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configurePlayer()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        addDismissTransition()
        super.dismiss(animated: flag, completion: completion)
    }

    fileprivate func configurePlayer() {
        guard let videoUrl = viewModel.url, let url = URL(string: videoUrl) else {
            dismiss(animated: true)
            return
        }
        player = AVPlayer(playerItem: AVPlayerItem(asset: AVAsset(url: url)))
        entersFullScreenWhenPlaybackBegins = true
        exitsFullScreenWhenPlaybackEnds = true
        updatesNowPlayingInfoCenter = true
    }

    fileprivate func addDismissTransition() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: nil)
    }
}
