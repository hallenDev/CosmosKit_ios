import Foundation

public struct AuthorizationTheme: SubTheme {

    // swiftlint:disable:next line_length
    public init(primaryButtonFont: UIFont?, primaryButtonColor: UIColor, secondaryButtonFont: UIFont?, secondaryButtonColor: UIColor, headingFont: UIFont?, headingColor: UIColor, textFont: UIFont?, textColor: UIColor, textFieldDescriptorFont: UIFont?, textFieldDescriptorColor: UIColor, textFieldFont: UIFont?, textFieldColor: UIColor, textFieldBackgroundColor: UIColor, termsAndConditionsFont: UIFont?, termsAndConditionsTintFont: UIFont?, termsAndConditionsColor: UIColor, termsAndConditionsActive: UIImage, termsAndConditionsInactive: UIImage, newsletterFont: UIFont?, newsletterColor: UIColor, newsletterActiveTint: UIColor, newsletterInactiveTint: UIColor, newsletterSwitchBackground: UIColor, newsletterSwitchBorder: UIColor, backgroundColor: UIColor, logo: UIImage) {
        self.primaryButtonFont = primaryButtonFont
        self.primaryButtonColor = primaryButtonColor
        self.secondaryButtonFont = secondaryButtonFont
        self.secondaryButtonColor = secondaryButtonColor
        self.headingFont = headingFont
        self.headingColor = headingColor
        self.textFont = textFont
        self.textColor = textColor
        self.textFieldDescriptorFont = textFieldDescriptorFont
        self.textFieldDescriptorColor = textFieldDescriptorColor
        self.textFieldFont = textFieldFont
        self.textFieldColor = textFieldColor
        self.textFieldBackgroundColor = textFieldBackgroundColor
        self.termsAndConditionsFont = termsAndConditionsFont
        self.termsAndConditionsTintFont = termsAndConditionsTintFont
        self.termsAndConditionsColor = termsAndConditionsColor
        self.termsAndConditionsActive = termsAndConditionsActive
        self.termsAndConditionsInactive = termsAndConditionsInactive
        self.newsletterFont = newsletterFont
        self.newsletterColor = newsletterColor
        self.newsletterActiveTint = newsletterActiveTint
        self.newsletterInactiveTint = newsletterInactiveTint
        self.newsletterSwitchBackground = newsletterSwitchBackground
        self.newsletterSwitchBorder = newsletterSwitchBorder
        self.backgroundColor = backgroundColor
        self.logo = logo
    }

    // main action buttons
    let primaryButtonFont: UIFont?
    let primaryButtonColor: UIColor

    // linking buttons between the auth screens
    let secondaryButtonFont: UIFont?
    let secondaryButtonColor: UIColor

    // headings on information screens
    let headingFont: UIFont?
    let headingColor: UIColor

    // text snippets on auth themes
    let textFont: UIFont?
    let textColor: UIColor

    // text fields
    let textFieldDescriptorFont: UIFont?
    let textFieldDescriptorColor: UIColor
    let textFieldFont: UIFont?
    let textFieldColor: UIColor
    let textFieldBackgroundColor: UIColor

    // terms and conditions styled label
    let termsAndConditionsFont: UIFont?
    let termsAndConditionsTintFont: UIFont?
    let termsAndConditionsColor: UIColor
    let termsAndConditionsActive: UIImage
    let termsAndConditionsInactive: UIImage

    // newsletter checkboxes
    let newsletterFont: UIFont?
    let newsletterColor: UIColor
    let newsletterActiveTint: UIColor
    let newsletterInactiveTint: UIColor
    let newsletterSwitchBackground: UIColor
    let newsletterSwitchBorder: UIColor

    let backgroundColor: UIColor
    let logo: UIImage

    func applyColors(parent: Theme) {
        ProfileButton.appearance().tintColor = parent.accentColor
        AuthCloseButtonBackground.appearance().backgroundColor = parent.accentColor
    }

    func applyFonts(parent: Theme) {}
}

extension AuthorizationTheme {
    public init() {
        self.init(primaryButtonFont: UIFont(name: "HelveticaNeue", textStyle: .body),
                  primaryButtonColor: .black,
                  secondaryButtonFont: UIFont(name: "HelveticaNeue", textStyle: .body),
                  secondaryButtonColor: .black,
                  headingFont: UIFont(name: "HelveticaNeue", textStyle: .body),
                  headingColor: .black,
                  textFont: UIFont(name: "HelveticaNeue", textStyle: .body),
                  textColor: .black,
                  textFieldDescriptorFont: UIFont(name: "HelveticaNeue", textStyle: .body),
                  textFieldDescriptorColor: .black,
                  textFieldFont: UIFont(name: "HelveticaNeue", textStyle: .body),
                  textFieldColor: .black,
                  textFieldBackgroundColor: .black,
                  termsAndConditionsFont: UIFont(name: "HelveticaNeue", textStyle: .body),
                  termsAndConditionsTintFont: UIFont(name: "HelveticaNeue", textStyle: .body),
                  termsAndConditionsColor: .black,
                  termsAndConditionsActive: UIImage(),
                  termsAndConditionsInactive: UIImage(),
                  newsletterFont: UIFont(name: "HelveticaNeue", textStyle: .body),
                  newsletterColor: .black,
                  newsletterActiveTint: .red,
                  newsletterInactiveTint: .white,
                  newsletterSwitchBackground: .white,
                  newsletterSwitchBorder: .black,
                  backgroundColor: .white,
                  logo: UIImage())
    }
}
