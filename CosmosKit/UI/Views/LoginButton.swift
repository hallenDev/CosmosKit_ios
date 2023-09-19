import Foundation

public class LoginButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 22
        layer.masksToBounds = true
    }
}

class WelcomePrimaryActionButton: UIButton, Themable {

    func applyTheme(theme: Theme) {
        backgroundColor = theme.accentColor
        tintColor = theme.authTheme.primaryButtonColor
        titleLabel?.textColor = theme.authTheme.primaryButtonColor
        titleLabel?.font = theme.authTheme.primaryButtonFont
        layer.cornerRadius = frame.height/2
        layer.masksToBounds = true
    }

    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
}
