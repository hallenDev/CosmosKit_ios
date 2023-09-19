import Foundation

public class InformationViewController: UIViewController {

    var theme: Theme?
    var cosmos: Cosmos!

    @IBOutlet weak var firstNameInput: LoginTextField!
    @IBOutlet weak var lastNameInput: LoginTextField!
    @IBOutlet weak var contactNumberInput: LoginTextField!
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var nextBtn: LoginButton!
    @IBOutlet weak var scrollView: UIScrollView!

    var keyboardHeight: CGFloat = 0

    struct Config {
        static let keyboardOffset: CGFloat = 44 + 32 // Button height + button bottom offset
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        firstNameInput.delegate = self
        lastNameInput.delegate = self
        contactNumberInput.delegate = self

        if self.theme == nil {
            configure(cosmos.theme)
        }
        configureTranslations()
    }

    private func configureTranslations() {
        // do translations here
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        firstNameInput.addBorder()
        lastNameInput.addBorder()
        contactNumberInput.addBorder()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // TODO: analytics
    }

    private func configureKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow(notification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc func switchTextField(_ sender: Any) {
        guard let activeField = sender as? WelcomeTextField else { return }
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight + Config.keyboardOffset, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        let activeRect = activeField.convert(activeField.bounds, to: scrollView)
        scrollView.scrollRectToVisible(activeRect, animated: true)
    }

    @objc func keyboardDidShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        keyboardHeight = keyboardSize.height - view.safeAreaInsets.bottom
    }

    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @IBAction func onNextBtn(_ sender: Any) {
        if !isInputValid() {
            return
        }

        performSegue(withIdentifier: "goPassword", sender: self)
        
    }

    func isInputValid() -> Bool {
        guard let firstName = firstNameInput.text, !firstName.isEmpty else {
            // TODO: translation needed
            Alerter.alert(translatedMessage: "You have entered an invalid first name. Please try again.")
            return false
        }
        guard let lastName = lastNameInput.text, !lastName.isEmpty else {
            // TODO: translation needed
            Alerter.alert(translatedMessage: "You have entered an invalid last name. Please try again.")
            return false
        }
        guard let mobileNumber = contactNumberInput.text, mobileNumber.isValidPhoneNumber() else {
            // TODO: translation needed
            Alerter.alert(translatedMessage: "You have entered an invalid mobile number. Please try again.")
            return false
        }
        return true

    }
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goPassword") {
            let controller = segue.destination as! PasswordViewController
            let data = WelcomeData(firstName: firstNameInput.text,
                                   lastName: lastNameInput.text,
                                   mobileNumber: contactNumberInput.text)
            
            controller.cosmos = cosmos
            controller.welcomeData = data
        }
    }
}

extension InformationViewController: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        let versionTheme = theme ?? cosmos.theme
        guard let legacyTheme = versionTheme.legacyAuthTheme else { fatalError("No legacy theme provided") }
        textField.backgroundColor = legacyTheme.backgroundColor
        textField.subviews.forEach { $0.backgroundColor = legacyTheme.backgroundColor }
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameInput {
            lastNameInput.becomeFirstResponder()
        } else if textField == lastNameInput {
            contactNumberInput.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension InformationViewController: ThemeInjectable {
    func configure(_ theme: Theme) {
        self.theme = theme
        guard let legacyTheme = theme.legacyAuthTheme else { fatalError("No legacy theme provided") }

        view.backgroundColor = legacyTheme.backgroundColor
        logoView.image = legacyTheme.logo

        firstNameInput.tintColor = theme.accentColor
        firstNameInput.textColor = theme.textColor
        firstNameInput.backgroundColor = legacyTheme.backgroundColor
        firstNameInput.borderColor = theme.accentColor

        lastNameInput.tintColor = theme.accentColor
        lastNameInput.textColor = theme.textColor
        lastNameInput.backgroundColor = legacyTheme.backgroundColor
        lastNameInput.borderColor = theme.accentColor

        contactNumberInput.tintColor = theme.accentColor
        contactNumberInput.textColor = theme.textColor
        contactNumberInput.backgroundColor = legacyTheme.backgroundColor
        contactNumberInput.borderColor = theme.accentColor

        nextBtn.backgroundColor = theme.accentColor
        let color = legacyTheme.mainButtonColor ?? legacyTheme.backgroundColor
        nextBtn.setTitleColor(color, for: .normal)
        nextBtn.titleLabel?.font = legacyTheme.mainButtonFont
    }
}
