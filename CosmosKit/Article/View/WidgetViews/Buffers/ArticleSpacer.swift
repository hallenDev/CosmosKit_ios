import Foundation

class ArticleSpacer: UIView {

    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.frame.width, height: self.spaceHeight)
    }

    var spaceHeight: CGFloat

    init(width: CGFloat, height: CGFloat, color: UIColor) {
        self.spaceHeight = height
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        super.init(frame: frame)
        self.backgroundColor = color
    }

    required init?(coder aDecoder: NSCoder) {
        self.spaceHeight = 0
        super.init(coder: aDecoder)
    }
}
