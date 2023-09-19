import Foundation

public protocol ContentSpecifiedCell {
    var contentLock: UIImageView? { get set }
    var contentLockWidthConstraint: NSLayoutConstraint? { get set }
    var contentLockHeightConstraint: NSLayoutConstraint? { get set }
}

extension ContentSpecifiedCell {
    func applyContentImage(locked: Bool, featured: Bool, cosmos: Cosmos) {
        guard let lockImageView = contentLock else { return }
        if featured, locked, let lockImage = cosmos.uiConfig.featuredLockImage {
            set(image: lockImage, cosmos: cosmos)
        } else if locked, let lockImage = cosmos.uiConfig.lockImage {
            set(image: lockImage, cosmos: cosmos)
        } else if !locked, let freeImage = cosmos.uiConfig.freeImage {
            set(image: freeImage, cosmos: cosmos)
        } else {
            lockImageView.isHidden = true
        }
    }

    fileprivate func set(image: UIImage, cosmos: Cosmos) {
        contentLock?.image = image
        contentLock?.isHidden = false
        calculateRatio(for: image, cosmos: cosmos)
    }

    fileprivate func calculateRatio(for image: UIImage, cosmos: Cosmos) {
        let height = cosmos.uiConfig.contentLockHeight
        let imageRatio = image.size.width/image.size.height
        let imageWidth = imageRatio * height
        contentLockWidthConstraint?.constant = imageWidth
        contentLockHeightConstraint?.constant = height
    }
}
