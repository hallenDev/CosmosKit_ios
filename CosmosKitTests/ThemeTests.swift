//swiftlint:disable function_body_length
import XCTest
import CosmosKit

class ThemeTests: XCTestCase {
    
    func testCreate() {
      
        let sut = Theme()
        
        XCTAssertNotNil(sut)
    }
    
    func testRegisterFont() {
        
        let result = Theme.registerFont(from: "ComicSans-Regular.ttf")
        
        XCTAssertTrue(result)
    }
    
    func testCantRegisterFont() {

        let result = Theme.registerFont(from: "ComicSans.ttf")
        
        XCTAssertFalse(result)
    }
    
    //swiftlint:disable:next function_body_length
    func testCreate_WithEditionTheme() {

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

        let sut = Theme(textColor: .black, separatorColor: .gray,
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
        
        XCTAssertNotNil(sut)
    }
}
