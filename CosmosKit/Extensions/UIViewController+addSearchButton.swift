import Foundation

extension UIViewController {
    public func addSearchButton(_ search: SearchButton, animated: Bool) {
        let backup = navigationController?.navigationBar.topItem?.titleView
        navigationController?.topViewController?.navigationItem.setRightBarButton(search.button, animated: animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.topItem?.titleView = backup
    }
}
