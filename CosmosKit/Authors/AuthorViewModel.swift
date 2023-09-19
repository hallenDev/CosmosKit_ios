import Foundation

public struct AuthorViewModel {
    public var name: String?
    let title: String?
    let bio: String?
    let imageURL: URL?
    let blur: UIImage?
    let key: Int64?
    let twitter: String?
    let instagram: String?
    let facebook: String?
    public let originalAuthors: [String]?
    public let originalAuthor: Author?

    var hasSocial: Bool {
        return twitter != nil || instagram != nil || facebook != nil
    }

    init(from author: Author) {
        self.originalAuthor = author
        self.originalAuthors = nil
        self.name = author.name
        self.title = author.title
        self.bio = author.bio
        self.key = author.key
        self.imageURL = URL(string: author.image?.imageURL ?? "")
        self.twitter = author.social?.twitter
        self.instagram = author.social?.instagram
        self.facebook = author.social?.facebook

        if let givenBlur = author.image?.blur,
            let data = Data(base64Encoded: givenBlur) {
            self.blur = UIImage(data: data)
        } else {
            self.blur = nil
        }
    }

    init(authors: [String]?) {
        self.originalAuthors = authors
        self.originalAuthor = nil
        if let authors = authors, !authors.isEmpty {
            let authorsString = authors.joined(separator: ", ")
            let byLocalised = LanguageManager.shared.translate(key: .byWithSpace)
            if let lastComma = authorsString.range(of: ",", options: .backwards) {
                let and = String(format: " %@", LanguageManager.shared.translate(key: .and))
                let authorsJoined = authorsString.replacingCharacters(in: lastComma, with: and)
                let authorValue = String(format: "%@%@", byLocalised, authorsJoined)
                self.name = authorValue
            } else {
                if !authorsString.isEmpty {
                    let authorValue = String(format: "%@%@", byLocalised, authorsString)
                    self.name = authorValue
                } else {
                    self.name = nil
                }
            }
        } else {
            self.name = nil
        }
        self.title = nil
        self.bio = nil
        self.key = nil
        self.imageURL = nil
        self.twitter = nil
        self.instagram = nil
        self.facebook = nil
        self.blur = nil
    }
}
