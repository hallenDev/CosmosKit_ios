import Foundation

struct JWPlayerViewModel: WidgetViewModel {

    var type: WidgetType = .jwplayer

    static func create(from widget: Widget) -> WidgetViewModel {
        guard let data = widget.data as? JWPlayerWidgetData else {
            fatalError("failed to parse data")
        }
        return JWPlayerViewModel(from: data)
    }

    let webData: String
    let url: String
    let description: String

    var webViewModel: WebViewModel {
        return WebViewModel(html: webData, url: url, type: type)
    }

    init(from data: JWPlayerWidgetData) {
        self.webData = data.meta.html
        self.url = data.url
        self.description = data.meta.description ?? ""
    }
}
