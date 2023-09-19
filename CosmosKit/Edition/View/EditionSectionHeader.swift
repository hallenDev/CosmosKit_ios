// swiftlint:disable identifier_name
import UIKit

class EditionSectionHeader: UITableViewHeaderFooterView {

    @IBOutlet var backgroundContainer: UIView!
    @IBOutlet var subSubTitle: BodyLabel!
    @IBOutlet var title: EditionListSectionLabel!
    @IBOutlet var subTitle: EditionListSectionBylineLabel!
    var titleFont: UIFont!
    var subTitleFont: UIFont!
    var shadowColor: UIColor?

    enum SectionHeaderStyle {
        case h2
        case h3
        case other
    }

    init(from section: EditionSectionViewModel, theme: Theme) {
        super.init(reuseIdentifier: "")
        let view: EditionSectionHeader? = fromNib()
        view?.configure(with: section, theme: theme)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(with section: EditionSectionViewModel, theme: Theme) {
        titleFont = EditionListSectionLabel.appearance().font
        subTitleFont = EditionListSectionBylineLabel.appearance().font
        shadowColor = theme.editionTheme?.editionSectionTheme.sectionShadowColor
        backgroundContainer.backgroundColor = theme.backgroundColor
        if section.heading.starts(with: "<") {
            configureSpecialHeading(section, theme: theme)
        } else {
            configureSectionHeading(section)
            applyShadow()
        }
    }

    private func configureSpecialHeading(_ section: EditionSectionViewModel, theme: Theme) {

        if section.heading.starts(with: "<h2") { // main heading
            configureHeading(heading: section.heading, style: .h2, theme: theme)
        } else if section.heading.starts(with: "<h3") { // subheading
            configureHeading(heading: section.heading, style: .h3, theme: theme)
        } else { // other
            configureHeading(heading: section.heading, style: .other, theme: theme)
        }
        self.layoutSubviews()
    }

    private func configureHeading(heading: String, style: SectionHeaderStyle, theme: Theme) {
        switch style {
        case .h2:
            let text = String.attributedString(html: heading,
                                               font: titleFont,
                                               size: UIFont.preferredFont(forTextStyle: .title2).fontDescriptor.pointSize)
            let fullRange = NSRange(location: 0, length: text?.length ?? 0)
            text?.addAttribute(.foregroundColor, value: EditionListSectionLabel.appearance().textColor as Any, range: fullRange)

            text?.addAttribute(.font, value: titleFont as Any, range: fullRange)

            title.attributedText = text?.trailingNewlineTrimmed

            applyShadow()
            disableViews(heading: false, subHeading: true, subSubHeading: true)
        case .h3:
            let text = String.attributedString(html: heading,
                                               font: subTitleFont,
                                               size: UIFont.preferredFont(forTextStyle: .caption1).fontDescriptor.pointSize)

            let fullRange = NSRange(location: 0, length: text?.length ?? 0)
            text?.addAttribute(.foregroundColor, value: EditionListSectionBylineLabel.appearance().textColor as Any, range: fullRange)
            text?.addAttribute(.font, value: subTitleFont as Any, range: fullRange)

            subTitle.attributedText = text?.trailingNewlineTrimmed

            self.layer.masksToBounds = true
            disableViews(heading: true, subHeading: false, subSubHeading: true)
        default:
            let font = UIFont(name: theme.articleTheme.bodyFontName, textStyle: .body)
            let text = String.attributedString(html: heading,
                                               font: font,
                                               italicFont: theme.articleTheme.bodyItalicFontName,
                                               boldFont: theme.articleTheme.bodyBoldFontName)

            subSubTitle.attributedText = text?.trailingNewlineTrimmed

            self.layer.masksToBounds = true
            disableViews(heading: true, subHeading: true, subSubHeading: false)
        }
        // swiftlint:enable line_length
    }

    private func disableViews(heading: Bool, subHeading: Bool, subSubHeading: Bool) {
        if heading {
            title.text = nil
            title.frame = .zero
        }
        if subHeading {
            subTitle.text = nil
            subTitle.frame = .zero
        }
        if subSubHeading {
            subSubTitle.text = nil
            subSubTitle.frame = .zero
        }
    }

    private func applyShadow() {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.5
        if let injectedColor = shadowColor {
            layer.shadowColor = injectedColor.cgColor
        } else if #available(iOS 13.0, *) {
            layer.shadowColor = UIColor(dynamicProvider: { trait -> UIColor in
                if trait.userInterfaceStyle == .dark {
                    return .white
                } else {
                    return .black
                }
            }).cgColor
        } else {
            layer.shadowColor = UIColor.black.cgColor
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        applyShadow()
    }

    func configureSectionHeading(_ section: EditionSectionViewModel) {
        let titleText = String.attributedString(html: section.heading,
                                                font: titleFont)?.string

        let subText = String.attributedString(html: section.subHeading,
                                              font: subTitleFont)?.string

        if let titleText = titleText,
            !titleText.isEmpty {
            title.text = titleText.trailingNewlineTrimmed
        } else {
            title.text = nil
            title.frame = .zero
        }

        if let subText = subText,
            !subText.isEmpty {
            subTitle.text = subText.trailingNewlineTrimmed
        } else {
            subTitle.text = nil
            subTitle.frame = .zero
        }

        subTitle.textColor = EditionListSectionBylineLabel.appearance().textColor
        title.textColor = EditionListSectionLabel.appearance().textColor

        title.font = EditionListSectionLabel.appearance().font
        subTitle.font = EditionListSectionBylineLabel.appearance().font

        subSubTitle.text = nil
        subSubTitle.frame = .zero
    }
}

extension NSAttributedString {
    var trailingNewlineTrimmed: NSAttributedString {
        if string.hasSuffix("\n") {
            return self.attributedSubstring(from: NSRange(location: 0, length: length - 1))
        } else {
            return self
        }
    }
}

extension String {
    var trailingNewlineTrimmed: String {
        return self.replaceLast(of: "\n", with: "")
    }
}
