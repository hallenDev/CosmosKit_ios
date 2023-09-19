import UIKit

class AccountViewController: UITableViewController, HeaderEnabledViewController {

    var cosmos: Cosmos!
    var viewModel: AccountViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AccountViewModel(user: cosmos.user)
        applyTheme()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let title = LanguageManager.shared.translateUppercased(key: .profile)
        addHeaderView(title: title,
                      theme: cosmos.theme,
                      tableView: tableView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.navigationBar.configureNav(cosmos: self.cosmos)
        }
    }

    fileprivate func applyTheme() {
        navigationController?.navigationBar.configureNav(cosmos: cosmos)
        view.backgroundColor = cosmos.theme.backgroundColor
        tableView.separatorColor = cosmos.theme.separatorColor
        tableView.backgroundColor = cosmos.theme.backgroundColor
    }
}

extension AccountViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = viewModel.getSection(indexPath.section) else {
            let cell = UITableViewCell()
            cell.backgroundColor = cosmos.theme.backgroundColor
            cell.contentView.backgroundColor = cosmos.theme.backgroundColor
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath)
        cell.textLabel?.textColor = cosmos.settingsTheme.settingColor
        cell.backgroundColor = cosmos.theme.backgroundColor
        cell.contentView.backgroundColor = cosmos.theme.backgroundColor

        switch section {
        case .name:
            cell.textLabel?.text = viewModel.name
        case .surname:
            cell.textLabel?.text = viewModel.surname
        case .email:
            cell.textLabel?.text = viewModel.email
        case .password:
            cell.textLabel?.text = "••••••••••"
            cell.accessoryType = .disclosureIndicator
        case .logout:
            let btnText = LanguageManager.shared.translateUppercased(key: .logout)
            cell.textLabel?.text = btnText
            cell.textLabel?.textColor = cosmos.theme.accentColor
        case .deleteAccount:
            let btnText = LanguageManager.shared.translateUppercased(key: .deleteAccount)
            cell.textLabel?.text = btnText
            cell.textLabel?.textColor = cosmos.theme.accentColor
        }
    
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionVM = viewModel.getSection(section) else { return 0 }
        switch sectionVM {
        case .logout: return 0
        case .deleteAccount: return 0
        default: return 44
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionVM = viewModel.getSection(section) else { return nil }
        switch sectionVM {
        case .logout: return nil
        default:
            let header = SettingsSectionHeaderView.fromNib()
            header?.configure(title: viewModel.title(for: section), theme: cosmos.theme)
            return header
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = viewModel.getSection(indexPath.section) else { return }
        switch section {
        case .password:
            resetPassword()
        case .logout:
            logout()
        case .deleteAccount:
            deleteAccount()
        default:
            break
        }

    }

    fileprivate func resetPassword() {
        let loginController: LoginContainerViewController = CosmosStoryboard.loadViewController()
        loginController.cosmos = cosmos
        let childView = loginController.view
        childView?.layoutIfNeeded()
        loginController.modalPresentationStyle = .fullScreen
        self.present(loginController, animated: true, completion: nil)
        loginController.currentViewController.performSegue(withIdentifier: "ResetPassword", sender: self)
    }

    fileprivate func logout() {
        cosmos.logout()
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func deleteAccount() {
        let alert = UIAlertController(title: "Delete Account",
                                      message: "Deleting your account will delete your access and all your personal information.\n\nIf you have a recurring subscription, you must cancel that first to stop payments.\n\nAre you sure you want to continue?",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: LanguageManager.shared.translate(key: .yes),
                                      style: .default,
                                      handler: { _ in
            alert.dismiss(animated: true, completion: nil)
            
            let request = DeleteUserRequest()
            self.cosmos.deleteUser(data: request) { success in
                DispatchQueue.main.async {
                    self.logout()
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: LanguageManager.shared.translate(key: .no),
                                      style: .cancel,
                                      handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
