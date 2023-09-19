import Foundation

protocol HeaderEnabledViewController: UIViewController {}

extension HeaderEnabledViewController {

    func addHeaderView(title: String, theme: Theme, tableView: UITableView? = nil) {
        let header = ViewHeader.instanceFromNib(title: title, theme: theme)
        if let tabView = tableView {
            tabView.tableHeaderView = header
        } else {
            view.addSubview(header)
            NSLayoutConstraint.activate([
                header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                header.topAnchor.constraint(equalTo: view.topAnchor)
            ])
        }
    }
}
