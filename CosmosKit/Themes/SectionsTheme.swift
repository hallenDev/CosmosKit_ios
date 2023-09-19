import Foundation

public struct SectionsTheme: SubTheme {
    // swiftlint:disable:next line_length
    public init(sectionFont: UIFont?, sectionColor: UIColor, subSectionFont: UIFont? = nil, subSectionColor: UIColor? = nil, specialReportFont: UIFont?, specialReportColor: UIColor) {
        self.sectionFont = sectionFont
        self.sectionColor = sectionColor
        self.subSectionFont = subSectionFont ?? sectionFont
        self.subSectionColor = subSectionColor ?? sectionColor
        self.specialReportFont = specialReportFont
        self.specialReportColor = specialReportColor
    }

    let sectionFont: UIFont?
    let sectionColor: UIColor
    let subSectionFont: UIFont?
    let subSectionColor: UIColor // should default to title font
    let specialReportFont: UIFont?
    let specialReportColor: UIColor

    func applyColors(parent: Theme) {
        SectionCellLabel.appearance().textColor = sectionColor
        SubSectionCellLabel.appearance().textColor = subSectionColor
        SectionSpecialReportLabel.appearance().textColor = specialReportColor
        SectionTableViewCell.appearance().backgroundColor = parent.backgroundColor
        SubSectionCellBulletView.appearance().backgroundColor = parent.accentColor
        SectionSpecialReportView.appearance().backgroundColor = parent.accentColor
        SectionSelectedView.appearance().backgroundColor = parent.accentColor
    }

    func applyFonts(parent: Theme) {
        SectionSpecialReportLabel.appearance().font = specialReportFont!
        SectionCellLabel.appearance().font = sectionFont!
        SubSectionCellLabel.appearance().font = subSectionFont!
    }
}

extension SectionsTheme {
    public init() {
        sectionFont = UIFont(name: "HelveticaNeue-Bold", textStyle: .subheadline)
        subSectionFont = UIFont(name: "HelveticaNeue", textStyle: .caption1)
        specialReportFont = UIFont(name: "HelveticaNeue", textStyle: .caption2)
        sectionColor = UIColor(color: .tundora)
        subSectionColor = UIColor(color: .tundora)
        specialReportColor = .white
    }
}
