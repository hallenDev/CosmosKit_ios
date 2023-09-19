import Foundation

class CosmosSwitchCell: UITableViewCell, Themable {

    @IBOutlet var enabledSwitch: NewsletterSwitch!
    @IBOutlet var descriptor: NewsletterDescriptor!

    var switchChanged: BooleanCallback?

    func configure(theme: Theme,
                   title: String,
                   value: Bool,
                   switchChanged: @escaping BooleanCallback) {
        enabledSwitch.isOn = value
        applyTheme(theme: theme)
        descriptor.text = title
        self.switchChanged = switchChanged
    }

    @IBAction func valueChanged(_ sender: Any) {
        switchChanged?(enabledSwitch.isOn)
    }

    func applyTheme(theme: Theme) {
        contentView.backgroundColor = theme.backgroundColor
        enabledSwitch.applyTheme(theme: theme)
        descriptor.applyTheme(theme: theme)
    }
}
