import Foundation

enum CosmosBundleKey: String {
    case version = "CFBundleShortVersionString"
    case build = "CFBundleVersion"
}

extension Bundle {
    func getValue(for key: CosmosBundleKey) -> String {
        getValue(for: key.rawValue)
    }

    func getOptionalValue(for key: CosmosBundleKey) -> String? {
        getOptionalValue(for: key.rawValue)
    }

    public func getValue(for key: String) -> String {
        // swiftlint:disable:next force_cast
        object(forInfoDictionaryKey: key) as! String
    }

    public func getOptionalValue(for key: String) -> String? {
        object(forInfoDictionaryKey: key) as? String
    }
}
