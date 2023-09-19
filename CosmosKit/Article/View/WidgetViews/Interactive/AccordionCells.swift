import UIKit

class AccordionHeaderCell: UITableViewCell {

    @IBOutlet var headerLabel: AccordionHeaderLabel!
    @IBOutlet var arrowImage: UIImageView!

    func configure(viewModel: AccordionItemViewModel, theme: Theme) {
        headerLabel.text = viewModel.title
        layoutIfNeeded()
        headerLabel.preferredMaxLayoutWidth = headerLabel.frame.width
        arrowImage.image = viewModel.open ? UIImage(cosmosName: .arrowDown) : UIImage(cosmosName: .arrowRight)
        contentView.backgroundColor = theme.backgroundColor
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        headerLabel.text = nil
    }
}

class AccordionBodyCell: UITableViewCell {

    @IBOutlet var bodyLabel: AccordionBodyLabel!

    func configure(text: String, theme: Theme) {
        bodyLabel.text = text
        layoutIfNeeded()
        bodyLabel.preferredMaxLayoutWidth = bodyLabel.frame.width
        contentView.backgroundColor = theme.backgroundColor
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bodyLabel.text = nil
    }
}
