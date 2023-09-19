import Foundation

public struct FallbackTheme: SubTheme {
    public init(titleColor: UIColor, titleFont: UIFont?, bodyColor: UIColor, bodyFont: UIFont?) {
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.bodyColor = bodyColor
        self.bodyFont = bodyFont
    }

    let titleColor: UIColor
    let titleFont: UIFont?
    let bodyColor: UIColor
    let bodyFont: UIFont?

    func applyColors(parent: Theme) {
        FallbackViewTitleLabel.appearance().textColor = titleColor
        FallbackViewInfoLabel.appearance().textColor = bodyColor
    }

    func applyFonts(parent: Theme) {
        FallbackViewTitleLabel.appearance().font = titleFont!
        FallbackViewInfoLabel.appearance().font = bodyFont!
    }
}

extension FallbackTheme {
    public init() {
        self.titleColor = .black
        self.titleFont = UIFont(name: "HelveticaNeue", textStyle: .body)
        self.bodyColor = .black
        self.bodyFont = UIFont(name: "HelveticaNeue", textStyle: .body)
    }
}
