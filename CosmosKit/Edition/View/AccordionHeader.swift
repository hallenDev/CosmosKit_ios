import UIKit

class AccordionHeader: UITableViewHeaderFooterView {

    @IBOutlet var titleLabel: AccordionTitleLabel!

    init(from title: String) {
        super.init(reuseIdentifier: "")
        let view: AccordionHeader? = fromNib()
        view?.configure(with: title)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(with title: String) {
        titleLabel.text = title.uppercased()
        layoutIfNeeded()
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.width
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
}
