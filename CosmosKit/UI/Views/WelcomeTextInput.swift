import Foundation

class WelcomeTextInput: UIView, Themable {

    private var textField: WelcomeTextField = {
        let textf = WelcomeTextField()
        textf.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return textf
    }()
    private var descriptor: WelcomeTextFieldDescriptor = {
        WelcomeTextFieldDescriptor()
    }()
    private var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    var theme: Theme!

    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    func configure(descriptor labelText: String, keyboardType: UIKeyboardType = .default, password: Bool = false) {
        // TODO: translation needed
        descriptor.text = labelText
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = password
        textField.delegate = self

        stack.addArrangedSubview(descriptor)
        stack.addArrangedSubview(textField)
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor)
        ])
    }

    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        textField.addTarget(target, action: action, for: controlEvents)
    }

    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return textField.becomeFirstResponder()
    }

    func applyTheme(theme: Theme) {
        self.theme = theme
        backgroundColor = .clear
        textField.applyTheme(theme: theme)
        descriptor.applyTheme(theme: theme)
    }

    func addToolBar(primaryTitle: String = "Next", primaryAction: (target: Any, action: Selector), secondaryTitle: String = "Cancel", secondaryAction: (target: Any, action: Selector)? = nil) {
        let secondary = secondaryAction ?? (target: textField, action: #selector(resignFirstResponder))
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        toolbar.barStyle = .default
        toolbar.tintColor = theme.accentColor
        // TODO: translation needed on bar items
        toolbar.items = [
            UIBarButtonItem(title: secondaryTitle, style: .plain, target: secondary.target, action: secondary.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: primaryTitle, style: .done, target: primaryAction.target, action: primaryAction.action)
        ]
        toolbar.sizeToFit()

        textField.inputAccessoryView = toolbar
    }
}

extension WelcomeTextInput: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
