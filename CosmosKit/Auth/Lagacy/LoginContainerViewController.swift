import UIKit

protocol ContainerSwappable {
    var swap: ((UIViewController) -> Void)? { get set }
    var didFinish: (() -> Void)? { get set }
}

extension ContainerSwappable {
    func isEmailValid(_ emailText: String?) -> Bool {

        guard let email = emailText else {
            return false
        }
        // swiftlint:disable:next line_length
        let regex = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"

        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", regex)
        return emailTest.evaluate(with: email)
    }
}

protocol ThemeInjectable {
    var cosmos: Cosmos! { get set }
    func configure(_ theme: Theme)
}

public class LoginContainerViewController: UIViewController {

    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var container: UIView!
    @IBOutlet var bottom: NSLayoutConstraint!
    @IBOutlet var navTitle: UINavigationItem!

    var didFinish: (() -> Void)?
    var cosmos: Cosmos! {
        didSet {
            if theme == nil {
                theme = cosmos.theme
            }
        }
    }

    var theme: Theme?

    var currentViewController: UIViewController! {
        didSet {
            if var new = (currentViewController as? ContainerSwappable) {
                new.swap = changeTo
                new.didFinish = didFinish
                if currentViewController is LegacyRegisterViewController {
                    navTitle.title = LanguageManager.shared.translate(key: .register)
                } else if currentViewController is LegacySigninViewController {
                    navTitle.title = LanguageManager.shared.translate(key: .signIn)
                } else if currentViewController is LegacyForgotPasswordViewController {
                    navTitle.title = LanguageManager.shared.translate(key: .forgotPassword)
                }
            }
        }
    }

    public func triggerSegue(_ name: String) {
        currentViewController.performSegue(withIdentifier: name, sender: self)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardChanged),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardHidden),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        let givenTheme = theme ?? cosmos.theme
        guard let legacyTheme = givenTheme.legacyAuthTheme else { fatalError("No legacy theme provided") }
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = legacyTheme.backgroundColor
        navigationBar.tintColor = legacyTheme.textColor
        self.view.backgroundColor = legacyTheme.backgroundColor
    }

    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override public func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        didFinish?()
        super.dismiss(animated: flag, completion: completion)
    }

    @objc func keyboardChanged(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            bottom.constant != keyboardSize.height {
            bottom.constant = keyboardSize.height
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardHidden(notification: NSNotification) {
        bottom.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }

    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let theme = theme, var new = segue.destination as? ThemeInjectable {
            new.cosmos = cosmos
            _ = segue.destination.view
            new.configure(theme)
        }
        currentViewController = segue.destination
    }

    func changeTo(_ viewController: UIViewController) {
        if let theme = theme, var new = viewController as? ThemeInjectable {
             new.cosmos = cosmos
            _ = viewController.view
            new.configure(theme)
        }

        currentViewController.willMove(toParent: nil)
        addChild(viewController)

        transition(from: currentViewController,
                   to: viewController,
                   duration: 0.1,
                   options: .transitionCrossDissolve,
                   animations: nil) { _ in
                    self.currentViewController.removeFromParent()
                    viewController.didMove(toParent: self)
                    self.currentViewController = viewController
        }
    }
}
