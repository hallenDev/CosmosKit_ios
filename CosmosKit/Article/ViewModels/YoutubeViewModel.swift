import Foundation

struct YoutubeViewModel: WidgetViewModel {

    var type: WidgetType = .youtube

    static func create(from widget: Widget) -> WidgetViewModel {
        guard let data = widget.data as? YoutubeWidgetData else {
            fatalError("failed to parse data")
        }
        return YoutubeViewModel(from: data)
    }

    let id: String?
    let playlistId: String?

    init(from youtube: YoutubeWidgetData) {
        self.id = youtube.id
        self.playlistId = youtube.pid
    }
}
