// swiftlint:disable line_length multiple_closures_with_trailing_closure
import UIKit

typealias BooleanCallback = (Bool) -> Void
typealias WidgetViewModelCallback = ((WidgetViewModel) -> Void)
typealias WidgetParentView = (UIView, Int)

class ArticleImage: UIView {

    @IBOutlet var cosmosImage: UIImageView!
    @IBOutlet var imageTitle: ImageCaptionTitleLabel!
    @IBOutlet var imageDescription: ImageCaptionLabel!
    @IBOutlet var imageAuthor: ImageCaptionLabel!

    @IBOutlet var captionButton: UIButton!
    @IBOutlet var captionView: UIStackView!
    @IBOutlet var captionOpenImage: UIImageView!
    @IBOutlet var captionClosedImage: UIImageView!
    @IBOutlet var captionBackground: UIView!

    @IBOutlet var captionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var imageAspectRatioContraint: NSLayoutConstraint!

    var openCaption: BooleanCallback?
    var zoomingDidChange: BooleanCallback?
    var originalImageCenter: CGPoint?
    var pinch: UIPinchGestureRecognizer!
    var pan: UIPanGestureRecognizer!

    var parentView: WidgetParentView? {
        didSet {
            for subView in self.subviews {
                (subView as? ArticleImage)?.parentView = parentView
            }
        }
    }

    var isZooming = false {
        didSet {
            zoomingDidChange?(isZooming)
        }
    }

    var currentImageScale: CGFloat {
        return cosmosImage.frame.size.width / cosmosImage.bounds.size.width
    }

    init(_ viewModel: ImageViewModel) {
        super.init(frame: CGRect.zero)
        let view: ArticleImage? = fromNib()
        view?.configure(with: viewModel)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(with image: ImageViewModel) {
        configurePinchZoom()
        configureImage(image)
        configureCaption(image)
    }

    func configureImage(_ image: ImageViewModel) {
        let aspect = image.imageWidth/image.imageHeight
        imageAspectRatioContraint = imageAspectRatioContraint.changeMultiplier(to: aspect)
        cosmosImage.kf.setImage(with: image.imageURL, placeholder: image.blur)
        backgroundColor = .black
        layoutIfNeeded()
    }

    func switchSubViews() {
        if let parent = parentView {
            if let stackView = parent.0 as? UIStackView {
                stackView.exchangeSubview(at: stackView.arrangedSubviews.count - 1, withSubviewAt: parent.1)
                parentView = nil
            } else if let tableView = parent.0 as? UITableView {
                tableView.bringSubviewToFront(self)
            }
        }
    }

    func configurePinchZoom() {
        pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinch(sender:)))
        pinch.delegate = self
        cosmosImage.addGestureRecognizer(pinch)
        pan = UIPanGestureRecognizer(target: self, action: #selector(pan(sender:)))
        pan.delegate = self
        cosmosImage.addGestureRecognizer(pan)
    }

    func configureCaption(_ image: ImageViewModel) {
        if image.title == "" && image.description == "" && image.author == "" {
            disableCaption()
            return
        }
        imageTitle.text = image.title
        imageDescription.text = image.description
        imageAuthor.text = image.author
        captionOpenImage.isHidden = true
        captionClosedImage.isHidden = false
        captionClosedImage.alpha = 1
        captionViewBottomConstraint.constant = captionBackground.frame.height
        captionView.alpha = 0.0
        captionBackground.alpha = 0.0
        self.layoutIfNeeded()
    }

    func disableCaption() {
        captionButton.isEnabled = false
        captionButton.isHidden = true
        captionView.isHidden = true
        captionOpenImage.isHidden = true
        captionClosedImage.isHidden = true
        captionBackground.isHidden = true
    }

    @IBAction func expandOrClose(_ sender: Any) {
        let willOpen = captionOpenImage.isHidden
        openCaption?(willOpen)
        expandCaption(willOpen)
    }

