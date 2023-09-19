import Foundation

public struct LoadingIndicatorConfig {
    let lightModeAnimation: String
    let darkModeAnimation: String?
    let scale: CGFloat
    let backgroundColor: UIColor
    let cornerRadius: CGFloat
    let rounded: Bool

    // swiftlint:disable:next line_length
    public init(lightMode animationLM: String, darkMode animationDM: String? = nil, scale: CGFloat = 0.3, backgroundColor: UIColor = .clear, cornerRadius: CGFloat = 0, rounded: Bool = false) {
        self.lightModeAnimation = animationLM
        self.darkModeAnimation = animationDM
        self.scale = scale
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.rounded = rounded
    }
}
