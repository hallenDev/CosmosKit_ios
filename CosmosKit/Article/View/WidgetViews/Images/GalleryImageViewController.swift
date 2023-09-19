import UIKit

class GalleryImageViewController: UIViewController {

    @IBOutlet var articleImage: ArticleImage!
    @IBOutlet var closeButton: UIButton!

    var viewModel: ImageViewModel! {
        didSet {
            articleImage = articleImage?.fromNib()
            articleImage?.configure(with: viewModel)
            articleImage?.cosmosImage.contentMode = .scaleAspectFit
        }
    }

    var openCaption: BooleanCallback? {
        didSet {
            articleImage?.openCaption = openCaption
        }
    }

    var zoomingDidChange: BooleanCallback? {
        didSet {
            articleImage?.zoomingDidChange = zoomingDidChange
        }
    }

    @IBAction func didTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func toggleExtras(hidden: Bool) {
        closeButton.isHidden = hidden
        let isOpen = !articleImage.captionOpenImage.isHidden
        articleImage.captionClosedImage.isHidden = isOpen ? true : hidden
        articleImage.captionButton.backgroundColor = isOpen || hidden ? .clear : Theme.captionBlack
    }
}
