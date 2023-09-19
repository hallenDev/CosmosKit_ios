import Foundation

struct AccountViewModel {

    enum Section: String, CaseIterable {
        case name
        case surname
        case email
        case password
        case logout
        case deleteAccount

        var title: String {
            switch self {
            case .name:
                return LanguageManager.shared.translateUppercased(key: .name)
            case .surname:
                return LanguageManager.shared.translateUppercased(key: .surname)
            case .email:
                return LanguageManager.shared.translateUppercased(key: .email)
            case .password:
                return LanguageManager.shared.translateUppercased(key: .password)
            case .deleteAccount:
                return LanguageManager.shared.translateUppercased(key: .deleteAccount)
            case .logout:
                return LanguageManager.shared.translateUppercased(key: .logout)
            }
        }
    }

    let email: String
    let name: String
    let surname: String
    let sections: [Section]

    init(user: CosmosUser?) {
        email = user?.email ?? "NA"
        name = user?.firstname ?? "NA"
        surname = user?.lastname ?? "NA"
        sections = Section.allCases
    }

    func numberOfSections() -> Int {
        sections.count
    }

    func title(for section: Int) -> String {
        sections[section].title
    }

    func getSection(_ section: Int) -> Section? {
        guard 0 ..< sections.count ~= section else {  return nil }
        return sections[section]
    }
}
