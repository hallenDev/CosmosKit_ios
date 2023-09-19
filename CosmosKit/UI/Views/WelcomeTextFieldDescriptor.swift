import Foundation

class WelcomeTextFieldDescriptor: UILabel, Themable {
    func applyTheme(theme: Theme) {
        font = theme.authTheme.textFieldDescriptorFont
        textColor = theme.authTheme.textFieldDescriptorColor
    }
}
