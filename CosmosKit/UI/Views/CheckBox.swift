import UIKit

class CheckBox: UIButton, Themable {

    var theme: Theme!

    var isChecked: Bool = false {
        didSet {
            let image = isChecked ? theme.authTheme.termsAndConditionsActive : theme.authTheme.termsAndConditionsInactive
            self.setImage(image, for: UIControl.State.normal)
        }
    }

    func applyTheme(theme: Theme) {
        self.theme = theme
        tintColor = .clear
        self.isChecked = false
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        imageView?.contentMode = .scaleAspectFill
    }

    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked.toggle()
        }
    }
}
