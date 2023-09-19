import Foundation
import CosmosKit

struct AnalyticsLogger: AnalyticsLogable {
    func log(error: NSError) {
        print(error.localizedDescription)
    }

    func log(event: CosmosEvent) {
        print("Event: \(event.name), parameters: \(String(describing: event.parameters))")
    }
}
