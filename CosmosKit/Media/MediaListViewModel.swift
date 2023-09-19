import UIKit

struct MediaListViewModel {

    public enum ListType {
        case videos
        case audio
    }

    var media: [MediaViewModel]
    var title: String?
    var type: ListType

    init(title: String? = nil, type: ListType) {
        self.type = type
        if type == .videos {
            self.title = title ?? "VIDEOS"
        } else {
            self.title = title ?? "AUDIO"
        }
        self.media = []
    }

    mutating func add(media: [Media]) {
        self.media.append(contentsOf: media.compactMap { MediaViewModel($0) })
    }

    func mediaCount() -> Int {
        media.count
    }

    func getMedia(at indexPath: IndexPath) -> MediaViewModel? {
        guard 0 ..< mediaCount() ~= indexPath.row else { return nil }
        return media[indexPath.row]
    }
}
