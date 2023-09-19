import UIKit

class SettingsToggleCell: UITableViewCell {

    @IBOutlet var title: SettingsCellLabel!
    @IBOutlet var toggle: UISwitch!

    var toggleCallback: (() -> Void)?

    func configure(option: SettingsOption, theme: Theme, callback: @escaping () -> Void) {
        title.text = option.translation
        title.textColor = theme.settingsTheme.settingColor
        toggleCallback = callback
        backgroundColor = theme.backgroundColor
        contentView.backgroundColor = theme.backgroundColor
        toggle.onTintColor = theme.accentColor
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.toggle.isOn = settings.authorizationStatus == .authorized
            }
        }
    }

    @IBAction func toggleSelected(_ sender: Any) {
        toggleCallback?()
    }
}
