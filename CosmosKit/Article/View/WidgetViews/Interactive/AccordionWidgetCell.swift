// swiftlint:disable force_cast
import UIKit

class AccordionWidgetCell: UITableViewCell {

    @IBOutlet var tableView: AccordionTableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 44
            tableView.sectionHeaderHeight = UITableView.automaticDimension
            tableView.estimatedSectionHeaderHeight = 44
            let nib = UINib(nibName: "AccordionHeader", bundle: Bundle.cosmos)
            tableView.register(nib, forHeaderFooterViewReuseIdentifier: "AccordionHeader")
        }
    }

    var resize: ((AccordionViewModel) -> Void)?
    var viewModel: AccordionViewModel!
    var cosmos: Cosmos!

    var total: Int {
        return viewModel.accordions.count + viewModel.accordions.filter { $0.open }.count
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
        resize = nil
    }

    func configure(with viewModel: AccordionViewModel, cosmos: Cosmos) {
        self.viewModel = viewModel
        self.cosmos = cosmos
        tableView.reloadData()
    }

    func expand(index: Int, parent: Int) -> AccordionViewModel? {
        var new = viewModel
        for item in 0 ..< (new?.accordions.count ?? 0) {
            new?.accordions[item].open = false
        }
        new?.accordions[parent].open = true
        return new
    }

    func collapse(index: Int, parent: Int) -> AccordionViewModel? {
        var new = viewModel
        new?.accordions[parent].open = false
        return new
    }

    func updateAccordion(index: Int, parent: Int) -> AccordionViewModel? {
        if viewModel.accordions[parent].open {
            return collapse(index: index, parent: parent)
        } else {
            return expand(index: index, parent: parent)
        }
    }

    func findParent(index: Int) -> (parent: Int, isParentCell: Bool) {
        var position = 0, parent = 0
        guard position < index else { return (parent, true) }

        var item = self.viewModel.accordions[parent]

        repeat {
            position += item.open ? 2 : 1
            parent += 1

            if parent < self.viewModel.accordions.count {
                item = self.viewModel.accordions[parent]
            }

        } while (position < index)

        if position == index {
            return (parent, true)
        }

        item = self.viewModel.accordions[parent - 1]
        return (parent - 1, false)
    }
}

extension AccordionWidgetCell: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return total
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (parent, isParent) = findParent(index: indexPath.row)

        defer {
            tableView.invalidateIntrinsicContentSize()
        }
        if isParent {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccordionHeaderCell", for: indexPath) as! AccordionHeaderCell
            cell.configure(viewModel: viewModel.accordions[parent], theme: cosmos.theme)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccordionBodyCell", for: indexPath) as! AccordionBodyCell
            cell.configure(text: viewModel.accordions[parent].text, theme: cosmos.theme)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AccordionHeader") as? AccordionHeader
        header?.configure(with: viewModel.title)
        header?.setNeedsLayout()
        return header
    }
}

extension AccordionWidgetCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let (parent, isParent) = findParent(index: indexPath.row)

        guard isParent else { return }

        if let new = updateAccordion(index: indexPath.row, parent: parent) {
            resize?(new)
        }

    }
}

class AccordionTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
