import Foundation

class CosmosSwitch: UIControl {

    // MARK: Public Switch properties
    public var isOn = true
    public var animationDuration: Double = 0.5

    public var borderColor: UIColor = .black {
        didSet {
            self.layoutSubviews()
        }
    }
    public var borderWidth: CGFloat = 1.0 {
        didSet {
            self.layoutSubviews()
        }
    }
    public var padding: CGFloat = 1 {
        didSet {
            self.layoutSubviews()
        }
    }
    public var onTintColor = UIColor(red: 144/255, green: 202/255, blue: 119/255, alpha: 1) {
        didSet {
            self.setupUI()
        }
    }
    public var offTintColor = UIColor.lightGray {
        didSet {
            self.setupUI()
        }
    }
    public var cornerRadius: CGFloat = 0.5 {
        didSet {
            self.layoutSubviews()
        }
    }
    public var onThumbTintColor = UIColor.white {
        didSet {
            self.setupUI()
        }
    }
    public var offThumbTintColor = UIColor.white {
        didSet {
            self.setupUI()
        }
    }
    public var thumbCornerRadius: CGFloat = 0.5 {
        didSet {
            self.layoutSubviews()
        }
    }
    public var thumbSize = CGSize.zero {
        didSet {
            self.layoutSubviews()
        }
    }

    // MARK: Internal properties
    private var thumbView = UIView(frame: .zero)
    private var onPoint = CGPoint.zero
    private var offPoint = CGPoint.zero
    private var isAnimating = false

    func setupUI() {
        clear()
        clipsToBounds = false
        thumbView.backgroundColor = isOn ? onThumbTintColor : offThumbTintColor
        thumbView.isUserInteractionEnabled = false
        addSubview(self.thumbView)
    }

    private func clear() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        guard !self.isAnimating else { return }

        layer.cornerRadius = bounds.size.height * cornerRadius
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        backgroundColor = isOn ? onTintColor : offTintColor

        let thumbSize = self.thumbSize != CGSize.zero ? self.thumbSize : CGSize(width: bounds.size.height - (padding * 2),
                                                                                height: bounds.height - (padding * 2))
        let yPosition = (bounds.size.height - thumbSize.height) / 2
        onPoint = CGPoint(x: bounds.size.width - thumbSize.width - padding, y: yPosition)
        offPoint = CGPoint(x: padding, y: yPosition)
        thumbView.frame = CGRect(origin: isOn ? onPoint : offPoint, size: thumbSize)
        thumbView.layer.cornerRadius = thumbSize.height * thumbCornerRadius
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        animate()
        return true
    }

    private func animate() {
        isOn.toggle()
        isAnimating = true
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5,
                       options: [UIView.AnimationOptions.curveEaseOut,
                                 UIView.AnimationOptions.beginFromCurrentState],
                       animations: {
                        self.thumbView.frame.origin.x = self.isOn ? self.onPoint.x : self.offPoint.x
                        self.thumbView.backgroundColor = self.isOn ? self.onThumbTintColor : self.offThumbTintColor
                        self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
                       },
                       completion: { _ in
                        self.isAnimating = false
                        self.sendActions(for: UIControl.Event.valueChanged)
                       })
    }

}
