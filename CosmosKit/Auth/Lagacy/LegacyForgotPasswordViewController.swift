import UIKit

class LegacyForgotPasswordViewController: UIViewController, ContainerSwappable {

    var didFinish: (() -> Void)?
    var swap: ((UIViewController) -> Void)?
    var resetEmail: String?
    var theme: Theme?
    var cosmos: Cosmos!

    @IBOutlet var logoView: UIImageView!
    @IBOutlet var signInButton: LoginLinkButton!
    @IBOutlet var emailInstructionLabel: LoginBodyLabel!
    @IBOutlet var forgotButton: LoginButton!
    @IBOutlet var email: LoginTextField!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var signin: UIStackView!
    @IBOutlet var returnToLabel: LoginItalicBodyLabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        if let resetEmail = resetEmail {
            email.text = resetEmail
            signin.isHidden = true
        }
        configureTranslations()
    }

    private func configureTranslations() {
        if let emailInstructions = cosmos.publication.authConfig?.forgotPasswordEmailInstructions {
            emailInstructionLabel.text = emailInstructions
        } else {
            emailInstructionLabel.text = LanguageManager.shared.translate(key: .forgotPwdText1)
        }
        email.placeholder = LanguageManager.shared.translate(key: .emailAddress)
        forgotButton.setTitle(LanguageManager.shared.translateUppercased(key: .resetMyPassword), for: .normal)
        returnToLabel.text = LanguageManager.shared.translate(key: .forgotPwdText2)
        signInButton.setTitle(LanguageManager.shared.translateUppercased(key: .signIn), for: .normal)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        email.addBorder()
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        didFinish?()
        super.dismiss(animated: flag, completion: completion)
    }

    @IBAction func resetPassword(_ sender: Any) {
        guard let username = email.text,
            isEmailValid(username)
            else {
            let error = LanguageManager.shared.translate(key: .errorInvalidEmailTryAgain)
            Alerter.alert(translatedMessage: error)
                return
        }
        showActivity(busy: true)
        cosmos.resetPassword(username: username) { error in
            DispatchQueue.main.async {
                if let error = error {
                    Alerter.alert(error: error, context: .reset)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
                self.showActivity(busy: false)
            }
        }
    }

    func showActivity(busy: Bool) {
        if busy {
            activityIndicator.startAnimating()
            forgotButton.setTitle(nil, for: .normal)
        } else {
            activityIndicator.stopAnimating()
            let btnTitle = LanguageManager.shared.translateUppercased(key: .resetMyPassword)
            forgotButton.setTitle(btnTitle, for: .normal)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cosmos.logger?.log(event: CosmosEvents.forgotPassword)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        swap?(segue.destination)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension LegacyForgotPasswordViewController: UITextFieldDelegate {
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

extension LegacyForgotPasswordViewController: ThemeInjectable {
    func configure(_ theme: Theme) {
        self.theme = theme
        guard let legacyTheme = theme.legacyAuthTheme else { fatalError("No legacy theme provided") }

        view.backgroundColor = legacyTheme.backgroundColor
        logoView.image = legacyTheme.logo
        for view in signin.arrangedSubviews {
            view.tintColor = theme.accentColor
        }
        email.tintColor = theme.accentColor
        email.textColor = theme.textColor
        email.backgroundColor = legacyTheme.backgroundColor
        email.borderColor = theme.accentColor

        emailInstructionLabel.tintColor = theme.accentColor
        emailInstructionLabel.textColor = legacyTheme.textColor
        emailInstructionLabel.font = legacyTheme.textFont

        forgotButton.backgroundColor = theme.accentColor
        let color = legacyTheme.mainButtonColor ?? legacyTheme.backgroundColor
        forgotButton.setTitleColor(color, for: .normal)
        forgotButton.titleLabel?.font = legacyTheme.mainButtonFont

        signInButton.setTitleColor(theme.accentColor, for: .normal)
        signInButton.titleLabel?.font = legacyTheme.secondaryButtonFont
    }
}
