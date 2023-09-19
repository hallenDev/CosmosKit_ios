import Foundation

struct InfoBlockViewModel: WidgetViewModel {

    var type: WidgetType = .infoblock

    static func create(from widget: Widget) -> WidgetViewModel {
        guard let data = widget.data as? InfoBlockWidgetData else {
            fatalError("failed to parse data")
        }
        return InfoBlockViewModel(from: data)
    }

    let title: String?
    let description: String?

    init(from info: InfoBlockWidgetData) {
        self.title = info.title
        self.description = info.description
    }
}
