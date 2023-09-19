import UIKit
import StoreKit
import UserNotifications

public class SettingsViewController: UITableViewController, HeaderEnabledViewController {

    enum CellType: String {
        case standard = "SettingsCell"
        case rightDetail = "SettingsDetailCell"
        case withSwitch = "SettingsToggleCell"
    }

    var cosmos: Cosmos!
    var viewModel: SettingsViewModel!

    override public func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SettingsViewModel(cosmos: cosmos)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updatePushSwitch),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        applyTheme()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addHeaderView(title: LanguageManager.shared.translateUppercased(key: .headingSettings),
                      theme: cosmos.theme,
                      tableView: tableView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.navigationBar.configureNav(cosmos: self.cosmos)
        }
        // NOTE: added this in because on the settings screen, when navigating back we would get
        //       a y value of 0 and the status bar would hover towards the top and stay there
        //       also the dropdown would not respond to touch for some reason
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cosmos.logger?.log(event: CosmosEvents.settings)
        tableView.reloadData()
    }

    fileprivate func applyTheme() {
        tableView.separatorColor = cosmos.theme.separatorColor
        view.backgroundColor = cosmos.theme.backgroundColor
        tableView.backgroundColor = cosmos.theme.backgroundColor
    }

    fileprivate func getAppVersionInfo() -> String {
        let versionString = Bundle.main.getOptionalValue(for: .version)
        let buildString = Bundle.main.getOptionalValue(for: .build)
        let cosmosVersion = Bundle.cosmos.getOptionalValue(for: .version)
        return String(format: "%@ (%@)/%@", versionString ?? "NA", buildString ?? "NA", cosmosVersion ?? "NA")
    }

    @objc func updatePushSwitch() {
        tableView.reloadData()
    }

    func openAppSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings)
        }
    }

    func showStatic(_ slug: String) {
        DispatchQueue.main.async {
            let view = self.cosmos.getView(for: slug,
                                      as: .staticPage,
                                      relatedSelected: { _ in })
            view.edgesForExtendedLayout = []
            self.show(view, sender: self)
        }
    }

    func showConfirmation() {
        let alert = UIAlertController(title: LanguageManager.shared.translate(key: .success),
                                      message: LanguageManager.shared.translate(key: .pastEditionsCleared),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LanguageManager.shared.translateUppercased(key: .ok), style: .default, handler: { _ in
            alert.dismiss(animated: true)
        }))
        DispatchQueue.main.async {
            UIApplication.shared.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }
}
// MARK: UITableView Delegates and Datasource methods
extension SettingsViewController {

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let option = viewModel.getSettingsOption(at: indexPath) else {
            let cell = UITableViewCell()
            cell.backgroundColor = cosmos.theme.backgroundColor
            cell.contentView.backgroundColor = cosmos.theme.backgroundColor
            return cell
        }

        let cell: UITableViewCell

