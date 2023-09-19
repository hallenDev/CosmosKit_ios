import UIKit
import BTNavigationDropdownMenu

public class CosmosNavigationBar: UINavigationBar {

    let progress: StatusView
    var cosmos: Cosmos!
    var dropdown: BTNavigationDropdownMenu?

    required public init?(coder aDecoder: NSCoder) {
        self.progress = StatusView()
        super.init(coder: aDecoder)
        addSubview(progress)
        self.isTranslucent = false
    }

    public func configure(cosmos: Cosmos) {
        self.progress.backgroundColor = cosmos.navigationTheme.progressBarColor
        self.cosmos = cosmos
        items?.last?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if cosmos.uiConfig.dropDownTitle {
            createDropdown(cosmos)
            DispatchQueue.main.async {
                self.items?.last?.titleView = self.dropdown
            }
        } else {
            setLogo()
        }
    }

    func setLogo() {
        let aspect = cosmos.theme.logo.size.width/cosmos.theme.logo.size.height
        let newTitleView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 25))
        newTitleView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        newTitleView.widthAnchor.constraint(equalTo: newTitleView.heightAnchor, multiplier: aspect).isActive = true
        newTitleView.image = cosmos.theme.logo
        newTitleView.contentMode = .scaleAspectFit
        let titleTap = UITapGestureRecognizer(target: self, action: #selector(titleSelected))
        newTitleView.addGestureRecognizer(titleTap)
        newTitleView.isUserInteractionEnabled = true
        topItem?.titleView = newTitleView
    }

    @objc func titleSelected() {
        cosmos.eventDelegate?.cosmosTitleSelected?()
    }

    func createDropdown(_ cosmos: Cosmos) {
        guard let titleConfig = cosmos.uiConfig.titleConfig else {
            setLogo()
            return
        }

        let otherPubs = titleConfig.publications.filter {$0.id != cosmos.publication.id }
        let logos = otherPubs.compactMap { $0.logo }
        let selection = otherPubs.compactMap { $0.selectable }
        let backgrounds = otherPubs.compactMap { $0.backgroundColor }

        let btConfig = BTConfiguration()
        btConfig.imageMode = true
        btConfig.titleImageHeight = titleConfig.titleHeight
        btConfig.cellImageHeight = titleConfig.cellHeight
        btConfig.arrowTintColor = titleConfig.arrowColor
        btConfig.dynamicSelection = selection
        btConfig.dynamicBackgrounds = backgrounds
        btConfig.footerView = StatusView()

        let menuView = BTNavigationDropdownMenu(config: btConfig, title: cosmos.uiConfig.logo, images: logos)
        menuView.cellSeparatorColor = .darkGray
        if #available(iOS 13.0, *) {
            menuView.overrideUserInterfaceStyle = .light
        }

        menuView.didSelectItemAtIndexHandler = { [weak self] (index: Int) -> Void in
            self?.cosmos.multiPublicationDelegate?.cosmosSwitchPublication(toIndex: index)
        }

        self.dropdown = menuView
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        progress.updateY(frame.height, width: frame.width)
    }

    override public func popItem(animated: Bool) -> UINavigationItem? {
        return super.popItem(animated: false)
    }

    override public func pushItem(_ item: UINavigationItem, animated: Bool) {
        if var newItems = self.items {
            newItems.append(item)
            self.items = newItems
        } else {
            self.items = [item]
        }
    }

    func closeDropdown() {
        guard let menu = dropdown else { return }
        if menu.isShown {
            menu.hide()
        }
    }

}

extension UINavigationBar {
    public func configureNav(cosmos: Cosmos) {
        (self as? CosmosNavigationBar)?.configure(cosmos: cosmos)
    }

    public func closeDropdownIfNeeded() {
        (self as? CosmosNavigationBar)?.closeDropdown()
    }
}
