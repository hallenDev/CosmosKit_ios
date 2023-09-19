import Foundation

public struct Social: Codable {
    let twitter: String?
    let facebook: String?
    let instagram: String?
}

public struct Author: Codable {
    let name: String?
    let title: String?
    let bio: String?
    let image: Image?
    let social: Social?
    let key: Int64?

    init(name: String?, title: String?, bio: String?, image: Image?, social: Social?, key: Int64?) {
        self.title = title
        self.name = name
        self.bio = bio
        self.image = image
        self.social = social
        self.key = key
    }

    init(name: String, title: String, image: Image) {
        self.init(name: name, title: title, bio: nil, image: image, social: nil, key: nil)
    }
}
