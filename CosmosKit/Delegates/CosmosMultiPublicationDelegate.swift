import Foundation

public protocol CosmosMultiPublicationDelegate: AnyObject {
    func cosmosSwitchPublication(toIndex: Int)
}
