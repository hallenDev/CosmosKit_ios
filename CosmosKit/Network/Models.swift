struct RequestToken: Codable {
    let token: String
}

struct AccessToken: Codable {
    let token: String
    let expires: String
}

public struct DisqusAuth: Codable {
    let token: String

    enum CodingKeys: String, CodingKey {
        case token = "comment_auth"
    }
}

public struct InstagramPost: Codable {
    let html: String
}

public struct ArticlePublication: Codable {
    public let identifier: String

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
    }
}

struct ArticleSponsor: Codable {}

public struct MarketData: WidgetData {
    public let symbol: String
}

public struct DeleteUserRequest: Codable {}

public struct UserUpdateRequest: Codable {
    init(firstName: String, lastName: String, newsletters: [String], email: String, telNumber: String, everlytics: Bool = true) {
        self.firstName = firstName
        self.lastName = lastName
        self.newsletters = newsletters
        self.email = email
        self.telNumber = telNumber
        self.everlytics = everlytics
    }

    let firstName: String
    let lastName: String
    let newsletters: [String]
    let email: String
    let telNumber: String
    let everlytics: Bool

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case newsletters = "id"
        case email
        case telNumber = "tel_number"
        case everlytics = "call_everlytics"
    }
}

public struct UserProfileUpdateRequest: Codable {
    let firstName: String
    let lastName: String
    let password: String
    let passwordConfirm: String

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case password = "password_new"
        case passwordConfirm = "password_new_confirm"
    }

    init(firstName: String, lastName: String, password: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.passwordConfirm = password
    }
}

public typealias NewsletterResponse = [String: NewsletterPublication]

public struct NewsletterPublication: Codable {
    let text: String
    let name: String
    let data: [[String: Newsletter]]
}

public struct Newsletter: Codable {
    let name: String
    let visible: Bool
}
