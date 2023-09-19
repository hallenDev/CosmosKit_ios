import Foundation

class AuthorCell: UITableViewCell {

    @IBOutlet var name: AuthorCellNameLabel!
    @IBOutlet var title: AuthorCellTitleLabel!
    @IBOutlet var picture: UIImageView!

    func configure(viewModel: AuthorViewModel, theme: Theme) {
        self.name.text = viewModel.name
        self.title.text = viewModel.title

        if let url = viewModel.imageURL {
            picture.kf.setImage(with: url, placeholder: viewModel.blur)
        } else {
            picture.image = viewModel.blur
        }

        picture.layer.cornerRadius = picture.frame.height/2
        contentView.backgroundColor = theme.backgroundColor
    }
}
