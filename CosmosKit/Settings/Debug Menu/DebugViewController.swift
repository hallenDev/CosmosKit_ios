import UIKit

class DebugViewController: UITableViewController {

    var viewModel: DebugViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewModel.theme.backgroundColor
        tableView.backgroundColor = viewModel.theme.backgroundColor
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.rows(in: section)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections()
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.sectionTitle(in: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DebugCell", for: indexPath)
        if let option = viewModel.getOption(at: indexPath) {
            cell.accessoryType = option.accessory
            cell.textLabel?.text = option.title
        }
        cell.contentView.backgroundColor = viewModel.theme.backgroundColor
        cell.backgroundColor = viewModel.theme.backgroundColor
        cell.textLabel?.textColor = viewModel.cosmos.settingsTheme.settingColor
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.select(indexPath)
        viewModel.refreshContent()
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        guard indexPath.section == 1 && indexPath.row == 0 else { return }
        Alerter.alert(translatedMessage: "This will copy your Firebase APNS token to your device's clipboard.")
    }
}
