// swiftlint:disable line_length
import Foundation

public struct WidgetStackViewModel {

    let widgets: [WidgetViewModel]
    let renderType: ArticleRenderType
    let title: String
    let fallback: Fallback
    let event: CosmosEvent
    let forceLightMode: Bool

    public init(title: String = "", widgets: [WidgetViewModel], renderType: ArticleRenderType, fallback: Fallback, event: CosmosEvent, forceLightMode: Bool = false) {
        self.widgets = widgets
        self.renderType = renderType
        self.title = title
        self.fallback = fallback
        self.event = event
        self.forceLightMode = forceLightMode
    }
}
