import Foundation

struct ImageViewModel: WidgetViewModel {

    var type: WidgetType = .image

    static func create(from widget: Widget) -> WidgetViewModel {
        guard let data = widget.data as? ImageWidgetData else {
            fatalError("failed to parse data")
        }
        return ImageViewModel(from: data)
    }

    let title: String
    let description: String
    let author: String
    let imageURL: URL?
    let imageHeight: CGFloat
    let imageWidth: CGFloat
    let blur: UIImage?

    init(from image: Image) {
        self.title = image.title ?? ""
        self.description = image.description ?? ""
        if !(image.author ?? "").isEmpty {
            self.author = "Image: \(image.author!.uppercased())"
        } else {
            self.author = image.author ?? ""
        }
        self.imageURL = URL(string: image.imageURL)
        self.imageHeight = CGFloat(image.height)
        self.imageWidth = CGFloat(image.width)
        if let blurData = image.blur,
            let data = Data(base64Encoded: blurData) {
            self.blur = UIImage(data: data)
        } else {
            self.blur = nil
        }
    }

    init(from image: ImageWidgetData) {
        self.init(from: image.image)
    }
}
