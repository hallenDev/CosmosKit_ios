import Foundation

struct DividerViewModel: WidgetViewModel {

    var type: WidgetType = .divider

    static func create(from widget: Widget) -> WidgetViewModel {
        return DividerViewModel()
    }
}
