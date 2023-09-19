import Foundation

public struct EditionConfig {
    let editionCell: CustomUIPair?
    let featureLastPastEdition: Bool
    let showAllPastEditions: Bool

    public init(editionCell: CustomUIPair? = nil, featureLastPastEdition: Bool, showAllPastEditions: Bool) {
        self.editionCell = editionCell
        self.featureLastPastEdition = featureLastPastEdition
        self.showAllPastEditions = showAllPastEditions
    }
}
