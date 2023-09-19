import Foundation

class FontSettingsViewController: UIViewController, HeaderEnabledViewController {

    enum FontOptions: Int, CaseIterable {
        case small
        case medium
        case large

        var textStyle: UIFont.TextStyle {
            switch self {
            case .small: return .subheadline
            case .medium: return .body
            case .large: return .title3
            }
        }

        init(textStyle: UIFont.TextStyle) {
            switch textStyle {
            case .subheadline:
                self = .small
            case .title3:
                self = .large
            default:
                self = .medium
            }
        }
    }

    @IBOutlet var previewLabel: FontDetailLabel!
    @IBOutlet var header: FontDetailLabel!
    @IBOutlet var slider: StepSlider!
    @IBOutlet var textWrapper: UIView!

    var articleText: ArticleText!
    var viewModel: FontSettingsViewModel!
    var sampleText: TextViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTranslations()
        configureTextView()
        configureSlider()
        applyTheme()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let viewTitle = LanguageManager.shared.translateUppercased(key: .fontSettings)
        addHeaderView(title: viewTitle,
                      theme: viewModel.theme)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.navigationBar.configureNav(cosmos: self.viewModel.cosmos)
        }
    }

    private func applyTheme() {
        view.backgroundColor = viewModel.theme.backgroundColor
    }

    private func configureTranslations() {
        let text = LanguageManager.shared.translate(key: .textSizeExample)
        sampleText = TextViewModel(from: TextWidgetData(html: text,
                                                        text: nil),
                                   type: .text)
        previewLabel.text = LanguageManager.shared.translate(key: .preview)
        header.text = LanguageManager.shared.translate(key: .articleTextSize)
    }

    private func configureSlider() {
        let fonts = FontOptions.allCases.map { $0.rawValue }
        slider.configure(values: fonts) { [weak self] value in
            self?.handleSliderChange(value)
        }
        let stored = viewModel.getStoredStyle()
        slider.value = Float(stored)
        handleSliderChange(stored)
        slider.thumbTintColor = viewModel.theme.accentColor
        slider.minimumTrackTintColor = viewModel.theme.accentColor
        slider.maximumTrackTintColor = .gray
    }

    private func configureTextView() {
        articleText = ArticleText.instanceFromNib(viewModel: sampleText, cosmos: viewModel.cosmos)
        articleText.translatesAutoresizingMaskIntoConstraints = false
        textWrapper.addSubview(articleText)
        NSLayoutConstraint.activate([
            articleText.leadingAnchor.constraint(equalTo: textWrapper.leadingAnchor),
            articleText.trailingAnchor.constraint(equalTo: textWrapper.trailingAnchor),
            articleText.topAnchor.constraint(equalTo: textWrapper.topAnchor),
            articleText.bottomAnchor.constraint(equalTo: textWrapper.bottomAnchor)
        ])
    }

    private func handleSliderChange(_ value: Int) {
        guard let option = FontOptions(rawValue: value) else { return }
        viewModel.set(option: option)
        articleText.refreshFont()
    }
}
