public struct Image: Codable {
    let filepath: String
    public let title: String?
    public let description: String?
    public var imageURL: String {
        return "https:\(filepath)"
    }
    public let author: String?
    public let height: Int
    public let width: Int
    public let blur: String?
    public var blurImage: UIImage? {
        guard  let blur = blur,
            let data = Data(base64Encoded: blur)
            else { return nil }
        return UIImage(data: data)
    }
}

extension Image {
    init() {
        self.title = LanguageManager.shared.translate(key: .imageMissing)
        self.filepath = ""
        self.description = LanguageManager.shared.translate(key: .imageNotAvailable)
        self.author = ""
        self.height = 0
        self.width = 0
        self.blur = nil
    }
}

