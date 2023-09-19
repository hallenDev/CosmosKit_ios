import UIKit

public typealias EmptyCallBack = () -> Void

class ArticleOffline: UIView {

    @IBOutlet var descriptionLabel: OfflineWidgetLabel!
    var reloadCallback: EmptyCallBack?
    @IBOutlet weak var reloadButton: OfflineWidgetButton!

    func configure(frame: CGRect, type: WidgetType, reload: @escaping EmptyCallBack) {
        self.descriptionLabel.text = type.reloadDescription.localizedUppercase
        reloadButton.setTitle(LanguageManager.shared.translate(key: .reload), for: .normal)
        self.frame = frame
        self.reloadCallback = reload
    }

    @IBAction func reload(_ sender: Any) {
        reloadCallback?()
    }
}
