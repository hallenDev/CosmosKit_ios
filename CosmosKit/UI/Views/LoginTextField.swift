import Foundation

class LoginTextField: UITextField {

    @objc dynamic var borderColor: UIColor? {
        didSet {
            border.borderColor = borderColor?.cgColor
        }
    }

    var border: CALayer

    required init?(coder aDecoder: NSCoder) {
        border = CALayer()
        border.frame = .zero
        super.init(coder: aDecoder)
    }

    func addBorder() {
        let borderWidth = CGFloat(2.0)

        border.frame = CGRect(x: 0,
                              y: frame.size.height + 5,
                              width: frame.size.width,
                              height: borderWidth)

        border.borderWidth = borderWidth
        layer.addSublayer(border)
        layer.masksToBounds = false
    }
}
