import UIKit
import CryptoKit
import CommonCrypto

class LegacyRegisterViewController: UIViewController, ContainerSwappable, UITextViewDelegate {

    var didFinish: (() -> Void)?
    var swap: ((UIViewController) -> Void)?
    var theme: Theme?
    var cosmos: Cosmos!

    @IBOutlet var signInButton: LoginLinkButton!
    @IBOutlet var logoView: UIImageView!
    @IBOutlet var pleaseNoteLabel: LoginBodyLabel!
    @IBOutlet var alreadyRegisteredLabel: LoginBodyLabel!
    @IBOutlet var useEmailLabel: LoginBodyLabel!
    @IBOutlet var signInStackView: UIStackView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var email: LoginTextField!
    @IBOutlet var registerButton: LoginButton!
    @IBOutlet var linkingTextView: LoginTextView!
    @IBOutlet var loginSegueLabel: LoginItalicBodyLabel!

    @IBAction func register(_ sender: Any) {
        guard let username = email.text,
              isEmailValid(username)
        else {
            let error = LanguageManager.shared.translate(key: .errorInvalidEmailTryAgain)
            Alerter.alert(translatedMessage: error)
            return
        }
        showActivity(busy: true)
        cosmos.register(username: username) { error in
            DispatchQueue.main.async {
                self.showActivity(busy: false)
                if let error = error {
                    Alerter.alert(error: error, context: .register)
                } else {
//                    let emailSent = LanguageManager.shared.translate(key: .verifyEmailSent)
//                    Alerter.alert(translatedMessage: emailSent)
                    self.login(username: username)
                }
            }
        }
    }
    
