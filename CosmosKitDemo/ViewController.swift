// swiftlint:disable function_body_length line_length
import UIKit
import CosmosKit

struct DemoApp: Publication {
    var stagingDomain: String
    var liveDomain: String
    var facebookClientId: String?
    var facebookAppId: String?
    var narratiiveConfig: NarratiiveConfig
    var fallbackConfig: FallbackConfig
    var theme: Theme
    var uiConfig: CosmosUIConfig
    var authConfig: AuthConfig?
    var mapsApiKey: String
    var consumerKey: String
    var id: String
    var name: String
    var isEdition: Bool
    var loadingIndicator: LoadingIndicatorConfig?
    var commentConfig: CommentProvider
    var adConfig: AdConfig?
    var settingsConfig: SettingsConfig
    var editionConfig: EditionConfig?
}

struct DemoFallback: FallbackConfigurable {
    var fallback: Fallback {
        return Fallback(title: "No Result",
                        body: "No results found for your request on Demo app. Please try again later.",
                        image: nil)
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var apiKey: UITextField!
    @IBOutlet weak var baseURL: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var timesLive: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        registerFonts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        spinner.stopAnimating()
    }

    @IBAction func showList(_ sender: Any) {
        errorLabel.isHidden = true
        spinner.startAnimating()
        let selectedTheme = Theme()

        let uiConfig = CosmosUIConfig(logo: UIImage(),
                                      shouldNavHideLogo: false)
        let narratiive = NarratiiveConfig(baseUrl: "http://nar.com", host: "m-test.com", hostKey: "lalala")
        let publication = DemoApp(
            stagingDomain: baseURL.text!,
            liveDomain: baseURL.text!,
            facebookClientId: nil,
            facebookAppId: nil,
            narratiiveConfig: narratiive,
            fallbackConfig: FallbackConfig(),
            theme: selectedTheme,
            uiConfig: uiConfig,
            authConfig: nil,
            mapsApiKey: "",
            consumerKey: apiKey.text!,
            id: "times-live",
            name: "Demo App",
            isEdition: false,
            loadingIndicator: LoadingIndicatorConfig(lightMode: "Spinner"),
            commentConfig: DisqusConfig(shortname: "test", domain: "test", apiKey: "test"),
            adConfig: nil,
            settingsConfig: SettingsConfig(pushNotificationConfig: PushNotificationConfig(info: "test",
                                                                                          topics: [],
                                                                                          defaultValue: false),
                                           newslettersConfig: NewslettersConfig(info: "test")),
            editionConfig: nil)

        let apiConfig = CosmosConfig(publication: publication)

        let cosmos = Cosmos(apiConfig: apiConfig, logger: AnalyticsLogger(), errorDelegate: nil, eventDelegate: nil)
        // self.show(cosmos.getLiveView(), sender: self)
//        self.show(cosmos.getArticleListView(for: "Zahara cancels upcoming gigs"), sender: self)
        self.show(cosmos.getSettingsView(), sender: self)
    }

    @IBAction func showEdition(_ sender: Any) {
        let cosmos = timesSelectCosmos()
        self.show(cosmos.getLatestEditionView(apiSection: "editions"), sender: self)
    }

    @IBAction func showSections(_ sender: Any) {
        let cosmos = timesLive.isOn ? timesLiveCosmos() : timesSelectCosmos()
        self.show(cosmos.getSectionView(renderType: .live), sender: self)
    }

    @IBAction func showPastEditions(_ sender: Any) {
        let cosmos = timesSelectCosmos()
        self.show(cosmos.getPastEditionsView(), sender: self)
    }

    @IBAction func showBookmarks(_ sender: Any) {
        if timesLive.isOn {
            let cosmos = timesLiveCosmos()
            self.show(cosmos.getArticleListBookmarksView(), sender: self)
        } else {
            let cosmos = timesSelectCosmos()
            self.show(cosmos.getEditionBookmarksView(), sender: self)
        }
    }

