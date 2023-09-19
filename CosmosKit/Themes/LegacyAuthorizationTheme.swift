import Foundation

public struct LegacyAuthorizationTheme: SubTheme {
    // swiftlint:disable:next line_length
    public init(mainButtonFont: UIFont?, mainButtonColor: UIColor?, secondaryButtonFont: UIFont?, textFont: UIFont?, textColor: UIColor, italicTextFont: UIFont?, italicTextColor: UIColor, termsAndConditionsFont: UIFont?, termsAndConditionsTintFont: UIFont?, termsAndConditionsColor: UIColor, backgroundColor: UIColor, logo: UIImage) {
        self.mainButtonFont = mainButtonFont
        self.mainButtonColor = mainButtonColor
        self.secondaryButtonFont = secondaryButtonFont
        self.textFont = textFont
        self.textColor = textColor
        self.italicTextFont = italicTextFont
        self.italicTextColor = italicTextColor
        self.termsAndConditionsFont = termsAndConditionsFont
        self.termsAndConditionsTintFont = termsAndConditionsTintFont
        self.termsAndConditionsColor = termsAndConditionsColor
        self.backgroundColor = backgroundColor
        self.logo = logo
    }

    // main action buttons
    let mainButtonFont: UIFont?
    let mainButtonColor: UIColor?

    // linking buttons between the auth screens
    let secondaryButtonFont: UIFont?

    // text snippets on auth themes
    let textFont: UIFont?
    let textColor: UIColor

    // italic bits of text on auth screens (for now using textcolor)
    let italicTextFont: UIFont?
    let italicTextColor: UIColor

    // terms and conditions styled label
    let termsAndConditionsFont: UIFont?
    let termsAndConditionsTintFont: UIFont?
    let termsAndConditionsColor: UIColor

    let backgroundColor: UIColor
    let logo: UIImage

    func applyColors(parent: Theme) {
        LoginItalicBodyLabel.appearance().textColor = italicTextColor
        LoginBodyLabel.appearance().textColor = textColor
        LoginButton.appearance().backgroundColor = parent.accentColor
        LoginLinkButton.appearance().tintColor = parent.accentColor
        LoginTextView.appearance().tintColor = parent.accentColor
        LoginTextView.appearance().backgroundColor = parent.navigationTheme.color
        LoginTextField.appearance().tintColor = parent.accentColor
        LoginTextField.appearance().textColor = parent.textColor
        LoginTextField.appearance().backgroundColor = parent.navigationTheme.color
        LoginTextField.appearance().borderColor = parent.accentColor
        ProfileButton.appearance().tintColor = parent.accentColor
    }

    func applyFonts(parent: Theme) {
        LoginTextField.appearance().font = textFont
        LoginItalicBodyLabel.appearance().font = italicTextFont
        LoginBodyLabel.appearance().font = textFont
    }
}

extension LegacyAuthorizationTheme {
    public init() {
        self.init(mainButtonFont: UIFont(name: "HelveticaNeue", textStyle: .body),
                  mainButtonColor: .white,
                  secondaryButtonFont: UIFont(name: "HelveticaNeue", textStyle: .footnote),
                  textFont: UIFont(name: "HelveticaNeue", textStyle: .body),
                  textColor: .black,
                  italicTextFont: UIFont(name: "HelveticaNeue-Italic", textStyle: .footnote),
                  italicTextColor: .black,
                  termsAndConditionsFont: UIFont(name: "HelveticaNeue", textStyle: .footnote),
                  termsAndConditionsTintFont: UIFont(name: "HelveticaNeue-Bold", textStyle: .footnote),
                  termsAndConditionsColor: .black,
                  backgroundColor: .white,
                  logo: UIImage())
    }
}
