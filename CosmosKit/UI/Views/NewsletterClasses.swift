import Foundation

class NewsletterDescriptor: UILabel, Themable {
    func applyTheme(theme: Theme) {
        textColor = theme.authTheme.newsletterColor
        font = theme.authTheme.newsletterFont
    }
}

class NewsletterSwitch: CosmosSwitch, Themable {

    var theme: Theme!

    func applyTheme(theme: Theme) {
        self.theme = theme
        onTintColor = theme.authTheme.newsletterSwitchBackground
        offTintColor = theme.authTheme.newsletterSwitchBackground
        borderColor = theme.authTheme.newsletterSwitchBorder
        onThumbTintColor = theme.authTheme.newsletterActiveTint
        offThumbTintColor = theme.authTheme.newsletterInactiveTint
        padding = 2
    }
}
