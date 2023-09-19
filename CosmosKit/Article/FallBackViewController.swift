import UIKit

public protocol FallbackConfigurable {
    var fallback: Fallback { get }
}

public struct Fallback: Equatable {

    public static func == (lhs: Fallback, rhs: Fallback) -> Bool {
        return lhs.title == rhs.title && lhs.body == rhs.body && lhs.image == rhs.image
    }

    var title: String
    var body: String
    var image: UIImage?

    public init(title: String, body: String, image: UIImage?) {
        self.title = title
        self.body = body
        self.image = image
    }
}

class FallbackViewController: UIViewController {

    @IBOutlet var centerConstraint: NSLayoutConstraint!
    @IBOutlet var titleLabel: FallbackViewTitleLabel!
    @IBOutlet var bodyLabel: FallbackViewInfoLabel!
    @IBOutlet var imageView: UIImageView!

    var fallback: Fallback!
    var cosmos: Cosmos!

    func configure(fallback: Fallback, cosmos: Cosmos, centerOffset: CGFloat = 0) {
        self.cosmos = cosmos
        self.fallback = fallback
        centerConstraint.constant = centerOffset
        configureUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configureUI() {
        titleLabel.text = fallback.title
        bodyLabel.text = fallback.body
        imageView.image = fallback.image
        imageView.tintColor = cosmos.theme.accentColor
        view.backgroundColor = cosmos.theme.backgroundColor
    }
}
