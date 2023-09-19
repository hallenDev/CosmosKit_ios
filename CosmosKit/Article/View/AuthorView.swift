import Foundation

public class AuthorView: UIView {

    @IBOutlet var stackViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet public var category: AuthorCategoryLabel!
    @IBOutlet var name: AuthorNameLabel!
    @IBOutlet var photo: UIImageView! {
        didSet {
            photo.layer.cornerRadius = photo.frame.height/2
            photo.layer.masksToBounds = true
        }
    }

    public func configure(with author: AuthorViewModel?, config: ArticleAuthorConfig) -> AuthorView? {
        subviews.forEach { $0.removeFromSuperview() }
        guard let author = author else {
            return nil
        }
        let view: AuthorView? = fromNib()
        view?.category.text = author.title ?? " "
        if config.capitalizeAuthor {
            view?.name.text = author.name?.uppercased()
        } else {
            view?.name.text = author.name
        }
        if author.imageURL != nil {
            view?.photo.kf.setImage(with: author.imageURL, placeholder: author.blur)
        } else {
            view?.stackViewLeadingConstraint.constant = 0
            view?.photo.isHidden = true
        }
        return view
    }

    public func configure(with author: AuthorViewModel?, date: String?, config: ArticleAuthorConfig) -> AuthorView? {
        let view = self.configure(with: author, config: config)
        view?.category.text = date
        return view
    }

    public func configureCategoryAsReadTime(_ readTime: String?) {
        self.category.text = readTime
    }
}
