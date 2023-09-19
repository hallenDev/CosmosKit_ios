import Foundation

class VideoCell: UITableViewCell {

    @IBOutlet var thumbnail: UIImageView!
    @IBOutlet var section: VideoCellSectionLabel!
    @IBOutlet var title: VideoCellTitleLabel!
    @IBOutlet var published: VideoCellTimeLabel!
    @IBOutlet var sectionBlock: VideoSectionBlock!
    var openArticle: ((Int64) -> Void)?

    var viewModel: MediaViewModel!
    var cosmos: Cosmos!

    func configure(for video: MediaViewModel, cosmos: Cosmos, openArticle: @escaping (Int64) -> Void) {
        viewModel = video
        self.cosmos = cosmos
        self.openArticle = openArticle
        let tap = UITapGestureRecognizer(target: self, action: #selector(titleSelected))
        title.addGestureRecognizer(tap)
        title.isUserInteractionEnabled = true

        title.text = video.title
        section.text = video.section
        published.text = video.published

        let placeHolder = UIImage(cosmosName: .videoPlaceholder)
        if let thumb = video.thumbnail, let url = URL(string: thumb) {
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

    @objc func titleSelected() {
        cosmos.logger?.log(event: CosmosEvents.videoArticleOpened(key: "\(viewModel.articleKey)", title: viewModel.title))
        openArticle?(viewModel.articleKey)
    }
}
