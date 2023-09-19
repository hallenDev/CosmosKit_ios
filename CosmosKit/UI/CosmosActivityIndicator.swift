import UIKit
import Lottie

class CosmosActivityIndicator: UIView {

    var lotView: AnimationView?
    private var lightModeAnimation: Animation?
    private var darkModeAnimation: Animation?
    var activityIndicator: UIActivityIndicatorView?

    private struct Config {
        static let defaultDimension: CGFloat = 50
    }

    init(cosmos: Cosmos, frame: CGRect, forceUIKit: Bool = false) {
        if !forceUIKit, let config = cosmos.publication.loadingIndicator {
            let adjustedSize = frame.width * config.scale
            lotView = AnimationView()
            lightModeAnimation = Animation.named(config.lightModeAnimation)
            if let dmAnimation = config.darkModeAnimation {
                darkModeAnimation = Animation.named(dmAnimation)
            }
            super.init(frame: .zero)
            if #available(iOS 13.0, *), traitCollection.userInterfaceStyle == .dark, darkModeAnimation != nil {
                lotView?.animation = darkModeAnimation
            } else {
                lotView?.animation = lightModeAnimation
            }
            lotView?.loopMode = .loop
            lotView?.contentMode = .scaleAspectFill
            lotView?.backgroundColor = config.backgroundColor
            if config.rounded {
                lotView?.layer.cornerRadius = adjustedSize/2
            } else {
                lotView?.layer.cornerRadius = config.cornerRadius
            }

            commonInit(lotView!, size: adjustedSize)
        } else {
            super.init(frame: .zero)
            if #available(iOS 13.0, *) {
                activityIndicator = UIActivityIndicatorView(style: .large)
            } else {
                activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
            }
            activityIndicator?.hidesWhenStopped = true
            activityIndicator?.color = cosmos.theme.accentColor

            commonInit(activityIndicator!, size: Config.defaultDimension)
        }
    }

    fileprivate func commonInit(_ view: UIView, size: CGFloat) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            heightAnchor.constraint(equalToConstant: size),
            widthAnchor.constraint(equalToConstant: size)
        ])

        backgroundColor = .clear
        isHidden = true
    }

    func start() {
        self.isHidden = false
        lotView?.play()
        activityIndicator?.startAnimating()
    }

    func stop() {
        self.isHidden = true
        lotView?.stop()
        activityIndicator?.stopAnimating()
    }

    func isPlaying() -> Bool {
        return lotView?.isAnimationPlaying ?? activityIndicator?.isAnimating ?? false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard let lottie = lotView, darkModeAnimation != nil else { return }
        let progress = lottie.currentProgress
        if #available(iOS 13.0, *), traitCollection.userInterfaceStyle == .dark {
            lottie.animation = darkModeAnimation
            lottie.play(fromProgress: progress, toProgress: 1, loopMode: .playOnce) { _ in
                lottie.loopMode = .loop
                lottie.play()
            }
        } else {
            lottie.animation = lightModeAnimation
            lottie.play(fromProgress: progress, toProgress: 1, loopMode: .playOnce) { _ in
                lottie.loopMode = .loop
                lottie.play()
            }
        }
    }
}