        switch option {
        case .account:
            cell = tableView.dequeueReusableCell(withIdentifier: CellType.standard.rawValue, for: indexPath)
            if cosmos.user == nil {
                cell.textLabel?.text = LanguageManager.shared.translate(key: .signIn)
            } else {
                cell.textLabel?.text = LanguageManager.shared.translate(key: .profile)
            }
        case .pushNotifications:
            cell = tableView.dequeueReusableCell(withIdentifier: CellType.withSwitch.rawValue, for: indexPath)
            (cell as? SettingsToggleCell)?.configure(option: option, theme: cosmos.theme) { [weak self] in
                self?.openAppSettings()
            }
        case .appVersion:
            cell = tableView.dequeueReusableCell(withIdentifier: CellType.rightDetail.rawValue, for: indexPath)
            cell.textLabel?.text = option.translation
            cell.detailTextLabel?.text = getAppVersionInfo()
            cell.detailTextLabel?.textColor = cosmos.settingsTheme.settingColor
        case .reviewApp, .clearAllEditions:
            cell = tableView.dequeueReusableCell(withIdentifier: CellType.standard.rawValue, for: indexPath)
            cell.textLabel?.text = option.translation
            cell.accessoryType = .none
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: CellType.standard.rawValue, for: indexPath)
            cell.textLabel?.text = option.translation
        }

        cell.textLabel?.textColor = cosmos.settingsTheme.settingColor
        cell.backgroundColor = cosmos.theme.backgroundColor
        cell.contentView.backgroundColor = cosmos.theme.backgroundColor

        return cell
    }

    public override func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sectionCount()
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.rowCount(in: section)
    }

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let option = viewModel.getSettingsOption(at: indexPath) else { return }

        switch option {
        case .manageNotifications:
            let settings: SwitchSettingsViewController = CosmosStoryboard.loadViewController()
            settings.viewModel = PushNotificationsSettingsViewModel(cosmos: cosmos)
            show(settings, sender: self)
        case .manageNewsletters:
            let settings: SwitchSettingsViewController = CosmosStoryboard.loadViewController()
            settings.viewModel = NewslettersSettingsViewModel(cosmos: cosmos)
            show(settings, sender: self)
        case .debugMenu:
            let debug: DebugViewController = CosmosStoryboard.loadViewController()
            debug.viewModel = DebugViewModel(cosmos: cosmos)
            show(debug, sender: self)
        case .account:
            if cosmos.user == nil {
                showAuth()
            } else {
                let profile: AccountViewController = CosmosStoryboard.loadViewController()
                profile.cosmos = cosmos
                show(profile, sender: self)
            }
        case .bookmarks:
            let bookmarks = cosmos.getArticleListBookmarksView(context: .bookmarksFromSettings)
            show(bookmarks, sender: self)
        case .pushNotifications:
            openAppSettings()
        case .reviewApp:
            if Environment.isRelease {
                SKStoreReviewController.requestReview()
            }
        case .clearAllEditions:
            cosmos.removePersistedEditions()
            showConfirmation()
        case .about:
            self.showStatic(viewModel.config.aboutUsSlug)
        case .contactUs:
            self.showStatic(viewModel.config.contactUsSlug)
        case .aboutAndContactUs:
            self.showStatic(viewModel.config.aboutAndContactUsSlug)
        case .termsOfService:
            self.showStatic(viewModel.config.termsSlug)
        case .privacyPolicy:
            self.showStatic(viewModel.config.privacySlug)
        case .appVersion: break
        case .fontSettings:
            let fontsettings: FontSettingsViewController = CosmosStoryboard.loadViewController()
            fontsettings.viewModel = FontSettingsViewModel(cosmos: cosmos)
            show(fontsettings, sender: self)
        }
    }

    private func showAuth() {
        if FeatureFlag.newWelcomeFlow.isEnabled {
//            let login: WelcomeLandingViewController = CosmosStoryboard.loadViewController()
//            login.configure(cosmos: cosmos)
//            let nav = UINavigationController(rootViewController: login)
//            nav.modalPresentationStyle = .fullScreen
//            present(nav, animated: true, completion: nil)
        } else {
            let login: LoginContainerViewController = CosmosStoryboard.loadViewController()
            login.cosmos = cosmos
            login.modalPresentationStyle = .fullScreen
            present(login, animated: true, completion: nil)

//            let login: NewsletterRegisterViewController /*InformationViewController*/ = CosmosStoryboard.loadViewController()
//            login.cosmos = cosmos
//            let nav = UINavigationController(rootViewController: login)
//            nav.modalPresentationStyle = .fullScreen
//            present(nav, animated: true, completion: nil)
        }
    }

    override public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewm = viewModel.getSectionViewModel(in: section) else { return nil }
        let header = SettingsSectionHeaderView.fromNib()
        header?.configure(title: viewm.title, theme: cosmos.theme)
        return header
    }
}