    @IBAction func showStaticPage(_ sender: Any) {
        let cosmos = timesLive.isOn ? timesLiveCosmos() : timesSelectCosmos()
        self.show(cosmos.getView(for: "contact-us",
                                 as: .staticPage,
                                 relatedSelected: { _ in }), sender: self)
    }

    private func timesLiveCosmos() -> Cosmos {
        let selectedTheme = Theme()

        let uiConfig = CosmosUIConfig(logo: UIImage(), shouldNavHideLogo: false)
        let narratiive = NarratiiveConfig(baseUrl: "http://nar.com", host: "m-test.com", hostKey: "lalala")
        let publication = DemoApp(
            stagingDomain: baseURL.text!,
            liveDomain: baseURL.text!,
            facebookClientId: nil,
                                  facebookAppId: nil,
                                  narratiiveConfig: narratiive,
                                  fallbackConfig: FallbackConfig(),
                                  theme: selectedTheme,
                                  uiConfig: uiConfig,
                                  authConfig: nil,
                                  mapsApiKey: "",
                                  consumerKey: apiKey.text!,
                                  id: "times-live",
                                  name: "Demo App",
                                  isEdition: false,
                                  loadingIndicator: LoadingIndicatorConfig(lightMode: "Spinner"),
                                  commentConfig: DisqusConfig(shortname: "test", domain: "", apiKey: "test"),
                                  adConfig: nil,
                                  settingsConfig: SettingsConfig(pushNotificationConfig: PushNotificationConfig(info: "test",
                                                                                                                topics: [],
                                                                                                                defaultValue: false),
                                                                 newslettersConfig: NewslettersConfig(info: "test")),
                                  editionConfig: nil)

        let apiConfig = CosmosConfig(publication: publication)

        let cosmos = Cosmos(apiConfig: apiConfig, logger: AnalyticsLogger(), errorDelegate: nil, eventDelegate: nil)
        return cosmos
    }

    private func timesSelectCosmos() -> Cosmos {
        spinner.startAnimating()
        errorLabel.isHidden = true

        let uiConfig = CosmosUIConfig(logo: UIImage(), shouldNavHideLogo: false)

        let narratiive = NarratiiveConfig(baseUrl: "http://nar.com", host: "m-test.com", hostKey: "lalala")
        let publication = DemoApp(
            stagingDomain: "https://select.timeslive.co.za",
            liveDomain: "https://select.timeslive.co.za",
            facebookClientId: nil,
                                  facebookAppId: nil,
                                  narratiiveConfig: narratiive,
                                  fallbackConfig: FallbackConfig(),
                                  theme: timesSelectTheme(),
                                  uiConfig: uiConfig,
                                  authConfig: nil,
                                  mapsApiKey: "",
                                  consumerKey: apiKey.text!,
                                  id: "times-select",
                                  name: "Demo App",
                                  isEdition: true,
                                  loadingIndicator: LoadingIndicatorConfig(lightMode: "Spinner"),
                                  commentConfig: DisqusConfig(shortname: "test", domain: "", apiKey: "test"),
                                  adConfig: nil,
                                  settingsConfig: SettingsConfig(pushNotificationConfig: PushNotificationConfig(info: "test",
                                                                                                                topics: [],
                                                                                                                defaultValue: false),
                                                                 newslettersConfig: NewslettersConfig(info: "test")),
                                  editionConfig: EditionConfig(editionCell: nil, featureLastPastEdition: false, showAllPastEditions: false))

        let apiConfig = CosmosConfig(publication: publication)

        let cosmos = Cosmos(apiConfig: apiConfig, logger: AnalyticsLogger(), errorDelegate: nil, eventDelegate: nil)
        return cosmos
    }

