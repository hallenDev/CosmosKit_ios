import UIKit

class LegacySigninViewController: UIViewController, ContainerSwappable {

    var didFinish: (() -> Void)?
    var swap: ((UIViewController) -> Void)?
    var theme: Theme?
    var cosmos: Cosmos!

    @IBOutlet var forgotPwdButton: LoginLinkButton!
    @IBOutlet var registerButton: LoginLinkButton!
    @IBOutlet var logoView: UIImageView!
    @IBOutlet var alreadyRegisteredLabel: LoginBodyLabel!
    @IBOutlet var registerStackView: UIStackView!
    @IBOutlet var forgotPasswordStackView: UIStackView!
    @IBOutlet var email: LoginTextField!
    @IBOutlet var password: LoginTextField!
    @IBOutlet var loginBTN: LoginButton!
    @IBOutlet var dontHaveAnAccountLabel: LoginItalicBodyLabel!
    @IBOutlet var forgotYourLabel: LoginItalicBodyLabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        password.delegate = self
        if self.theme == nil {
            configure(cosmos.theme)
        }
        configureTranslations()
    }

    private func configureTranslations() {
        if let signInReplacement = cosmos.publication.authConfig?.signInOptions {
            alreadyRegisteredLabel.text = signInReplacement
        } else {
            alreadyRegisteredLabel.text = LanguageManager.shared.translate(key: .registerText2)
        }
        email.placeholder = LanguageManager.shared.translate(key: .emailAddress)
        password.placeholder = LanguageManager.shared.translate(key: .password)
        loginBTN.setTitle(LanguageManager.shared.translateUppercased(key: .signIn), for: .normal)
        registerButton.setTitle(LanguageManager.shared.translateUppercased(key: .register), for: .normal)
        dontHaveAnAccountLabel.text = LanguageManager.shared.translate(key: .loginText2)
        forgotYourLabel.text = LanguageManager.shared.translate(key: .loginText3)
        forgotPwdButton.setTitle(LanguageManager.shared.translate(key: .loginText4), for: .normal)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        email.addBorder()
        password.addBorder()
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        didFinish?()
        super.dismiss(animated: flag, completion: completion)
    }

    @IBAction func login(_ sender: LoginButton) {
        guard let email = email.text,
            isEmailValid(email),
            let password = password.text,
            !password.isEmpty
            else {
            let error = LanguageManager.shared.translate(key: .errorIncorrectEmailOrPassword)
                Alerter.alert(translatedMessage: error)
                return
        }
        self.showActivity(busy: true)
        cosmos.login(username: email, password: password) { error in
            DispatchQueue.main.async {
                self.showActivity(busy: false)
                if let error = error {
                    Alerter.alert(error: error, context: .login)
                } else {
                    self.cosmos.clearLocalStorage()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    func showActivity(busy: Bool) {
        if busy {
            activityIndicator.startAnimating()
            loginBTN.setTitle(nil, for: .normal)
        } else {
            activityIndicator.stopAnimating()
            let btnTitle = LanguageManager.shared.translateUppercased(key: .signIn)
            loginBTN.setTitle(btnTitle, for: .normal)
        }
   }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cosmos.logger?.log(event: CosmosEvents.signIn)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResetPassword" {
            let password = segue.destination as? LegacyForgotPasswordViewController
            password?.resetEmail = cosmos.user?.email
        }
        swap?(segue.destination)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension LegacySigninViewController: UITextFieldDelegate {
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

extension LegacySigninViewController: ThemeInjectable {
    func configure(_ theme: Theme) {
        self.theme = theme
        guard let legacyTheme = theme.legacyAuthTheme else { fatalError("No legacy theme provided") }

        view.backgroundColor = legacyTheme.backgroundColor
        logoView.image = legacyTheme.logo

        email.tintColor = theme.accentColor
        email.textColor = theme.textColor
        email.backgroundColor = legacyTheme.backgroundColor
        email.borderColor = theme.accentColor

        password.tintColor = theme.accentColor
        password.textColor = theme.textColor
        password.backgroundColor = legacyTheme.backgroundColor
        password.borderColor = theme.accentColor

        for view in registerStackView.arrangedSubviews {
            view.tintColor = theme.accentColor
        }
        for view in forgotPasswordStackView.arrangedSubviews {
            view.tintColor = theme.accentColor
        }

        alreadyRegisteredLabel.tintColor = theme.accentColor
        alreadyRegisteredLabel.textColor = legacyTheme.textColor
        alreadyRegisteredLabel.font = legacyTheme.textFont

        loginBTN.backgroundColor = theme.accentColor
        let color = legacyTheme.mainButtonColor ?? legacyTheme.backgroundColor
        loginBTN.setTitleColor(color, for: .normal)
        loginBTN.titleLabel?.font = legacyTheme.mainButtonFont

        registerButton.setTitleColor(theme.accentColor, for: .normal)
        registerButton.titleLabel?.font = legacyTheme.secondaryButtonFont

        forgotPwdButton.setTitleColor(theme.accentColor, for: .normal)
        forgotPwdButton.titleLabel?.font = legacyTheme.secondaryButtonFont
    }
}
