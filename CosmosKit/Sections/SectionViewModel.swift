import Foundation

public struct SectionViewModel {
    public let name: String?
    let id: String?
    let publication: String?
    let articleSlug: String?
    let link: String?
    var subSections: [SectionViewModel]?
    var expanded = false
    let isSpecialReport = false

    var isAuthor: Bool {
        return self.link?.contains("/authors/") ?? false
    }

    init?(section: Section) {
        guard let name = section.name, !name.isEmpty, !(section.hideApp ?? false) else { return nil }

        self.name = name.uppercased()
        self.id = section.id ?? section.sectionId
        self.publication = section.publicationId
        self.articleSlug = section.articleSlug
        self.link = section.link
        self.subSections = section.subSections?.compactMap { SectionViewModel(section: $0) }
    }

    var isLinkSection: Bool {
        return link != nil && publication == nil && id == nil && articleSlug == nil
    }

    var isArticleSection: Bool {
        return articleSlug != nil
    }

    var isForeignSection: Bool {
        return id != nil && publication != nil
    }

    init(name: String) {
        self.name = name.uppercased()
        self.id = nil
        self.publication = nil
        self.articleSlug = nil
        self.link = nil
        self.subSections = nil
    }
}

struct SectionsViewModel {
    let sections: [SectionViewModel]
    let renderType: ArticleRenderType
    var total: Int {
        let subSections = sections.compactMap { $0.subSections }
        return sections.count + subSections.count
    }

    init(renderType: ArticleRenderType, sections: [SectionViewModel]? = nil) {
        self.renderType = renderType
        self.sections = sections ?? []
    }
}
