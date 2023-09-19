import Foundation

public struct SettingsTheme: SubTheme {
    // swiftlint:disable:next line_length
    public init(titleFont: UIFont?, titleColor: UIColor, settingFont: UIFont?, settingColor: UIColor, fontLabelFont: UIFont?, fontIndicatorFont: String) {
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.settingFont = settingFont
        self.settingColor = settingColor
        self.fontLabelFont = fontLabelFont
        self.fontIndicatorFont = fontIndicatorFont
    }

    let titleFont: UIFont?
    let titleColor: UIColor
    let settingFont: UIFont?
    let settingColor: UIColor
    let fontLabelFont: UIFont?
    let fontIndicatorFont: String

    func applyColors(parent: Theme) {
        SettingsSectionLabel.appearance().textColor = titleColor
        SettingsCellLabel.appearance().textColor = settingColor
        SmallFontIndicatorLabel.appearance().textColor = parent.textColor
        LargeFontIndicatorLabel.appearance().textColor = parent.textColor
        FontDetailLabel.appearance().textColor = parent.textColor
    }

    func applyFonts(parent: Theme) {
        SettingsSectionLabel.appearance().font = titleFont!
        SettingsCellLabel.appearance().font = settingFont!
        SmallFontIndicatorLabel.appearance().font = UIFont(name: fontIndicatorFont, textStyle: .subheadline)
        LargeFontIndicatorLabel.appearance().font = UIFont(name: fontIndicatorFont, textStyle: .title1)
        FontDetailLabel.appearance().font = fontLabelFont
    }
}

extension SettingsTheme {
    public init() {
        self.titleFont = UIFont(name: "HelveticaNeue-Bold", textStyle: .subheadline)
        self.titleColor = .gray
        self.settingFont = UIFont(name: "HelveticaNeue", textStyle: .body)
        self.settingColor = .black
        self.fontIndicatorFont = "HelveticaNeue-Bold"
        self.fontLabelFont = UIFont(name: "HelveticaNeue", textStyle: .body)
    }
}
