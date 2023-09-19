import Foundation
import Reachability

protocol Reachable {
    var connection: Reachability.Connection { get }
    var whenReachable: Reachability.NetworkReachable? { get set }
    var whenUnreachable: Reachability.NetworkUnreachable? { get set }
}

extension Reachability: Reachable {}
