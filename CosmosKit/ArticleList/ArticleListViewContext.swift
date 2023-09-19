import Foundation

public enum ArticleListViewContext {
    case normal
    case section
    case search
    case bookmarksFromTab
    case bookmarksFromSettings

    func adPath(section: String? = nil, subSection: String? = nil) -> String {
        switch self {
        case .normal, .search:
            return "home/"
        case .section:
            if let section = section, let subSection = subSection {
                return "\(section)/\(subSection)/"
            } else if let section = section {
                return "\(section)/"
            } else {
                return ""
            }
        default: return ""
        }
    }
}
