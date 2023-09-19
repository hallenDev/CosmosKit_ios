import Foundation

open class LineSpacedLabel: UILabel {

    static var theme: Theme?

    open override var text: String? {
        didSet {
            if text != nil {
                updateLineSpacing()
            }
        }
    }

    func updateLineSpacing() {
        if let theme = LineSpacedLabel.theme,
           let lineSpacing = theme.articleHeaderTheme.titleLineSpacing,
            let ownText = self.text {

            let paragraph = NSMutableParagraphStyle()
            paragraph.lineHeightMultiple = lineSpacing
            paragraph.lineBreakMode = .byTruncatingTail

            let attributes: [NSAttributedString.Key: Any] = [
                .font: self.font as Any,
                .foregroundColor: self.textColor as Any,
                .paragraphStyle: paragraph
            ]

            self.text = nil
            self.attributedText = NSMutableAttributedString(string: ownText, attributes: attributes)
        }
    }
}
