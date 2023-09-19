import Foundation

extension UINavigationController {
    func setBackButtonImage() {
        let backImage = UIImage(cosmosName: .navBack)
        navigationBar.backIndicatorImage = backImage
        navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationBar.shadowImage = UIImage()
        if #available(iOS 13.0, *) {
            navigationBar.tintColor = UIColor(dynamicProvider: { trait -> UIColor in
                return trait.userInterfaceStyle == .dark ? .white : .black
            })
        } else {
            navigationBar.tintColor = .white
        }
    }
}

extension UIViewController {
    func hideBackButtonTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
