import Foundation

struct QuoteViewModel: WidgetViewModel {

    var type: WidgetType = .quote

    static func create(from widget: Widget) -> WidgetViewModel {
        guard let data = widget.data as? QuoteWidgetData else {
            fatalError("failed to parse data")
        }
        return QuoteViewModel(from: data)
    }

    let quote: String
    let cite: String?

    init(from quote: QuoteWidgetData) {
        self.quote = "\u{201C} \(quote.quote) \u{201D}"
        if let cite = quote.cite, !cite.isEmpty {
            self.cite = "- \(cite)"
        } else {
            self.cite = nil
        }
    }
}
