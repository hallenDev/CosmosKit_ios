public extension UIApplication {

    func topViewController() -> UIViewController? {
        return self.topViewController(UIApplication.shared.keyWindow?.rootViewController)
    }

    func topViewController(_ rootViewController: UIViewController?) -> UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }

        if let navController = rootViewController as? UINavigationController {
            let lastViewController = navController.visibleViewController
            return self.topViewController(lastViewController)
        }

        if let tabController = rootViewController as? UITabBarController {
            let lastViewController = tabController.selectedViewController
            return self.topViewController(lastViewController)
        }

        guard let presented = rootViewController.presentedViewController else {
            return rootViewController
        }

        if let presentedVC = presented.presentedViewController {
            return self.topViewController(presentedVC)
        }

        return self.topViewController(presented)
    }
}
