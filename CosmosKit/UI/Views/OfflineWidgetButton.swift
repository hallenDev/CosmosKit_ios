import Foundation

class OfflineWidgetButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 16
        layer.masksToBounds = true
        contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        titleLabel?.font = UIFont(name: "Lato-Regular", textStyle: .body)!
    }
}
