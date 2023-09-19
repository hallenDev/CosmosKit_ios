import UIKit

class CosmosRefreshControl: UIRefreshControl {

    convenience init(tintColor: UIColor) {
        self.init()
        self.tintColor = tintColor
        self.tintColorDidChange()
    }
}
