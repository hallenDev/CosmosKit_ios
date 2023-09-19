// swiftlint:disable identifier_name
import Foundation

class StatusView: UIView {

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 5))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func updateY(_ y: CGFloat, width: CGFloat) {
        self.frame = CGRect(x: 0, y: y, width: width, height: 5)
    }
}
