import UIKit
import Kingfisher

public class PastEditionCell: UICollectionViewCell {
    @IBOutlet var editionArticleCount: PastEditionsArticleLabel!
    @IBOutlet var editionTitle: PastEditionsDateLabel!
    @IBOutlet var editionImage: UIImageView!
    @IBOutlet var persistedIcon: UIImageView!

    func configure(with viewModel: PastEditionViewModel) {
        editionArticleCount.text = viewModel.articleCount
        editionTitle.text = viewModel.title
        editionImage.image = viewModel.image?.blur
        if let url = viewModel.image?.imageURL {
            editionImage.kf.setImage(with: url, placeholder: viewModel.image?.blur)
        }
        persistedIcon.isHidden = viewModel.isPersisted
        setBorder()
    }

    fileprivate func setBorder() {
        layer.borderWidth = 1.0
        if #available(iOS 13.0, *) {
            layer.borderColor = UIColor(dynamicProvider: { trait -> UIColor in
                if trait.userInterfaceStyle == .dark {
                    return .black
                } else {
                    return Theme.cellBorderGray
                }
            }).cgColor
        } else {
            layer.borderColor = Theme.cellBorderGray.cgColor
        }
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setBorder()
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        editionImage.image = nil
        persistedIcon.isHidden = false
    }
}
