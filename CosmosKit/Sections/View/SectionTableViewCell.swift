import UIKit

class SectionSelectedView: UIView {}

class SectionTableViewCell: UITableViewCell {

    @IBOutlet var openIconImageView: UIImageView?
    @IBOutlet var cellButton: UIButton?
    @IBOutlet var selectedView: SectionSelectedView!
    @IBOutlet var separatorView: UIView?
    @IBOutlet var sectionName: SectionCellLabel!
    @IBOutlet var specialReportView: SectionSpecialReportView?
    @IBOutlet var specialReportLabel: SectionSpecialReportLabel?

    var stateChanged: ((SectionViewModel) -> Void)!
    var viewModel: SectionViewModel!

    func configure(with section: SectionViewModel, theme: Theme) {
        backgroundColor = theme.backgroundColor
        contentView.backgroundColor = backgroundColor
        separatorView?.backgroundColor = theme.separatorColor

        viewModel = section
        sectionName.text = section.name ?? ""

        specialReportView?.isHidden = !viewModel.isSpecialReport
        if let sections = section.subSections, !sections.isEmpty {
            let image =  UIImage(cosmosName: viewModel.expanded ? .sectionClose : .sectionOpen)
            openIconImageView?.image = image
            openIconImageView?.isHidden = false
            cellButton?.isUserInteractionEnabled = true
        } else {
            openIconImageView?.isHidden = true
            cellButton?.isUserInteractionEnabled = false
        }
        specialReportLabel?.text = LanguageManager.shared.translate(key: .specialReport)
    }

    @IBAction func changeState(_ sender: Any) {
        viewModel.expanded.toggle()
        stateChanged(viewModel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectedView.alpha = selected ? 1 : 0
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        selectedView.alpha = highlighted ? 1 : 0
    }
}

class SubSectionTableViewCell: SectionTableViewCell {
    @IBOutlet weak var sectionNameBottomConstraint: NSLayoutConstraint!

    func configure(with section: SectionViewModel, theme: Theme, hideSeperator: Bool) {
        super.configure(with: section, theme: theme)

        separatorView?.isHidden = hideSeperator
        sectionNameBottomConstraint.constant = hideSeperator ? 8 : 32 // extra space at the bottom of the last subsection
    }
}
