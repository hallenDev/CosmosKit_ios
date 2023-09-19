import Foundation

struct BibliodamViewModel: WidgetViewModel {
    let type: WidgetType = .bibliodam
    let url: String?
    let thumbnail: URL?

    static func create(from widget: Widget) -> WidgetViewModel {
        guard let bibliodamData = widget.data as? BibliodamWidgetData else {
            fatalError("failed to parse data")
        }
        return BibliodamViewModel(from: bibliodamData)
    }

    init(from data: BibliodamWidgetData) {
        self.url = data.url
        if let url = data.thumbnail {
            self.thumbnail = URL(string: url)
        } else {
            self.thumbnail = nil
        }
    }
}
