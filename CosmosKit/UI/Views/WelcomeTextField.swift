import Foundation

class WelcomeTextField: UITextField, Themable {
    func applyTheme(theme: Theme) {
        tintColor = theme.accentColor
        textColor = theme.authTheme.textFieldColor
        backgroundColor = theme.authTheme.textFieldBackgroundColor
        font = theme.authTheme.textFieldFont
        layer.cornerRadius = 5
    }
}
