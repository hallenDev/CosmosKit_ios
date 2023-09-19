import Foundation
import Kingfisher

struct GalleryViewModel: WidgetViewModel {

    var type: WidgetType = .gallery

    static func create(from widget: Widget) -> WidgetViewModel {
        guard let data = widget.data as? GalleryWidgetData else {
            fatalError("failed to parse data")
        }
        return GalleryViewModel(from: data)
    }

    var images = [ImageViewModel]()

    init(from images: [Image]) {
        for image in images {
           self.images.append(ImageViewModel(from: image))
        }
    }

    init(from gallery: GalleryWidgetData) {
        self.init(from: gallery.images)
    }

    func loadGallery(completion: @escaping ([UIImage?]) -> Void) {
        var loadedImages = [UIImage?]()
        for image in images {
            if let url = image.imageURL {
                ImageDownloader.default.downloadImage(with: url, completionHandler: { result in
                    switch result {
                    case .success(let imageResult):
                        loadedImages.append(imageResult.image)
                    case .failure: break
                    }
                })
            }
        }
        completion(loadedImages)
    }
}