    private func timesSelectTheme() -> Theme {
        navigationController?.navigationBar.setBottomBorderColor(color: UIColor(red: 196/255,
                                                                                green: 14/255,
                                                                                blue: 61/255,
                                                                                alpha: 1),
                                                                 height: 5)

        let headerTheme = EditionTheme.EditionHeaderTheme(titleFont: UIFont(name: "HelveticaNeue-Bold", textStyle: .callout),
                                                          titleColor: .white,
                                                          titleBackgroundColor: .red,
                                                          titleStyle: .compressed)

        let editionSectionTheme = EditionTheme.EditionSectionTheme(titleFont: UIFont(name: "HelveticaNeue-Bold", textStyle: .title2),
                                                                   titleColor: .black,
                                                                   subTitleFont: UIFont(name: "HelveticaNeue", textStyle: .caption1),
                                                                   subTitleColor: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1),
                                                                   sectionShadowColor: .black)

        let articleCellTheme = EditionTheme.ArticleCellTheme(synopsisFont: UIFont(name: "HelveticaNeue", textStyle: .caption1),
                                                            synopsisColor: .gray,
                                                            readTimeFont: UIFont(name: "HelveticaNeue", textStyle: .caption1),
                                                            readTimeColor: .gray,
                                                            separatorColor: .gray)

        let accordionTheme = EditionTheme.AccordionTheme(titleFont: UIFont(name: "HelveticaNeue", textStyle: .title1),
                                                         headingFont: UIFont(name: "HelveticaNeue-Bold", textStyle: .body),
                                                         bodyFont: UIFont(name: "HelveticaNeue-Bold", textStyle: .body))

        let pastEditionTheme = EditionTheme.PastEditionsTheme(titleFont: UIFont(name: "HelveticaNeue", textStyle: .title1),
                                                              titleColor: .green,
                                                              subTitleFont: UIFont(name: "HelveticaNeue", textStyle: .caption1),
                                                              subTitleColor: .gray)

        let editionTheme = EditionTheme(headerTheme: headerTheme,
                                        editionSectionTheme: editionSectionTheme,
                                        articleCellTheme: articleCellTheme,
                                        accordionTheme: accordionTheme,
                                        pastEditionTheme: pastEditionTheme)

        return Theme(textColor: .black, separatorColor: .gray,
                     backgroundColor: .white,
                     accentColor: .red,
                     logo: UIImage(),
                     articleTheme: ArticleTheme(),
                     articleHeaderTheme: ArticleHeaderTheme(),
                     quoteTheme: QuoteTheme(),
                     authorTheme: AuthorTheme(),
                     relatedArticleTheme: RelatedArticleTheme(),
                     articleListTheme: ArticleListTheme(),
                     sectionsTheme: SectionsTheme(),
                     viewHeaderTheme: ViewHeaderTheme(),
                     searchTheme: SearchTheme(),
                     settingsTheme: SettingsTheme(),
                     authTheme: AuthorizationTheme(),
                     legacyAuthTheme: LegacyAuthorizationTheme(),
                     navigationTheme: NavigationTheme(),
                     fallbackTheme: FallbackTheme(),
                     editionTheme: editionTheme,
                     videosTheme: VideosTheme(),
                     authorsTheme: AuthorsTheme())
    }

    private func registerFonts() {
        guard Theme.registerFont(from: "Barlow-Medium.otf"),
            Theme.registerFont(from: "Barlow-Regular.otf"),
            Theme.registerFont(from: "Barlow-Bold.otf"),
            Theme.registerFont(from: "Lato-Bold.ttf"),
            Theme.registerFont(from: "Lato-Regular.ttf"),
            Theme.registerFont(from: "Lato-Italic.ttf"),
            Theme.registerFont(from: "Merriweather-Italic.otf"),
            Theme.registerFont(from: "Merriweather-Bold.otf")
            else {
                fatalError("Couldn't load fonts")
        }
    }
}

extension UINavigationBar {

    func setBottomBorderColor(color: UIColor, height: CGFloat) {
        let bottomBorderRect = CGRect(x: 0, y: frame.height, width: frame.width, height: height)
        let bottomBorderView = UIView(frame: bottomBorderRect)
        bottomBorderView.backgroundColor = color
        addSubview(bottomBorderView)
    }
}
