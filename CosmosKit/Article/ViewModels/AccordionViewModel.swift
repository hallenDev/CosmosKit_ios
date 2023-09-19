import Foundation

struct AccordionViewModel: WidgetViewModel {

    var type: WidgetType = .accordion

    static func create(from widget: Widget) -> WidgetViewModel {
        guard let accordionData = widget.data as? AccordionWidgetData else {
            fatalError("failed to parse data")
        }
        return AccordionViewModel(from: accordionData)
    }

    var accordions: [AccordionItemViewModel]
    let title: String

    init(from accordionData: AccordionWidgetData) {
        self.accordions = accordionData.accordions.map { AccordionItemViewModel(from: $0) }
        self.title = accordionData.title
    }
}

struct AccordionItemViewModel {

    let text: String
    let title: String
    var open = false

    init(from accordionData: AccordionData) {
        self.text = accordionData.text
        self.title = accordionData.title
    }
}
