import Foundation

class WelcomeSecondaryActionButton: UIButton, Themable {
    func applyTheme(theme: Theme) {
        backgroundColor = .clear
        tintColor = theme.authTheme.secondaryButtonColor
        titleLabel?.textColor = theme.authTheme.secondaryButtonColor
        titleLabel?.font = theme.authTheme.secondaryButtonFont!
    }

    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
}
