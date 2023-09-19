// swiftlint:disable type_name identifier_name
import UIKit

public class LanguageManager {

    ///
    /// The singleton LanguageManager instance.
    ///
    public static let shared: LanguageManager = LanguageManager()
    public let translationNotFound = "kLocalizedStringNotFound"

    ///
    /// The current language.
    ///
    public var currentLanguage: Languages {
        get {
            if let currentLang = UserDefaults.standard.string(forKey: Constants.defaultsKeys.selectedLanguage) {
                return Languages(rawValue: currentLang)!
            } else {
                LanguageManager.shared.defaultLanguage = .en
                return Languages(rawValue: Languages.en.rawValue)!
            }
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Constants.defaultsKeys.selectedLanguage)
        }
    }

    ///
    /// The default language that the app will run first time.
    /// You need to set the `defaultLanguage` in the `AppDelegate`, specifically in
    /// the first line inside `application(_:willFinishLaunchingWithOptions:)`.
    ///
    public var defaultLanguage: Languages {
        get {
            guard let defaultLanguage = UserDefaults.standard.string(forKey: Constants.defaultsKeys.defaultLanguage) else {
                fatalError("Did you set the default language for the app?")
            }
            return Languages(rawValue: defaultLanguage)!
        }
        set {
            let defaultLanguage = UserDefaults.standard.string(forKey: Constants.defaultsKeys.defaultLanguage)
            guard defaultLanguage == nil else {
                setLanguage(language: currentLanguage)
                return
            }

            var language = newValue
            if language == .deviceLanguage {
                language = deviceLanguage ?? .en
            }

            UserDefaults.standard.set(language.rawValue, forKey: Constants.defaultsKeys.defaultLanguage)
            UserDefaults.standard.set(language.rawValue, forKey: Constants.defaultsKeys.selectedLanguage)
            setLanguage(language: language)
        }
    }

    ///
    /// The device language is different than the app language,
    /// to get the app language use `currentLanguage`.
    ///
    public var deviceLanguage: Languages? {
        get {
            guard let deviceLanguage = Bundle.main.preferredLocalizations.first else {
                return nil
            }
            return Languages(rawValue: deviceLanguage)
        }
    }

    /// The diriction of the language.
    public var isRightToLeft: Bool {
        get {
            return isLanguageRightToLeft(language: currentLanguage)
        }
    }

    /// The app locale to use it in dates and currency.
    public var appLocale: Locale {
        get {
            return Locale(identifier: currentLanguage.rawValue)
        }
    }

    ///
    /// Set the current language of the app
    ///
    /// - parameter language: The language that you need the app to run with.
    /// - parameter rootViewController: The new view controller to show after changing the language.
    /// - parameter animation: A closure with the current view to animate to the new view controller,
    ///                        so you need to animate the view, move it out of the screen, change the alpha,
    ///                        or scale it down to zero.
    ///
    public func setLanguage(language: Languages, rootViewController: UIViewController? = nil, animation: ((UIView) -> Void)? = nil) {

        // change the direction of the views
        let semanticContentAttribute: UISemanticContentAttribute =
            isLanguageRightToLeft(language: language) ? .forceRightToLeft : .forceLeftToRight
        UIView.appearance().semanticContentAttribute = semanticContentAttribute

        // set current language
        currentLanguage = language

        guard let rootViewController = rootViewController else { return }

        let snapshot = (UIApplication.shared.keyWindow?.snapshotView(afterScreenUpdates: true))!
        rootViewController.view.addSubview(snapshot)

        UIApplication.shared.delegate?.window??.rootViewController = rootViewController

        UIView.animate(withDuration: 0.5, animations: {
            animation?(snapshot)
        }) { _ in
            snapshot.removeFromSuperview()
        }
    }

    private func isLanguageRightToLeft(language: Languages) -> Bool {
        return Locale.characterDirection(forLanguage: language.rawValue) == .rightToLeft
    }

    public func translate(key: String, returnOriginal: Bool = true, overrideLanguage: Languages? = nil) -> String {
        self.translate(source: key, returnOriginal: returnOriginal, overrideLanguage: overrideLanguage)
    }

    public func translateUppercased(key: String, returnOriginal: Bool = true, overrideLanguage: Languages? = nil) -> String {
        self.translate(source: key, returnOriginal: returnOriginal, overrideLanguage: overrideLanguage).localizedUppercase
    }

    public func translate(key: TranslationKeys, returnOriginal: Bool = true, overrideLanguage: Languages? = nil) -> String {
        self.translate(source: key.rawValue, returnOriginal: returnOriginal, overrideLanguage: overrideLanguage)
    }

    public func translateUppercased(key: TranslationKeys, returnOriginal: Bool = true, overrideLanguage: Languages? = nil) -> String {
        self.translate(source: key.rawValue, returnOriginal: returnOriginal, overrideLanguage: overrideLanguage).localizedUppercase
    }

    ///
    /// Localize the current string to the selected language
    ///
    /// - returns: The localized string
    ///
    private func translate(source: String, comment: String = "", returnOriginal: Bool, overrideLanguage: Languages?) -> String {
        let kLocalizedStringNotFound = translationNotFound
        let language = overrideLanguage?.rawValue ?? LanguageManager.shared.currentLanguage.rawValue
        guard let cosmosBundlePath = Bundle.cosmos.path(forResource: language, ofType: "lproj"),
              let cosmosBundle = Bundle(path: cosmosBundlePath) else {
            return NSLocalizedString(returnOriginal ? source : kLocalizedStringNotFound, comment: comment)
        }

        var string = kLocalizedStringNotFound

        if let mainBundlePath = Bundle.main.path(forResource: language, ofType: "lproj"),
           let mainBundle = Bundle(path: mainBundlePath) {
            string = NSLocalizedString(source, tableName: nil, bundle: mainBundle, value: kLocalizedStringNotFound, comment: comment)
        }

        if string == kLocalizedStringNotFound {
            string = NSLocalizedString(source, tableName: nil, bundle: cosmosBundle, value: kLocalizedStringNotFound, comment: comment)
        }

        // Means the string was not found in cosmos' strings nor in the app's strings
        if string == kLocalizedStringNotFound {
            print("🚨 No localized string for '\(source)' 🚨")
            return NSLocalizedString(returnOriginal ? source : kLocalizedStringNotFound, comment: comment)
        } else {
            return string
        }
    }
}

