import Foundation

public struct ViewHeaderTheme: SubTheme {
    public init(style: HeaderStyle, titleColor: UIColor, titleFont: UIFont?, backgroundColor: UIColor) {
        self.style = style
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.backgroundColor = backgroundColor
    }

    let style: HeaderStyle
    let titleColor: UIColor
    let titleFont: UIFont?
    let backgroundColor: UIColor

    func applyColors(parent: Theme) {
        HeaderLabel.appearance().textColor = titleColor
    }

    func applyFonts(parent: Theme) {
        HeaderLabel.appearance().font = titleFont!
    }
}

extension ViewHeaderTheme {
    public init() {
        style = .compressed
        titleColor = .white
        titleFont = UIFont(name: "HelveticaNeue", textStyle: .body)
        backgroundColor = .black
    }
}