    func expandCaption(_ willOpen: Bool) {
        self.clipsToBounds = true
        if willOpen {
            UIView.animate(withDuration: 0.4, animations: {
                self.layoutIfNeeded()
                self.captionClosedImage.alpha = 0
                self.captionButton.backgroundColor = .clear
            }) { (finished) in
                if finished {
                    self.captionClosedImage.isHidden = true
                }
            }
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.layoutIfNeeded()
                self.captionOpenImage.alpha = 0
            }) { (finished) in
                if finished {
                    self.captionOpenImage.isHidden = true
                }
            }
        }

        let height: CGFloat = willOpen ? -16 : self.captionBackground.frame.height
        self.captionViewBottomConstraint.constant = height

        UIView.animate(withDuration: 0.6, animations: {
            self.layoutIfNeeded()
            self.captionView.alpha = willOpen ? 1 : 0
            self.captionBackground.alpha = willOpen ? 1 : 0
        }, completion: { _ in
            if willOpen {
                self.captionOpenImage.isHidden = false
                self.captionOpenImage.alpha = 0
                UIView.animate(withDuration: 0.2, animations: {
                    self.layoutIfNeeded()
                    self.captionOpenImage.alpha = 1
                })
            } else {
                self.captionClosedImage.isHidden = false
                self.captionClosedImage.alpha = 0
                UIView.animate(withDuration: 0.4, animations: {
                    self.layoutIfNeeded()
                    self.captionClosedImage.alpha = 1
                    self.captionButton.backgroundColor = Theme.captionBlack
                })
                self.clipsToBounds = false
            }
        })
    }

    func toggleCaptionStatic(open: Bool) {
        captionView.alpha = open ? 1 : 0
        captionBackground.alpha = open ? 1 : 0
        captionOpenImage.isHidden = !open
        captionOpenImage.alpha = open ? 1 : 0
        captionClosedImage.isHidden = open
        captionClosedImage.alpha = open ? 0 : 1
        let height: CGFloat = open ? -16 : self.captionBackground.frame.height
        self.captionViewBottomConstraint.constant = height
    }
}

extension ArticleImage {

    func startZoom(_ sender: UIPinchGestureRecognizer) {
        let newScale = currentImageScale * sender.scale
        isZooming = newScale > 1
    }

    func changeZoom(_ sender: UIPinchGestureRecognizer) {
        guard let view = sender.view else { return }
        let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX,
                                  y: sender.location(in: view).y - view.bounds.midY)

        let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
            .scaledBy(x: sender.scale, y: sender.scale)
            .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)

        var newScale = currentImageScale * sender.scale

        if newScale < 1 {
            newScale = 1
            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
            cosmosImage.transform = transform
        } else {
            view.transform = transform
        }
        sender.scale = 1
    }

    func endZoom(_ sender: UIPinchGestureRecognizer) {
        guard let center = originalImageCenter else { return }

        UIView.animate(withDuration: 0.3, animations: {
            self.cosmosImage.transform = CGAffineTransform.identity
            self.cosmosImage.center = center
        }, completion: { _ in
            self.isZooming = false
        })
    }

    @objc func pinch(sender: UIPinchGestureRecognizer) {
        switchSubViews()
        switch sender.state {
        case .began:
            originalImageCenter = sender.view?.center
            startZoom(sender)
        case .changed:
            changeZoom(sender)
        default:
            endZoom(sender)
        }
    }

    func panImage(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        if let view = sender.view {
            view.center = CGPoint(x: view.center.x + translation.x,
                                  y: view.center.y + translation.y)
        }
        sender.setTranslation(CGPoint.zero, in: cosmosImage.superview)
    }

    @objc func pan(sender: UIPanGestureRecognizer) {
        guard isZooming else { return }

        switch sender.state {
        case .began:
            originalImageCenter = sender.view?.center
        case .changed:
            panImage(sender)
        default: break
        }
    }
}

extension ArticleImage: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if areImageGestures(gestureRecognizer, otherGestureRecognizer) ||
            areNotImageGestures(gestureRecognizer, otherGestureRecognizer) ||
            !isZooming ||
            (isZooming && isImagePanGesture(gestureRecognizer, otherGestureRecognizer)) {
            return true
        } else {
            return false
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return isImageGesture(gestureRecognizer) && isZooming
    }

    func areImageGestures(_ gesture: UIGestureRecognizer, _ otherGesture: UIGestureRecognizer) -> Bool {
        return (gesture == pinch && otherGesture == pan) || (gesture == pan && otherGesture == pinch)
    }

    func areNotImageGestures(_ gesture: UIGestureRecognizer, _ otherGesture: UIGestureRecognizer) -> Bool {
        return isNotImageGesture(gesture) && isNotImageGesture(otherGesture)
    }

    func isNotImageGesture(_ gesture: UIGestureRecognizer) -> Bool {
       return gesture != pinch && gesture != pan
    }

    func isImageGesture(_ gesture: UIGestureRecognizer) -> Bool {
        return gesture == pinch || gesture == pan
    }

    func isImagePanGesture(_ gesture: UIGestureRecognizer, _ otherGesture: UIGestureRecognizer) -> Bool {
        return gesture == pan || otherGesture == pan
    }

    func isImagePinchGesture(_ gesture: UIGestureRecognizer, _ otherGesture: UIGestureRecognizer) -> Bool {
        return gesture == pinch || otherGesture == pinch
    }
}

public extension NSLayoutConstraint {
    func changeMultiplier(to multiplier: CGFloat) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(
            item: self.firstItem as Any,
            attribute: self.firstAttribute,
            relatedBy: self.relation,
            toItem: self.secondItem,
            attribute: self.secondAttribute,
            multiplier: multiplier,
            constant: self.constant)

        newConstraint.priority = self.priority

        NSLayoutConstraint.deactivate([self])
        NSLayoutConstraint.activate([newConstraint])

        return newConstraint
    }
}
