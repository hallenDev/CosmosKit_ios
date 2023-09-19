import UIKit

class SettingsSectionHeaderView: UIView {

    @IBOutlet var name: SettingsSectionLabel!

    func configure(title: String, theme: Theme) {
        name.text = title
        name.backgroundColor = theme.backgroundColor
        backgroundColor = theme.backgroundColor
    }

    static func fromNib() -> SettingsSectionHeaderView? {
        return Bundle.cosmos.loadNibNamed("SettingsSectionHeaderView",
                                                           owner: self,
                                                           options: nil)?.first as? SettingsSectionHeaderView
    }
}
