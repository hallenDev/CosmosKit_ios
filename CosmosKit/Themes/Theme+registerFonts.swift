import Foundation

extension Theme {

    public static func registerFont(from fileName: String) -> Bool {
        let bundle = Bundle.main
        return registerFont(from: fileName, bundle: bundle)
    }

    public static func registerFonts(_ fonts: [String]) {
        for font in fonts {
            guard registerFont(from: font, bundle: .main) else {
                fatalError("Couldn't load fonts")
            }
        }
    }

    static func registerFont(from filename: String, bundle: Bundle) -> Bool {
        guard let pathForResourceString = bundle.path(forResource: filename, ofType: nil),
              let fontData = NSData(contentsOfFile: pathForResourceString),
              let dataProvider = CGDataProvider(data: fontData),
              let fontRef = CGFont(dataProvider) else {
            print("UIFont+:  Failed to register font - font could not be loaded.")
            return false
        }

        var errorRef: Unmanaged<CFError>?
        let result = CTFontManagerRegisterGraphicsFont(fontRef, &errorRef)
        if let errorRef = errorRef {
            print("Font add error: \(errorRef)")
        }
        return result
    }
}
