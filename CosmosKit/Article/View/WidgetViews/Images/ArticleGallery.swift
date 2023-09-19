import UIKit

class ArticleGallery: UIView {

    @IBOutlet var baseImage: ArticleImage?

    var viewModel: GalleryViewModel?

    var parentView: WidgetParentView? {
        didSet {
            for subView in self.subviews {
                (subView as? ArticleGallery)?.parentView = parentView
                (subView as? ArticleGallery)?.baseImage?.parentView = parentView
            }
            baseImage?.parentView = parentView
        }
    }

    init(_ viewModel: GalleryViewModel) {
        super.init(frame: CGRect.zero)
        let view: ArticleGallery? = fromNib()
        view?.configure(with: viewModel)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(with gallery: GalleryViewModel) {
        self.viewModel = gallery
        if let firstImage = gallery.images.first {
            baseImage = baseImage?.fromNib()
            baseImage?.configure(with: firstImage)
            baseImage?.parentView = parentView
        }
    }

    @IBAction func didTapOpenGallery(_ sender: Any) {
        let gallery: GalleryWidgetViewController = CosmosStoryboard.loadViewController()
        gallery.viewModel = viewModel
        gallery.modalPresentationStyle = .fullScreen
        UIApplication.shared.topViewController()?.present(gallery, animated: true, completion: nil)
    }
}
