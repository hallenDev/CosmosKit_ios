import Foundation

class CosmosStoryboard {

    static func loadViewController<T: UIViewController>() -> T {
        // swiftlint:disable:next force_cast
        UIStoryboard.cosmos.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
}
