import UIKit

public struct CustomUIPair {
    public let nib: UINib
    public let reuseId: String

    public init(nib: UINib, reuseId: String) {
        self.nib = nib
        self.reuseId = reuseId
    }
}
