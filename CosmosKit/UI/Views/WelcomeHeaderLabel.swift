import Foundation

class WelcomeHeaderLabel: UILabel, Themable {
    func applyTheme(theme: Theme) {
        textColor = theme.authTheme.headingColor
        font = theme.authTheme.headingFont
    }
}
