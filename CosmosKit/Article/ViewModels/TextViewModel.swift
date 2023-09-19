import Foundation

struct TextViewModel: WidgetViewModel {

    var type: WidgetType

    static func create(from widget: Widget) -> WidgetViewModel {
        guard let data = widget.data as? TextWidgetData else {
            fatalError("failed to parse data")
        }
        return TextViewModel(from: data, type: widget.type)
    }

    let html: String?
    let text: String?

    var isCrossword: Bool {
        return html?.contains("amuselabs.com") ?? false
    }

    init(from text: TextWidgetData, type: WidgetType) {
        self.html = text.html
        self.type = type
        self.text = text.text
    }
}
