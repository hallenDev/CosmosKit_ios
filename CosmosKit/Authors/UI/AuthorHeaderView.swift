import UIKit

class AuthorHeaderView: UIView {

    @IBOutlet var mainStackView: UIStackView!
    @IBOutlet var image: UIImageView!
    @IBOutlet var name: AuthorDetailNameLabel!
    @IBOutlet var title: AuthorDetailTitleLabel!
    @IBOutlet var bio: AuthorDetailBioLabel!
    @IBOutlet var facebook: UIButton!
    @IBOutlet var twitter: UIButton!
    @IBOutlet var instagram: UIButton!
    @IBOutlet var socialStack: UIStackView!

    private struct Config {
        static let standardSpacing: CGFloat = 10
        static let nameSpacing: CGFloat = 0
    }

    var instagramUrl: URL?
    var twitterUrl: URL?
    var facebookUrl: URL?

    func configure(_ viewModel: AuthorViewModel) {
        self.name.text = viewModel.name
        self.title.text = viewModel.title
        self.bio.text = viewModel.bio
        self.bio.setNeedsLayout()

        mainStackView.setCustomSpacing(Config.nameSpacing, after: name)
        mainStackView.setCustomSpacing(Config.standardSpacing, after: title)

        if let url = viewModel.imageURL {
            self.image.kf.setImage(with: url, placeholder: viewModel.blur)
        } else {
            self.image.image = viewModel.blur
        }
        self.image.layer.cornerRadius = image.frame.height/2

        if viewModel.hasSocial {
            if let fbUrl = viewModel.facebook {
                self.facebookUrl = URL(string: fbUrl)
            } else {
                facebook.removeFromSuperview()
            }
            if let igUrl = viewModel.instagram {
                self.instagramUrl = URL(string: igUrl)
            } else {
                instagram.removeFromSuperview()
            }
            if let tUrl = viewModel.twitter {
                self.twitterUrl = URL(string: tUrl)
            } else {
                twitter.removeFromSuperview()
            }
        } else {
            socialStack.removeFromSuperview()
        }
    }

    @IBAction func openInstagram(_ sender: Any) {
        guard let url = self.instagramUrl else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @IBAction func openFacebook(_ sender: Any) {
        guard let url = self.facebookUrl else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @IBAction func openTwitter(_ sender: Any) {
        guard let url = self.twitterUrl else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    class func nib() -> UINib {
        return UINib(nibName: "AuthorHeaderView", bundle: Bundle.cosmos)
    }

    public class func instanceFromNib() -> AuthorHeaderView {
        // swiftlint:disable:next force_cast
        return nib().instantiate(withOwner: self)[0] as! AuthorHeaderView
    }
}
