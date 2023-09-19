@testable import CosmosKit
import XCTest

class CosmosStoryboardTests: XCTestCase {


    func testViewControllers_pager() {
        
        let sut: PagerAdViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testViewControllers_comments() {

        let sut: CommentViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testViewControllers_logincontainer() {
        
        let sut: LoginContainerViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testViewControllers_account() {

        let sut: AccountViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testViewControllers_search() {

        let sut: SearchViewController = CosmosStoryboard.loadViewController()
        
        XCTAssertNotNil(sut)
    }

    func testViewControllers_searchnav() {

        let sut: SearchNavigationViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testViewControllers_fallback() {

        let sut: FallbackViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testViewControllers_webnav() {

        let sut: WebNavigationViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testViewControllers_web() {

        let sut: WebViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testViewControllers_gallerywidget() {

        let sut: GalleryWidgetViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testViewControllers_galleryimage() {

        let sut: GalleryImageViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testViewControllers_editionbookmarks() {

        let sut: EditionBookmarksViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testViewControllers_articlelist() {

        let sut: ArticleListViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testViewControllers_article() {

        let sut: ArticleViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testViewControllers_edition() {

        let sut: EditionViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testViewControllers_section() {

        let sut: SectionViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testViewControllers_pasteditions() {

        let sut: PastEditionsViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testViewControllers_video() {

        let sut: MediaViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testViewControllers_push() {

        let sut: ArticlePushViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testViewControllers_pushnav() {

        let sut: ArticlePushNavigationViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testViewControllers_settings() {

        let sut: SettingsViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testViewControllers_author() {

        let sut: AuthorDetailViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testViewControllers_authorlist() {

        let sut: AuthorListViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testViewControllers_register() {

        let sut: LegacyRegisterViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testViewControllers_fgtpwd() {

        let sut: LegacyForgotPasswordViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testViewControllers_signin() {

        let sut: LegacySigninViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testViewControllers_widgetstack() {

        let sut: WidgetStackViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testDebugViewController() {

        let sut: DebugViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }

    func testSwitchSettingsViewController() {

        let sut: SwitchSettingsViewController = CosmosStoryboard.loadViewController()

        XCTAssertNotNil(sut)
    }
}

