import Foundation

public enum FontFileType: String {
    case otf
    case ttf
}

public protocol CosmosFontEnum {
    var name: String { get }
    var fileType: FontFileType { get }
}
extension CosmosFontEnum {
    public var filename: String {
        String(format: "%@.%@", name, fileType.rawValue)
    }
}

public extension UIFont {
    convenience init?(name: String, textStyle: UIFont.TextStyle) {
        self.init(name: name, size: UIFont.preferredFont(forTextStyle: textStyle).fontDescriptor.pointSize)
    }

    convenience init?(name: CosmosFontEnum, textStyle: UIFont.TextStyle) {
        self.init(name: name.name, textStyle: textStyle)
    }
}