// MARK: - Languages

public enum Languages: String {
    case ar, en, nl, ja, ko, vi, ru, sv, fr, es, pt, it, de, da, fi, nb, tr, el, id,
    ms, th, hi, hu, pl, cs, sk, uk, hr, ca, ro, he, ur, fa, ku, arc, sl, ml
    case enGB = "en-GB"
    case enAU = "en-AU"
    case enCA = "en-CA"
    case enIN = "en-IN"
    case frCA = "fr-CA"
    case esMX = "es-MX"
    case ptBR = "pt-BR"
    case zhHans = "zh-Hans"
    case zhHant = "zh-Hant"
    case zhHK = "zh-HK"
    case es419 = "es-419"
    case ptPT = "pt-PT"
    case afZA = "af-ZA"
    case deviceLanguage
}

// MARK: - ImageDirection

public enum ImageDirection: Int {
    case fixed, leftToRight, rightToLeft
}

private extension UIView {
    ///
    /// Change the direction of the image depeneding in the language, there is no return value for this variable.
    /// The expectid values:
    ///
    /// -`fixed`: if the image must not change the direction depending on the language you need to set the value as 0.
    ///
    /// -`leftToRight`: if the image must change the direction depending on the language
    /// and the image is left to right image then you need to set the value as 1.
    ///
    /// -`rightToLeft`: if the image must change the direction depending on the language
    /// and the image is right to left image then you need to set the value as 2.
    ///
    var direction: ImageDirection {
        get {
            // swiftlint:disable:next line_length
            fatalError("There is no value return from this variable, this variable used to change the image direction depending on the langauge")
        }
        set {
            switch newValue {
            case .fixed:
                break
            case .leftToRight where LanguageManager.shared.isRightToLeft:
                transform = CGAffineTransform(scaleX: -1, y: 1)
            case .rightToLeft where !LanguageManager.shared.isRightToLeft:
                transform = CGAffineTransform(scaleX: -1, y: 1)
            default:
                break
            }
        }
    }
}

public extension UIImageView {
    var imageDirection: Int {
        get {
            return direction.rawValue
        }
        set {
            direction = ImageDirection(rawValue: newValue)!
        }
    }
}

public extension UIButton {
    var imageDirection: Int {
        get {
            return direction.rawValue
        }
        set {
            direction = ImageDirection(rawValue: newValue)!
        }
    }
}

// MARK: - Constants

private enum Constants {

    enum defaultsKeys {
        static let selectedLanguage = "LanguageManagerSelectedLanguage"
        static let defaultLanguage = "LanguageManagerDefaultLanguage"
    }

    enum strings {
        static let unlocalized = "<unlocalized>"
    }
}
