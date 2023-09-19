import Foundation

struct SettingsViewModel {

    private let cosmos: Cosmos
    let config: SettingsConfig
    private var sections: [SettingsSectionViewModel]

    init(cosmos: Cosmos) {
        self.cosmos = cosmos
        self.config = cosmos.settingsConfig
        self.sections = [
            SettingsSectionViewModel(translatedTitle: LanguageManager.shared.translateUppercased(key: .account),
                                     content: config.accountContent),
            SettingsSectionViewModel(translatedTitle: LanguageManager.shared.translateUppercased(key: .general),
                                     content: config.generalContent),
            SettingsSectionViewModel(translatedTitle: LanguageManager.shared.translateUppercased(key: .about),
                                     content: config.aboutContent)
        ]
        if Environment.showDebugMenu() {
            sections.insert(SettingsSectionViewModel(translatedTitle: "Debug", content: [.debugMenu]), at: 0)
        }
    }

    func getSectionViewModel(in section: Int) -> SettingsSectionViewModel? {
        guard 0 ..< sectionCount() ~= section else { return nil }
        return sections[section]
    }

    func getSectionViewModel(at indexPath: IndexPath) -> SettingsSectionViewModel? {
        guard 0 ..< sectionCount() ~= indexPath.section else { return nil }
        return sections[indexPath.section]
    }

    func getSettingsOption(at indexPath: IndexPath) -> SettingsOption? {
        guard 0 ..< sectionCount() ~= indexPath.section else { return nil }
        guard 0 ..< rowCount(in: indexPath.section) ~= indexPath.row else { return nil }
        return sections[indexPath.section].content[indexPath.row]
    }

    func sectionCount() -> Int {
        return sections.count
    }

    func rowCount(in section: Int) -> Int {
        guard 0 ..< sectionCount() ~= section else { return 0 }
        return sections[section].content.count
    }
}

struct SettingsSectionViewModel {
    let title: String
    let content: [SettingsOption]

    init(translatedTitle: String, content: [SettingsOption]) {
        self.title = translatedTitle
        self.content = content
    }
}
