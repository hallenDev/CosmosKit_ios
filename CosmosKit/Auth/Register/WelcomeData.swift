import Foundation

struct WelcomeData {

    var firstName: String?
    var lastName: String?
    var email: String?
    var mobileNumber: String?
    var password: String?
    var newsletters: [NewsletterViewModel]?

    // swiftlint:disable:next line_length
    init(firstName: String? = nil, lastName: String? = nil, email: String? = nil, mobileNumber: String? = nil, password: String? = nil, newsletters: [NewsletterViewModel]? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.mobileNumber = mobileNumber
        self.password = password
        self.newsletters = newsletters
    }
}
