import Foundation
import UIKit

public class LoadingFooter: UICollectionReusableView {

    @IBOutlet var spinner: UIActivityIndicatorView!

    func configure(theme: Theme) {
        spinner.color = theme.accentColor
        backgroundColor = theme.backgroundColor
    }
}
