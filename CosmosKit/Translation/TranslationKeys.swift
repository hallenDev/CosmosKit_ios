// swiftlint:disable identifier_name
import Foundation

public enum TranslationKeys: String, CaseIterable {
    // MARK: Errors
    case errorIncorrectEmailOrPasswordTryRegisterReset
    case errorIncorrectEmailTryRegister
    case errorIncorrectEmailOrPassword
    case errorInvalidEmailOrPassword
    case errorInvalidEmail
    case errorInvalidEmailTryAgain
    case errorNetwork
    case errorGeneric
    case errorActivationRequired
    case errorAccountTaken

    // MARK: Other
    case minutesRead
    case byWithSpace
    case and
    case textSizeExample
    case imageMissing
    case imageNotAvailable
    case verifyEmailSent
    case termsAndConditionsLowercase
    case privacyPolicyLowercase
    case termsPart1
    case articles
    case pastEditionsCleared
    case enterSearchTerm
    case turnOnAlerts
    case registerText1
    case registerText2
    case registerText3
    case registerText4
    case loginText2
    case loginText3
    case loginText4
    case forgotPwdText1
    case forgotPwdText2

    // MARK: Widgets
    case widgetTwitter
    case widgetWebContent
    case widgetGoogleMap
    case widgetPodcast
    case widgetCrossword
    case widgetContent
    case playPuzzle

    // MARK: Titles/Commands/Button Titles
    case deleteAccount
    case logout
    case name
    case surname
    case email
    case emailAddress
    case password
    case noResult
    case noResultTryAgain
    case ok
    case yes
    case no
    case readEdition
    case resetMyPassword
    case resetPassword
    case forgotPassword
    case register
    case signIn
    case profile
    case pushNotifications
    case manageNotifications
    case manageNewsletters
    case reviewApp
    case clearAllEditions
    case aboutUs
    case about
    case contactUs
    case aboutAndContactUs
    case termsOfService
    case privacyPolicyCapitalised
    case appVersion
    case fontSettings
    case success
    case account
    case general
    case specialReport
    case cancel
    case preview
    case articleTextSize
    case done
    case reload

    // MARK: View Headings
    case headingBookmarks
    case headingSections
    case headingPastEditions
    case headingAuthors
    case headingSettings
}
