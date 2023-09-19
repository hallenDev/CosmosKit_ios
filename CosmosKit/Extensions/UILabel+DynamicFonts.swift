// swiftlint:disable force_cast
import DTCoreText

public extension UILabel {
    @objc var customFont: UIFont {
        get { return self.font }
        set { self.font = newValue }
    }
}

public extension String {

    /**
     Creates a `NSMutableAttributedString` with the desired font & optional italic and bold fonts

     - Parameter html: The HTML encoded string to be attributed
     - Parameter font: The `UIFont` that is to be used. The font family from this font will be used to set the traits
     - Parameter italicFont: The font name to be used for italic text
     - Parameter boldFont: The font name to be used for bold text
     - Parameter size: The size of the text. Inferred from `font` if not specified 
     - Returns: A new string attributed with the specified fonts and size
     */
    static func attributedString(html: String?,
                                 font: UIFont?,
                                 italicFont: String? = nil,
                                 boldFont: String? = nil,
                                 size: CGFloat? = nil) -> NSMutableAttributedString? {
        guard let font = font, let html = html, !html.isEmpty else { return nil }

        DTCoreTextFontDescriptor.setOverrideFontName(font.fontName,
                                                     forFontFamily: font.familyName,
                                                     bold: false,
                                                     italic: false)

        if let italic = italicFont {
            DTCoreTextFontDescriptor.setOverrideFontName(italic,
                                                         forFontFamily: font.familyName,
                                                         bold: false,
                                                         italic: true)
        }
        if let bold = boldFont {
            DTCoreTextFontDescriptor.setOverrideFontName(bold,
                                                         forFontFamily: font.familyName,
                                                         bold: true,
                                                         italic: false)
        }
        return html.data(using: .utf8).map {
            let string = NSMutableAttributedString(htmlData: $0,
                                                   options: [DTDefaultFontName: font.fontName,
                                                             DTDefaultFontFamily: font.familyName,
                                                             DTDefaultFontSize: size ?? font.fontDescriptor.pointSize,
                                                             DTUseiOS6Attributes: true],
                                                   documentAttributes: nil)
            return string!
        }
    }

    func replaceFirst(of pattern: String, with replacement: String) -> String {
        if let range = self.range(of: pattern) {
            return self.replacingCharacters(in: range, with: replacement)
        } else {
            return self
        }
    }

    func replaceLast(of pattern: String, with replacement: String) -> String {
        if let range = self.range(of: pattern, options: .backwards, range: nil, locale: nil) {
            return self.replacingCharacters(in: range, with: replacement)
        } else {
            return self
        }
    }
}

extension UIFont {
    func change(fontFamily: String) -> UIFont {
        let weight = (fontDescriptor.object(forKey: UIFontDescriptor.AttributeName.traits)
            as! NSDictionary)[UIFontDescriptor.TraitKey.weight]!
        let attributes = [
            UIFontDescriptor.AttributeName.traits: [
                UIFontDescriptor.TraitKey.weight: weight
            ]
        ]
        let descriptor = UIFontDescriptor(name: fontName, size: pointSize)
            .withFamily(fontFamily)
            .addingAttributes(attributes)
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}
