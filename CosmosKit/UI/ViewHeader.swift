import Foundation
import UIKit

public class ViewHeader: UICollectionReusableView {

    @IBOutlet var titleLabel: HeaderLabel!

    func configure(title: String, theme: Theme) {
        titleLabel.text = title
        self.backgroundColor = theme.viewHeaderTheme.backgroundColor
        if theme.viewHeaderTheme.style == .compressed {
            let titleHeight = titleLabel.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 32,
                                                             height: .greatestFiniteMagnitude)).height
            self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: titleHeight + 16)
        }
    }

    public class func instanceFromNib(title: String, theme: Theme) -> ViewHeader {
        // swiftlint:disable:next force_cast
        let header = UINib(nibName: "ViewHeader", bundle: Bundle.cosmos).instantiate(withOwner: self)[0] as! ViewHeader
        header.configure(title: title, theme: theme)
        return header
    }
}
