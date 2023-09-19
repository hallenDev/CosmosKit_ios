import Foundation

public struct NavigationTheme: SubTheme {
    public init(color: UIColor, buttonColor: UIColor, buttonTextColor: UIColor, progressBarColor: UIColor) {
        self.color = color
        self.buttonColor = buttonColor
        self.buttonTextColor = buttonTextColor
        self.progressBarColor = progressBarColor
    }

    public let color: UIColor
    let buttonColor: UIColor
    let buttonTextColor: UIColor
    let progressBarColor: UIColor

    func applyColors(parent: Theme) {
        UINavigationBar.appearance().barTintColor = color
        UINavigationBar.appearance().tintColor = buttonColor
        UINavigationBar.appearance().isOpaque = true
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: parent.textColor
        ]
        StatusView.appearance().backgroundColor = progressBarColor
    }

    func applyFonts(parent: Theme) {}
}

extension NavigationTheme {
    public init() {
        color = .darkGray
        progressBarColor = .darkGray
        buttonColor = .white
        buttonTextColor = .white
    }
}
