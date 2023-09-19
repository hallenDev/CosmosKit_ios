import UIKit

class ArticlePushNavigationViewController: UINavigationController {}

public class ArticlePushViewController: UIViewController {

    var cosmos: Cosmos!
    var article: ArticleViewModel!
    @IBOutlet var doneButton: UIBarButtonItem!

    public override func viewDidLoad() {
        super.viewDidLoad()
        guard let cosmos = cosmos, let article = article else { return }
        let pager = ArticlePagerViewController(cosmos: cosmos, articles: [article], currentArticle: article)
        pager.viewContext = .pushNotification
        doneButton.title = LanguageManager.shared.translate(key: .done)
        navigationController?.setViewControllers([pager], animated: false)
    }
}
