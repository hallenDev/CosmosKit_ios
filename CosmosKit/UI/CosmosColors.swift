import UIKit

enum CosmosColor: String, CaseIterable {
    case codGray = "CodGray"
    case alto = "Alto"
    case tundora = "Tundora"
    case pampas = "Pampas"
}

extension UIColor {
    convenience init(color: CosmosColor) {
        self.init(named: color.rawValue, in: .cosmos, compatibleWith: nil)!
    }
}
