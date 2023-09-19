import UIKit

class GenericWidgetCell: UITableViewCell {

    @IBOutlet var containerView: UIView!

    func configure(cosmos: Cosmos, with widget: WidgetViewModel, relatedSelected: RelatedSelectedCallback?) {
        let relatedCallback: RelatedSelectedCallback = relatedSelected ?? {_ in}
        let widgetView = widget.getView(cosmos: cosmos,
                                        as: .edition,
                                        relatedSelected: relatedCallback)
        containerView.addSubview(widgetView)
        if widget.type == .text {
            widgetView.layoutAttachAll(to: containerView, topC: -16, bottomC: 16)
        } else {
            widgetView.layoutAttachAll(to: containerView)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        for view in containerView.subviews {
            view.removeFromSuperview()
        }
    }
}
