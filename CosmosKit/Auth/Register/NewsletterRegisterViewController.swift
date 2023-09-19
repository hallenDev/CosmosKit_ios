import Foundation
//import BEMCheckBox

class NewsletterRegisterViewController: UIViewController {
    
    var theme: Theme?
    var cosmos: Cosmos!
    var welcomeData: WelcomeData!
    var newsletters: [PublicationNewslettersViewModel]?
    
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var nextBtn: LoginButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var newsletterViewModel: NewslettersViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "NewsletterHeaderView", bundle: Bundle.cosmos), forHeaderFooterViewReuseIdentifier: "NewsletterHeaderView")
        
        tableView.dataSource = self
        tableView.delegate = self
        

        if self.theme == nil {
            configure(cosmos.theme)
        }
        configureTranslations()
        getNewsletters()
    }
    
    private func configureTranslations() {
        // do translations here
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func getNewsletters() {
        cosmos.getNewsletters { [weak self] letters, error in
            if let letters = letters {
                DispatchQueue.main.async {
                    self?.updateView(with: letters)
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }

    func updateView(with letters: [PublicationNewslettersViewModel]) {
        newsletters = letters
        tableView.reloadData()
    }

    @IBAction func onNextBtn(_ sender: Any) {
        showActivity(busy: true)
        let request = UserProfileUpdateRequest(
            firstName: welcomeData.firstName ?? "",
            lastName: welcomeData.lastName ?? "",
            password: welcomeData.password ?? ""
        )
        cosmos.updateUserProfile(data: request) { success in
            if (success) {
                self.updateNewsletters()
            } else {
                DispatchQueue.main.async {
                    self.showActivity(busy: false)
                }
            }
        }
    }
    
    func updateNewsletters() {
        var selected_newsletters: [String] = []
        for i in 0..<newsletters!.count {
            let n = newsletters![i].newsletters.count
            for j in 0..<n {
                let selected = newsletters![i].newsletters[j].selected ?? false
                if (selected) {
                    selected_newsletters.append(newsletters![i].newsletters[j].id)
                }
            }
        }
        let request = UserUpdateRequest(
            firstName: welcomeData.firstName ?? "",
            lastName: welcomeData.lastName ?? "",
            newsletters: selected_newsletters,
            email: cosmos.user?.email ?? "",
            telNumber: welcomeData.mobileNumber ?? ""
        )
        cosmos.updateUser(data: request) { success in
            DispatchQueue.main.async {
                self.showActivity(busy: false)
                self.navigationController?.dismiss(animated: true)
            }
        }
    }
    
    func showActivity(busy: Bool) {
        if busy {
            activityIndicator.startAnimating()
            nextBtn.setTitle(nil, for: .normal)
        } else {
            activityIndicator.stopAnimating()
            let btnTitle = LanguageManager.shared.translateUppercased(key: .register)
            nextBtn.setTitle(btnTitle, for: .normal)
        }
    }
//
//    override func processData(completion: (Result<WelcomeData, CosmosError>) -> Void) {
//        // TODO: waiting for final API calls from arena
//        var update = viewModel.data
//        update.newsletters = newsletterViewModel.getSubscribed()
//        completion(.success(update))
//    }
}

extension NewsletterRegisterViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return newsletters?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsletters?[section].newsletters.count ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "NewsletterHeaderView") as? NewsletterHeaderView else {
            return UITableViewHeaderFooterView()
        }
        header.newsletterLabel.text = newsletters?[section].name ?? ""
        header.descriptionLabel.text = newsletters?[section].description ?? ""
        header.applyTheme(theme: cosmos.theme)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsletterCell", for: indexPath) as? NewsletterCell else {
            return UITableViewCell()
        }
        
        cell.letterLabel.text = newsletters?[indexPath.section].newsletters[indexPath.row].name ?? ""
        cell.applyTheme(theme: cosmos.theme)
        cell.checkbox.isEnabled = false
        let selected = newsletters?[indexPath.section].newsletters[indexPath.row].selected ?? false
        if (selected) {
            cell.checkbox.isChecked = true
        } else {
            cell.checkbox.isChecked = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = newsletters?[indexPath.section].newsletters[indexPath.row].selected ?? false
        newsletters?[indexPath.section].newsletters[indexPath.row].selected = !selected
        tableView.reloadData()
    }
}

extension NewsletterRegisterViewController: ThemeInjectable {
    func configure(_ theme: Theme) {
        self.theme = theme
        guard let legacyTheme = theme.legacyAuthTheme else { fatalError("No legacy theme provided") }

        view.backgroundColor = legacyTheme.backgroundColor
        logoView.image = legacyTheme.logo

        nextBtn.backgroundColor = theme.accentColor
        let color = legacyTheme.mainButtonColor ?? legacyTheme.backgroundColor
        nextBtn.setTitleColor(color, for: .normal)
        nextBtn.titleLabel?.font = legacyTheme.mainButtonFont
    }
}
