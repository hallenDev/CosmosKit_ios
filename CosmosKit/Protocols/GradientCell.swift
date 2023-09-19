import Foundation

public protocol GradientCell {
    func getExtraWideFrameForGradient() -> CGRect
}

public extension GradientCell {
    func addGradient(to gradientView: UIView, theme: Theme?) {
        gradientView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        let layer = CAGradientLayer()
        layer.frame = getExtraWideFrameForGradient()
        layer.colors = [UIColor.clear.cgColor, theme?.articleListTheme.gradientColor.cgColor ?? UIColor.black.cgColor]
        layer.startPoint = CGPoint(x: 0.5, y: 0.6)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientView.layer.addSublayer(layer)
    }
}