    func login (username: String) {
        let data = "\(cosmos.apiConfig.publication.consumerSecret)\(username.lowercased())"
        let tempPassword = data.data(using: .ascii)!.sha1
        
        print(data)
        print(tempPassword)
        
        showActivity(busy: true)
        cosmos.login(username: username, password: tempPassword) { error in
            DispatchQueue.main.async {
                self.showActivity(busy: false)
                if let error = error {
                    Alerter.alert(error: error, context: .login)
                } else {
                    self.cosmos.clearLocalStorage()
                    self.dismiss(animated: true, completion: nil)
                    
                    let welcome: WelcomeNavController = self.cosmos.getWelcomeView()
                    welcome.modalPresentationStyle = .fullScreen
                    self.present(welcome, animated: true, completion: nil)
                }
            }
        }
    }

    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        didFinish?()
        super.dismiss(animated: flag, completion: completion)
    }

    func showActivity(busy: Bool) {
        if busy {
            activityIndicator.startAnimating()
            registerButton.setTitle(nil, for: .normal)
        } else {
            activityIndicator.stopAnimating()
            let btnTitle = LanguageManager.shared.translateUppercased(key: .register)
            registerButton.setTitle(btnTitle, for: .normal)
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        email.addBorder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLinkText()
        email.delegate = self
        configureTranslations()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cosmos.logger?.log(event: CosmosEvents.register)
    }

    fileprivate func configureTranslations() {
        email.placeholder = LanguageManager.shared.translate(key: .emailAddress)
        if let registerAuthReplace = cosmos.publication.authConfig?.registerAuthBlock {
            pleaseNoteLabel.text = registerAuthReplace
        } else {
            pleaseNoteLabel.text = LanguageManager.shared.translate(key: .registerText1)
        }
        if let registerReplace = cosmos.publication.authConfig?.registerOptions {
            alreadyRegisteredLabel.text = registerReplace
        } else {
            alreadyRegisteredLabel.text = LanguageManager.shared.translate(key: .registerText2)
        }
        if let registerInstructions = cosmos.publication.authConfig?.registerInstructions {
            useEmailLabel.text = registerInstructions
        } else {
            useEmailLabel.text = LanguageManager.shared.translate(key: .registerText3)
        }
        if let signInSegueText = cosmos.publication.authConfig?.registerToSignInText {
            loginSegueLabel.text = signInSegueText
        } else {
            loginSegueLabel.text = LanguageManager.shared.translate(key: .registerText4)
        }
        registerButton.setTitle(LanguageManager.shared.translateUppercased(key: .register), for: .normal)
        signInButton.setTitle(LanguageManager.shared.translateUppercased(key: .signIn), for: .normal)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        swap?(segue.destination)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func configureLinkText() {
        let theme = self.theme ?? cosmos.theme
        guard let legacyTheme = theme.legacyAuthTheme else { fatalError("No legacy theme provided") }
        let textColor = legacyTheme.termsAndConditionsColor
        let style = NSMutableParagraphStyle()
        style.alignment = .center

        let dict: [NSAttributedString.Key: Any] = [
            .foregroundColor: textColor,
            .paragraphStyle: style
        ]

        let tandcText = LanguageManager.shared.translate(key: .termsAndConditionsLowercase)
        let privacyPolicyText = LanguageManager.shared.translate(key: .privacyPolicyLowercase)
        let termsPrefix = LanguageManager.shared.translate(key: .termsPart1)
        let and = LanguageManager.shared.translate(key: .and)
        let descriptionText = String(format: "%@ %@ %@ %@",
                                     termsPrefix,
                                     tandcText,
                                     and,
                                     privacyPolicyText)

        let attributedString = NSMutableAttributedString(string: descriptionText, attributes: dict)

        let range = descriptionText.startIndex..<descriptionText.endIndex
        descriptionText.enumerateSubstrings(in: range) { substring, substringRange, _, _ in
            if substring == tandcText || substring == privacyPolicyText {
                attributedString.addAttribute(.font,
                                              value: legacyTheme.termsAndConditionsTintFont as Any,
                                              range: NSRange(substringRange, in: descriptionText))
            } else {
                attributedString.addAttribute(.font,
                                              value: legacyTheme.termsAndConditionsFont as Any,
                                              range: NSRange(substringRange, in: descriptionText))
            }
        }

        let tandcURL = cosmos.settingsConfig.termsSlug
        let ppURL = cosmos.settingsConfig.privacySlug

        attributedString.setLink(on: tandcText, with: tandcURL)
        attributedString.setLink(on: privacyPolicyText, with: ppURL)

        linkingTextView.attributedText = attributedString
        linkingTextView.delegate = self
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        showPushedArticle(slug: URL.absoluteString)
        return true
    }

    func showPushedArticle(slug: String) {
        let article = ArticleViewModel(slug: slug, as: .staticPage)
        let nav = cosmos.getSingleArticleView(for: article)
        nav.modalPresentationStyle = .fullScreen
        UIApplication.shared.topViewController()?.present(nav, animated: true, completion: nil)
    }
}

extension LegacyRegisterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let versionTheme = theme ?? cosmos.theme
        guard let legacyTheme = versionTheme.legacyAuthTheme else { fatalError("No legacy theme provided") }
        textField.backgroundColor = legacyTheme.backgroundColor
        textField.subviews.forEach { $0.backgroundColor = legacyTheme.backgroundColor }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LegacyRegisterViewController: ThemeInjectable {
    func configure(_ theme: Theme) {
        self.theme = theme
        guard let legacyTheme = theme.legacyAuthTheme else { fatalError("No legacy theme provided") }

        view.backgroundColor = legacyTheme.backgroundColor
        logoView.image = legacyTheme.logo
        for view in signInStackView.arrangedSubviews {
            view.tintColor = theme.accentColor
        }

        email.tintColor = theme.accentColor
        email.textColor = theme.textColor
        email.backgroundColor = legacyTheme.backgroundColor
        email.borderColor = theme.accentColor

        pleaseNoteLabel.tintColor = theme.accentColor
        pleaseNoteLabel.textColor = legacyTheme.textColor
        pleaseNoteLabel.font = legacyTheme.textFont

        alreadyRegisteredLabel.tintColor = theme.accentColor
        alreadyRegisteredLabel.textColor = legacyTheme.textColor
        alreadyRegisteredLabel.font = legacyTheme.textFont

        useEmailLabel.tintColor = theme.accentColor
        useEmailLabel.textColor = legacyTheme.textColor
        useEmailLabel.font = legacyTheme.textFont

        registerButton.backgroundColor = theme.accentColor
        registerButton.titleLabel?.font = legacyTheme.mainButtonFont
        let color = legacyTheme.mainButtonColor ?? legacyTheme.backgroundColor
        registerButton.setTitleColor(color, for: .normal)

        signInButton.setTitleColor(theme.accentColor, for: .normal)
        signInButton.titleLabel?.font = legacyTheme.secondaryButtonFont

        linkingTextView.backgroundColor = legacyTheme.backgroundColor
        linkingTextView.tintColor = theme.accentColor

        loginSegueLabel.textColor = legacyTheme.italicTextColor
        loginSegueLabel.font = legacyTheme.italicTextFont
    }
}

extension NSMutableAttributedString {
    public func setLink(on text: String, with url: String) {
        let foundRange = self.mutableString.range(of: text)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: url, range: foundRange)
        }
    }
}


extension Data {
    public var sha1: String {
        if #available(iOS 13.0, *) {
            return hexString(Insecure.SHA1.hash(data: self).makeIterator())
        } else {
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
            self.withUnsafeBytes { bytes in
                _ = CC_SHA1(bytes.baseAddress, CC_LONG(self.count), &digest)
            }
            return hexString(digest.makeIterator())
        }
    }
    
    func hexString(_ iterator: Array<UInt8>.Iterator) -> String {
        return iterator.map { String(format: "%02x", $0) }.joined()
    }
}
