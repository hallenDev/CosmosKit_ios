import UIKit
import Foundation

class FeaturedPastEditionHeader: UICollectionReusableView {

    @IBOutlet var editionImage: UIImageView!
    @IBOutlet var readEditionButton: PastEditionFeaturedButton!
    @IBOutlet var editionDate: PastEditionsDateLabel!
    @IBOutlet var articleCount: PastEditionsArticleLabel!
    var didSelectFeature: EmptyCallBack?

    func configure(with viewModel: PastEditionViewModel, theme: EditionTheme?, openFeature: @escaping EmptyCallBack) {
        didSelectFeature = openFeature
        articleCount.text = viewModel.articleCount
        editionDate.text = viewModel.title
        editionImage.image = viewModel.image?.blur
        if let url = viewModel.image?.imageURL {
            editionImage.kf.setImage(with: url, placeholder: viewModel.image?.blur)
        }

        readEditionButton.layer.cornerRadius = readEditionButton.frame.height/2
        if let theme = theme, let buttonFont = theme.pastEditionTheme.featuredButtonFont {
            readEditionButton.titleLabel?.font = UIFont(name: buttonFont.fontName, textStyle: .caption1)!
        }
        readEditionButton.setTitle(LanguageManager.shared.translateUppercased(key: .readEdition),
                                   for: .normal)
    }

    @IBAction func readEdition(_ sender: Any) {
        didSelectFeature?()
    }
}
