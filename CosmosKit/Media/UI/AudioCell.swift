import Foundation

class AudioCell: UITableViewCell {

    @IBOutlet var thumbnail: UIImageView!
    @IBOutlet var section: VideoCellSectionLabel!
    @IBOutlet var title: VideoCellTitleLabel!
    @IBOutlet var published: VideoCellTimeLabel!
    @IBOutlet var sectionBlock: VideoSectionBlock!

    var viewModel: MediaViewModel!
    var cosmos: Cosmos!

    func configure(for audio: MediaViewModel, cosmos: Cosmos) {
        viewModel = audio
        self.cosmos = cosmos

        title.text = audio.title
        section.text = audio.section
        published.text = audio.published

        let placeHolder = UIImage(cosmosName: .videoPlaceholder)
        if let thumb = audio.thumbnail, let url = URL(string: thumb) {
            thumbnail.kf.setImage(with: url, placeholder: placeHolder)
        } else {
            thumbnail.image = placeHolder
        }

        applyTheme()
    }

    fileprivate func applyTheme() {
        guard let vTheme = cosmos.theme.videosTheme else { fatalError("No Video Theme provided in cosmos") }
        if !vTheme.shouldShowSectionBlock {
            sectionBlock.isHidden = true
        }
        contentView.backgroundColor = vTheme.backgroundColor
        thumbnail.backgroundColor = .black
    }
}
