import UIKit

class EditionLoadingCell: UITableViewCell {

    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var background: UIView!

    override func prepareForReuse() {
        super.prepareForReuse()
        spinner.startAnimating()
    }

    func set(theme: Theme?, backgroundColor: UIColor? = nil) {
        guard let theme = theme else { return }
        spinner.color = theme.accentColor
        background.backgroundColor = backgroundColor ?? theme.backgroundColor
    }
}
