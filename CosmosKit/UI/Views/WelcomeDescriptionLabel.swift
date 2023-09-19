import Foundation

class WelcomeDescriptionLabel: UILabel, Themable {
    func applyTheme(theme: Theme) {
        textColor = theme.authTheme.textColor
        font = theme.authTheme.textFont
    }
}

class WelcomeTermsLabel: UILabel, Themable {
    func applyTheme(theme: Theme) {
        textColor = theme.authTheme.termsAndConditionsColor
        font = theme.authTheme.termsAndConditionsFont
    }
}
