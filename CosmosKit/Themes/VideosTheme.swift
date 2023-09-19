import Foundation

public struct VideosTheme: SubTheme {
    // swiftlint:disable:next line_length
    public init(backgroundColor: UIColor, titleColor: UIColor, titleFont: UIFont?, sectionColor: UIColor, shouldShowSectionBlock: Bool, sectionFont: UIFont?, publishedTimeColor: UIColor, publishedTimeFont: UIFont?) {
        self.backgroundColor = backgroundColor
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.sectionColor = sectionColor
        self.shouldShowSectionBlock = shouldShowSectionBlock
        self.sectionFont = sectionFont
        self.publishedTimeColor = publishedTimeColor
        self.publishedTimeFont = publishedTimeFont
    }

    let backgroundColor: UIColor
    let titleColor: UIColor
    let titleFont: UIFont?
    let sectionColor: UIColor
    let shouldShowSectionBlock: Bool
    let sectionFont: UIFont?
    let publishedTimeColor: UIColor
    let publishedTimeFont: UIFont?

    func applyColors(parent: Theme) {
        VideoCellSectionLabel.appearance().textColor = sectionColor
        VideoCellTitleLabel.appearance().textColor = titleColor
        VideoCellTimeLabel.appearance().textColor = publishedTimeColor
        VideoSectionBlock.appearance().backgroundColor = parent.accentColor
    }

    func applyFonts(parent: Theme) {
        VideoCellSectionLabel.appearance().font = sectionFont!
        VideoCellTitleLabel.appearance().font = titleFont!
        VideoCellTimeLabel.appearance().font = publishedTimeFont!
    }
}

extension VideosTheme {
    public init() {
        self.init(backgroundColor: .black,
                  titleColor: .white,
                  titleFont: UIFont(name: "HelveticaNeue", size: 12),
                  sectionColor: .white, shouldShowSectionBlock: false,
                  sectionFont: UIFont(name: "HelveticaNeue", size: 12),
                  publishedTimeColor: .white,
                  publishedTimeFont: UIFont(name: "HelveticaNeue", size: 12))
    }
}
