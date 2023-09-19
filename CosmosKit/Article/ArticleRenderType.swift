import Foundation

public indirect enum ArticleRenderType {
    case live
    case edition
    case staticPage
    case pushNotification(render: ArticleRenderType)

    var isPushNotification: Bool {
        return self == .pushNotification(render: .live) ||
            self == .pushNotification(render: .staticPage) ||
            self == .pushNotification(render: .edition)
    }
}

extension ArticleRenderType: Equatable {
    public static func == (lhs: ArticleRenderType, rhs: ArticleRenderType) -> Bool {
        switch (lhs, rhs) {
        case (.live, .live), (.edition, .edition), (.staticPage, .staticPage):
            return true
        case (.pushNotification(render: .live), .pushNotification(render: .live)):
            return true
        case (.pushNotification(render: .edition), .pushNotification(render: .edition)):
            return true
        case (.pushNotification(render: .staticPage), .pushNotification(render: .staticPage)):
            return true
        default:
            return false
        }
    }
}
