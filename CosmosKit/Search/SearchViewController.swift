import Foundation
import AMScrollingNavbar
import UIKit

class SearchNavigationViewController: UINavigationController {}  // AMScrollingNavbar.ScrollingNavigationController {}

class SearchViewController: UIViewController {

    var cosmos: Cosmos!
    var viewModel: SearchViewModel!

    @IBOutlet var backgroundView: UIView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var accentView: UIView!
    @IBOutlet var searchterm: SearchField! {
        didSet {
            searchterm.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        hideBackButtonTitle()
        cancelButton.setTitle(LanguageManager.shared.translate(key: .cancel), for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchterm.becomeFirstResponder()
    }

    func configureView() {
        backgroundView.backgroundColor = cosmos.navigationTheme.color
        cancelButton.setTitleColor(cosmos.navigationTheme.buttonTextColor, for: .normal)
        accentView.backgroundColor = cosmos.theme.accentColor
        view.backgroundColor = cosmos.theme.backgroundColor
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension SearchViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchTerm = textField.text,
            !searchTerm.isEmpty {
            if viewModel.renderType == .edition {
                let view = cosmos.getEditionView(for: searchTerm)
                self.navigationController?.pushViewController(view, animated: true)
            } else {
                let view = cosmos.getArticleListView(for: searchTerm)
                self.navigationController?.pushViewController(view, animated: true)
            }
        } else {
            Alerter.alert(translatedMessage: LanguageManager.shared.translate(key: .enterSearchTerm))
        }
        return false
    }
}
