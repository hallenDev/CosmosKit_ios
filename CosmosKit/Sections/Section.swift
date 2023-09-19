import Foundation

public struct Section: Codable {
    public let name: String?
    let id: String?
    let link: String?
    var subSections: [Section]?
    let articleSlug: String?
    let sectionId: String?
    let publicationId: String?
    let hideApp: Bool?

    enum CodingKeys: String, CodingKey {
        case name
        case id
        case link
        case subSections = "sections"
        case articleSlug = "cosmosArticleSlug"
        case sectionId = "cosmosSectionId"
        case publicationId = "cosmosPublicationId"
        case hideApp = "hideInApp"
    }
}

extension Section {
    init(name: String, id: String) {
        self.name = name
        self.id = id
        self.subSections = nil
        self.link = nil
        self.hideApp = false
        self.articleSlug = nil
        self.sectionId = nil
        self.publicationId = nil
    }

    init(name: String, subSections: [Section]?) {
        self.name = name
        self.id = nil
        self.subSections = subSections
        self.link = nil
        self.hideApp = false
        self.articleSlug = nil
        self.sectionId = nil
        self.publicationId = nil
    }
}

public struct AdSection: Codable {
    let section: String
    let subsection: String?
}
