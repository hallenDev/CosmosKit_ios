import Foundation

public struct PastEditionsViewModel {
    var editions: [PastEditionViewModel]
    let apiSection: String
    let loaded: Bool
    let featuredContent: Bool

    var featuredEdition: PastEditionViewModel? {
        return editions.first
    }

    init(from pastEditions: [PastEdition], section: String, cosmos: Cosmos) {
        self.editions = pastEditions.map { pastEdition in
            if let persisted = LocalStorage().edition(key: pastEdition.key) {
                return PastEditionViewModel(from: persisted, theme: cosmos.theme)
            } else {
                return PastEditionViewModel(from: pastEdition, theme: cosmos.theme)
            }
        }
        self.apiSection = section
        self.loaded = true
        self.featuredContent = cosmos.editionConfig?.featureLastPastEdition ??  false
    }

    init(from editions: [Edition], section: String, cosmos: Cosmos) {
        self.editions = editions.map { PastEditionViewModel(from: $0, theme: cosmos.theme) }
        self.apiSection = section
        self.loaded = true
        self.featuredContent = cosmos.editionConfig?.featureLastPastEdition ??  false
    }

    init(section: String, cosmos: Cosmos) {
        self.editions = []
        self.apiSection = section
        self.loaded = false
        self.featuredContent = false
    }

    func edition(for indexPath: IndexPath) -> PastEditionViewModel? {
        var index = indexPath.row
        if featuredContent {
            index += 1
        }
        guard !editions.isEmpty,
            index < editions.count else {
                return nil
        }
        return editions[index]
    }

    func sectionCount() -> Int {
        guard loaded else { return 0 }

        if featuredContent {
            if editions.count > 0 {
                return 1
            } else {
                return 0
            }
        } else {
            return 1
        }
    }

    func rowCount() -> Int {
        guard loaded else { return 0 }

        if featuredContent {
            return editions.count - 1
        }
        return editions.count
    }

    mutating func add(_ list: [PastEdition], theme: Theme) {
        editions.append(contentsOf: list.map { pastEdition in
            if let persisted = LocalStorage().edition(key: pastEdition.key) {
                return PastEditionViewModel(from: persisted, theme: theme)
            } else {
                return PastEditionViewModel(from: pastEdition, theme: theme)
            }
        })
    }
}
