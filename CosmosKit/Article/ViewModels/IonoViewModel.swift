import Foundation

public struct IonoViewModel: WidgetViewModel {
    public let type: WidgetType = .iono

    public static func create(from widget: Widget) -> WidgetViewModel {
        guard let ionoData = widget.data as? IonoWidgetData else {
            fatalError("failed to parse data")
        }
        return IonoViewModel(from: ionoData)
    }

    let html: String?
    let provider: String?

    public init(from data: IonoWidgetData) {
        self.html = data.html
        self.provider = data.provider
    }
}
