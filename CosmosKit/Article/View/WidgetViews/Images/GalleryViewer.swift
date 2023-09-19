// swiftlint:disable force_cast
// swiftlint:disable line_length
// swiftlint:disable identifier_name
import Foundation

class GalleryWidgetViewController: UIPageViewController {

    let imageViewController: GalleryImageViewController  = CosmosStoryboard.loadViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        self.view.backgroundColor = .black
        for subview in view.subviews {
            subview.backgroundColor = .black
        }
    }

    var viewModel: GalleryViewModel? {
        didSet {
            updateUI()
        }
    }
    var controllers = [GalleryImageViewController]()

    func updateUI() {
        if let viewModel = viewModel {
            controllers = viewModel.images.map {
                let vc = imageViewController
                _ = vc.view
                vc.viewModel = $0
                vc.openCaption = { opened in
                    self.toggleCaptions(vc, willOpen: opened)
                }
                vc.zoomingDidChange = { zooming in
                    zooming ? self.disableSwipeGesture() : self.enableSwipeGesture()
                }
                return vc
            }
            if let firstImage = controllers.first {
                setViewControllers([firstImage], direction: .forward, animated: true, completion: nil)
            }
        }
    }

    func toggleCaptions(_ sender: GalleryImageViewController, willOpen: Bool) {
        for vc in controllers where vc != sender {
            vc.articleImage.toggleCaptionStatic(open: willOpen)
        }
    }
}

extension GalleryWidgetViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        (pendingViewControllers.first as? GalleryImageViewController)?.toggleExtras(hidden: true)
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        for vc in viewControllers! {
            (vc as? GalleryImageViewController)?.toggleExtras(hidden: false)
        }
    }
}

extension GalleryWidgetViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController as! GalleryImageViewController),
            (index - 1) >= 0
            else {
            return nil
        }
        return controllers[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController as! GalleryImageViewController),
            (index + 1) < controllers.count
            else {
            return nil
        }
        return controllers[index + 1]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return controllers.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension GalleryWidgetViewController {
    func enableSwipeGesture() {
        for subView in self.view.subviews {
            (subView as? UIScrollView)?.isScrollEnabled = true
        }
    }

    func disableSwipeGesture() {
        for subView in self.view.subviews {
            (subView as? UIScrollView)?.isScrollEnabled = false
        }
    }
}
