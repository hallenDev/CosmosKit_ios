public extension UIView {

    class func instanceFromNib<T: UIView>() -> T {
        // swiftlint:disable:next force_cast
        return Bundle.cosmos.loadNibNamed(String(describing: self), owner: nil)?[0] as! T
    }

    func fromNib<T: UIView>() -> T? {

        guard let contentView = Bundle.cosmos.loadNibNamed(String(describing: type(of: self)),
                                                           owner: self,
                                                           options: nil)?.first as? T else {
                                                            return nil
        }
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layoutAttachAll(to: self)
        return contentView
    }

    func layoutAttachAll(to childView: UIView,
                         top: Bool = true,
                         topC: CGFloat = 0,
                         bottom: Bool = true,
                         bottomC: CGFloat = 0,
                         right: Bool = true,
                         rightC: CGFloat = 0,
                         left: Bool = true,
                         leftC: CGFloat = 0) {

        var constraints = [NSLayoutConstraint]()
        childView.translatesAutoresizingMaskIntoConstraints = false

        if left {
            constraints.append(NSLayoutConstraint(item: childView,
                                                  attribute: .left,
                                                  relatedBy: .equal,
                                                  toItem: self,
                                                  attribute: .left,
                                                  multiplier: 1.0,
                                                  constant: leftC))
        }

        if right {
            constraints.append(NSLayoutConstraint(item: childView,
                                              attribute: .right,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .right,
                                              multiplier: 1.0,
                                              constant: rightC))
        }

        if top {
            constraints.append(NSLayoutConstraint(item: childView,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .top,
                                              multiplier: 1.0,
                                              constant: topC))
        }

        if bottom {
            constraints.append(NSLayoutConstraint(item: childView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .bottom,
                                              multiplier: 1.0,
                                              constant: bottomC))
        }

        childView.addConstraints(constraints)
    }
}
