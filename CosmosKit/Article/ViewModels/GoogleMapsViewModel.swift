// swiftlint:disable line_length
import Foundation

struct GoogleMapsViewModel: WidgetViewModel {

    var type: WidgetType = .googleMaps

    static func create(from widget: Widget) -> WidgetViewModel {
        guard let data = widget.data as? GoogleMapsWidgetData else {
            fatalError("failed to parse data")
        }
        return GoogleMapsViewModel(from: data)
    }

    let zoom: Int
    let coordinates: String
    let address: String
    let mapType: String
    let size = "\(Int(UIScreen.main.bounds.width))x180"
    let base = "https://maps.googleapis.com/maps/api/staticmap?"

    var mapOpenUrl: String {
        return "https://www.google.com/maps/@?api=1&map_action=map&center=\(coordinates)&zoom=\(zoom)&basemap=\(type)"
    }

    init(from mapData: GoogleMapsWidgetData) {
        self.zoom = mapData.zoom
        self.coordinates = mapData.coordinates
        self.address = mapData.address
        self.mapType = mapData.type
    }

    func getMapURL(key: String) -> URL? {
        if let url = "\(base)center=\(coordinates)&zoom=\(zoom)&maptype=\(mapType)&size=\(size)&markers=color:red|\(coordinates)&key=\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return URL(string: url)
        } else {
            return nil
        }
    }
}
