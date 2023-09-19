import Foundation

public struct TitleConfig {
    public let publications: [TitlePublication]
    public let cellHeight: CGFloat
    public let titleHeight: CGFloat
    public let arrowColor: UIColor

    public init(_ publications: [TitlePublication], titleHeight: CGFloat = 25, cellHeight: CGFloat = 20, arrowColor: UIColor = .black) {
        self.publications = publications
        self.cellHeight = cellHeight
        self.titleHeight = titleHeight
        self.arrowColor = arrowColor
    }
}

public struct TitlePublication {
    let id: String
    let logo: UIImage
    let selectable: Bool
    let backgroundColor: UIColor

    public init(id: String, logo: UIImage, selectable: Bool, backgroundColor: UIColor) {
        self.id = id
        self.logo = logo
        self.selectable = selectable
        self.backgroundColor = backgroundColor
    }
}
