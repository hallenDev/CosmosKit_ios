import Foundation

class PastEditionTriangle: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        resize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        resize()
    }

    func resize() {
        self.layer.cornerRadius = self.frame.height
    }
}
