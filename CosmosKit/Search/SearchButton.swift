import Foundation

public class SearchButton {

    let cosmos: Cosmos
    var button: UIBarButtonItem {
        let item = UIBarButtonItem(image: UIImage(cosmosName: .searchSmall),
                                   style: .plain,
                                   target: self,
                                   action: #selector(search))
        item.tintColor = cosmos.navigationTheme.buttonColor
        return item
    }

    init(_ cosmos: Cosmos) {
        self.cosmos = cosmos
    }

    @objc func search() {
        let searchNav: SearchNavigationViewController = CosmosStoryboard.loadViewController()
        // swiftlint:disable:next force_cast
        let searchView = searchNav.topViewController as! SearchViewController
        searchView.cosmos = cosmos
        let renderType = cosmos.uiConfig.searchRenderType ?? (cosmos.publication.isEdition ? .edition : .live)
        searchView.viewModel = SearchViewModel(renderType: renderType)
        searchNav.modalPresentationStyle = .fullScreen
        UIApplication.shared.keyWindow?.rootViewController?.present(searchNav, animated: true, completion: nil)
    }
}
