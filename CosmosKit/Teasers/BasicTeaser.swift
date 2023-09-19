import Foundation

class BasicTeaser: UIView {

    @IBOutlet var heading: UILabel!
    @IBOutlet var subHeading: UILabel!
    @IBOutlet var article: UIView!

    init(_ viewModel: TeaserViewModel) {
        super.init(frame: .zero)
        let view: BasicTeaser? = fromNib()
        view?.configure(for: viewModel)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(for teaser: TeaserViewModel) {
        self.heading.text = teaser.heading
        self.subHeading.text = teaser.subHeading
    }
}
