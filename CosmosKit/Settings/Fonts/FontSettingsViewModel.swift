import Foundation

struct FontSettingsViewModel {
    let cosmos: Cosmos
    let defaults: CosmosDefaults
    let theme: Theme

    init(cosmos: Cosmos, defaults: CosmosDefaults? = nil) {
        self.theme = cosmos.theme
        self.cosmos = cosmos
        self.defaults = defaults ?? CosmosDefaults()
    }

    func set(option: FontSettingsViewController.FontOptions) {
        defaults.setBodyFontSize(option.textStyle)
    }

    func getStoredStyle() -> Int {
        FontSettingsViewController.FontOptions(textStyle: defaults.getBodyFontSize()).rawValue
    }
}
