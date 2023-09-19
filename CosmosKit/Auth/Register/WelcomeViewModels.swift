import Foundation

struct InformationViewModel {
    var data: WelcomeData

    init() {
        self.init(data: WelcomeData())
    }

    init(data: WelcomeData) {
        self.data = data
    }
}

struct PasswordViewModel {
    var data: WelcomeData

    init(data: WelcomeData) {
        self.data = data
    }
}

struct NewslettersViewModel {
    var data: WelcomeData
    var availableNewsletters: PublicationNewslettersViewModel?

    init(data: WelcomeData) {
        self.data = data
    }

    var totalNewsletters: Int {
        availableNewsletters?.newsletters.count ?? 0
    }

    mutating func setNewsletters(_ list: PublicationNewslettersViewModel) {
        availableNewsletters = list
    }

    func newsletter(at indexPath: IndexPath) -> NewsletterViewModel? {
        guard 0..<totalNewsletters ~= indexPath.row else { return nil }
        return availableNewsletters?.newsletters[indexPath.row]
    }

    func getSubscribed() -> [NewsletterViewModel] {
        availableNewsletters?.newsletters.filter { $0.selected } ?? []
    }

    mutating func subscribe(to indexPath: IndexPath) {
        guard 0..<totalNewsletters ~= indexPath.row else { return }
        availableNewsletters?.subscribe(to: indexPath)
    }

    mutating func unsubscribe(to indexPath: IndexPath) {
        guard 0..<totalNewsletters ~= indexPath.row else { return }
        availableNewsletters?.unsubscribe(to: indexPath)
    }
}

public struct NewsletterViewModel {
    let id: String
    let name: String
    let visible: Bool
    var selected = false
}

public struct PublicationNewslettersViewModel {
    let description: String
    let name: String
    let id: String
    var newsletters: [NewsletterViewModel]

    mutating func subscribe(to indexPath: IndexPath) {
        newsletters[indexPath.row].selected = true
    }

    mutating func unsubscribe(to indexPath: IndexPath) {
        newsletters[indexPath.row].selected = false
    }
}
