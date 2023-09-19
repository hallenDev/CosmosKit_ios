import UIKit

class SwitchSettingsViewController: UIViewController, HeaderEnabledViewController, CosmosActivityEnabledViewController {

    @IBOutlet var infoLabel: WelcomeDescriptionLabel!
    @IBOutlet var tableView: UITableView!

    var viewModel: SwitchSettingViewModel!
    var activityIndicator: CosmosActivityIndicator!
    var cosmos: Cosmos! {
        get { viewModel.cosmos }
        set { viewModel.cosmos = newValue }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        infoLabel.text = viewModel.info
        applyTheme()
        configureActivityIndicator(forceUIKit: true)
        reloadData()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadData),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }

    @objc fileprivate func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.start()
            self?.viewModel.retrieveValues {
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                    self?.activityIndicator.stop()
                }
            }
        }
    }

    private func applyTheme() {
        tableView.separatorColor = viewModel.theme.separatorColor
        view.backgroundColor = viewModel.theme.backgroundColor
        tableView.backgroundColor = viewModel.theme.backgroundColor
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addHeaderView(title: viewModel.title, theme: viewModel.theme)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.navigationBar.configureNav(cosmos: self.viewModel.cosmos)
        }
    }

}

extension SwitchSettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.rows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath)
        if let value = viewModel.getValue(at: indexPath) {
            (cell as? CosmosSwitchCell)?.configure(theme: viewModel.theme,
                                                   title: value.title,
                                                   value: value.enabled,
                                                   switchChanged: { [weak self] enabled in
                                                    self?.viewModel.valueChanged(enabled: enabled, at: indexPath) { _ in
                                                        self?.reloadData()
                                                    }
                                                   })
        }
        return cell
    }
}
