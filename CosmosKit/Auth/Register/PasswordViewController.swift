import Foundation

class PasswordViewController: UIViewController {

    var theme: Theme?
    var cosmos: Cosmos!
    var welcomeData: WelcomeData!

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var passwordInput: LoginTextField!
    @IBOutlet weak var confirmPassInput: LoginTextField!
    @IBOutlet weak var nextBtn: LoginButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordInput.delegate = self
        self.confirmPassInput.delegate = self

        if self.theme == nil {
            configure(cosmos.theme)
        }
        configureTranslations()
    }
    
    private func configureTranslations() {
        // do translations here
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        passwordInput.addBorder()
        confirmPassInput.addBorder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    @IBAction func onNextBtn(_ sender: Any) {
        if !isInputValid() {
            return
        }
        welcomeData.password = passwordInput.text
        
        performSegue(withIdentifier: "goNewsletter", sender: self)
    }

    func isInputValid() -> Bool {
        guard let password = passwordInput?.text, !password.isEmpty else {
            // TODO: translation needed
            Alerter.alert(translatedMessage: "You have entered an invalid password. Please try again.")
            return false
        }
        
        let newPassword = passwordInput?.text ?? ""
        if newPassword.count < 8 || newPassword.count > 20 {
            Alerter.alert(translatedMessage: "Password should be between 8 and 20 characters in length.")
            return false
        }

        if newPassword == newPassword.uppercased() {
            Alerter.alert(translatedMessage: "Password should contain at least one lower case character.")
            return false
        }
        
        guard let confirmedPassword = confirmPassInput.text, !confirmedPassword.isEmpty else {
            // TODO: translation needed
            Alerter.alert(translatedMessage: "You have entered an invalid password. Please try again.")
            return false
        }
        guard password == confirmedPassword else {
            // TODO: translation needed
            Alerter.alert(translatedMessage: "The entered passwords do not match. Please try again.")
            return false
        }
        return true
    }

    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goNewsletter") {
            let controller = segue.destination as! NewsletterRegisterViewController
            controller.cosmos = cosmos
            controller.welcomeData = welcomeData
        }
    }
}

extension PasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let versionTheme = theme ?? cosmos.theme
        guard let legacyTheme = versionTheme.legacyAuthTheme else { fatalError("No legacy theme provided") }
        textField.backgroundColor = legacyTheme.backgroundColor
        textField.subviews.forEach { $0.backgroundColor = legacyTheme.backgroundColor }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordInput {
            confirmPassInput.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension PasswordViewController: ThemeInjectable {
    func configure(_ theme: Theme) {
        self.theme = theme
        guard let legacyTheme = theme.legacyAuthTheme else { fatalError("No legacy theme provided") }

        view.backgroundColor = legacyTheme.backgroundColor
        logoView.image = legacyTheme.logo

        passwordInput.tintColor = theme.accentColor
        passwordInput.textColor = theme.textColor
        passwordInput.backgroundColor = legacyTheme.backgroundColor
        passwordInput.borderColor = theme.accentColor

        confirmPassInput.tintColor = theme.accentColor
        confirmPassInput.textColor = theme.textColor
        confirmPassInput.backgroundColor = legacyTheme.backgroundColor
        confirmPassInput.borderColor = theme.accentColor

        nextBtn.backgroundColor = theme.accentColor
        let color = legacyTheme.mainButtonColor ?? legacyTheme.backgroundColor
        nextBtn.setTitleColor(color, for: .normal)
        nextBtn.titleLabel?.font = legacyTheme.mainButtonFont
    }
}
