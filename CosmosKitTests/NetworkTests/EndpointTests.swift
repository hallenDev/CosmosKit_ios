//swiftlint:disable line_length
import XCTest
@testable import CosmosKit

class EndpointTests: XCTestCase {
    
    var publication: Publication!
    var config: CosmosConfig!
    
    override func setUp() {
        super.setUp()
        Keychain.setAccessToken(nil)
        publication = TestPublication(liveDomain: "https://select.timeslive.co.za", id: "times-select", isEdition: true)
        
        config = CosmosConfig(publication: publication)
    }
    
    override func tearDown() {
        Keychain.setAccessToken(nil)
        super.tearDown()
    }

    func testSanitizeUrl() {

        Keychain.setAccessToken(AccessToken(token: "1234", expires: ""))

        let sut = EditionEndpoint(config: config, key: 1234)

        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get?key=1234&publication=times-select&compute_embedded_articles_list=1&access_token=1234")
        XCTAssertEqual(sut.sanitizedUrl, "https://select.timeslive.co.za/apiv1/pub/articles/get?key=1234&publication=times-select&compute_embedded_articles_list=1")
    }
    
    func testGetEditionEndpoint_key() {
        
        let sut = EditionEndpoint(config: config, key: 1234)
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get?key=1234&publication=times-select&compute_embedded_articles_list=1")
    }
    
    func testGetEditionEndpoint_key_usesToken() {
        
        Keychain.setAccessToken(AccessToken(token: "1234", expires: ""))
        
        let sut = EditionEndpoint(config: config, key: 1234)
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get?key=1234&publication=times-select&compute_embedded_articles_list=1&access_token=1234")
    }
    
    func testGetEditionEndpoint_date() {
        
        let sut = EditionEndpoint(config: config, date: Date(timeIntervalSince1970: 1), section: "editionstest")
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get-all?limit=1&page=1&publication=times-select&section=editionstest&date_to=1&compute_embedded_articles_list=1")
    }
    
    func testGetEditionEndpoint_date_usesToken() {
        
        Keychain.setAccessToken(AccessToken(token: "1234", expires: ""))
        
        let sut = EditionEndpoint(config: config, date: Date(timeIntervalSince1970: 1), section: "editions")
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get-all?limit=1&page=1&publication=times-select&section=editions&date_to=1&compute_embedded_articles_list=1&access_token=1234")
    }
    
    func testGetEditionEndpoint_minimal() {
        
        let sut = MinimalEditionEndpoint(config: config, date: Date(timeIntervalSince1970: 1), section: "editionstest")
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get-all?limit=1&page=1&publication=times-select&section=editionstest&date_to=1&exclude_fields=widgets,related_articles,plain_text,blob_key,images,image,image_thumbnail")
    }
    
    func testGetEditionEndpoint_minimal_usesToken() {
        
        Keychain.setAccessToken(AccessToken(token: "1234", expires: ""))
        
        let sut = MinimalEditionEndpoint(config: config, date: Date(timeIntervalSince1970: 1), section: "editions")
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get-all?limit=1&page=1&publication=times-select&section=editions&date_to=1&exclude_fields=widgets,related_articles,plain_text,blob_key,images,image,image_thumbnail&access_token=1234")
    }
    
    func testArticleEndpoint_UsingSlug() {
        
        let sut = ArticleEndpoint(config: config, slug: "/news/article")
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get?slug=/news/article&compute_related=1")
    }
    
    func testArticleEndpoint_UsingKey() {
        
        let sut = ArticleEndpoint(config: config, key: 123)
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get?key=123&compute_related=1")
    }
    
    func testArticleEndpoint_UsingTokenAndKey() {
        
        Keychain.setAccessToken(AccessToken(token: "1234", expires: ""))
        
        let sut = ArticleEndpoint(config: config, key: 123)
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get?key=123&compute_related=1&access_token=1234")
    }
    
    func testArticleEndpoint_UsingTokenAndSlug() {
        
        Keychain.setAccessToken(AccessToken(token: "1234", expires: ""))
        
        let sut = ArticleEndpoint(config: config, slug: "/news/article")
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get?slug=/news/article&compute_related=1&access_token=1234")
    }
    
    func testAllArticlesEndpoint() {
        
        let sut = AllArticlesEndpoint(config: config, page: 1)
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get-all?trim_featured_list=false&exclude_fields=widgets,related_articles,plain_text&page=1&publication=times-select&date_to=\(Int(Date().timeIntervalSince1970))")
    }
    
    func testAllArticlesEndpoint_usesToken() {
        
        Keychain.setAccessToken(AccessToken(token: "1234", expires: ""))
        
        let sut = AllArticlesEndpoint(config: config, page: 2)
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get-all?trim_featured_list=false&exclude_fields=widgets,related_articles,plain_text&page=2&publication=times-select&date_to=\(Int(Date().timeIntervalSince1970))&access_token=1234")
    }
    
    func testAllArticlesEndpoint_section() {
        
        let sut = AllArticlesEndpoint(config: config, section: "news", publication: "times-select")
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get-all?page=1&section=news&publication=times-select&compute_related=1&date_to=\(Int(Date().timeIntervalSince1970))")
    }
    
    func testAllArticlesEndpoint_SectionAndPage3() {
        
        let sut = AllArticlesEndpoint(config: config, section: "news", publication: "times-select", page: 3)
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get-all?page=3&section=news&publication=times-select&compute_related=1&date_to=\(Int(Date().timeIntervalSince1970))")
    }
    
    func testAllArticlesEndpoint_usesTokenAndDateToAndSection() {
        
        Keychain.setAccessToken(AccessToken(token: "1234", expires: ""))
        
        let sut = AllArticlesEndpoint(config: config, section: "news", publication: "times-select")
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get-all?page=1&section=news&publication=times-select&compute_related=1&date_to=\(Int(Date().timeIntervalSince1970))&access_token=1234")
    }
    
    func testSectionsEndpoint() {
        
        let sut = SectionsEndpoint(config: config)
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/sections/get-all?publication=times-select")
    }
    
    func testSectionsEndpoint_usesToken() {
        
        Keychain.setAccessToken(AccessToken(token: "1234", expires: ""))
        
        let sut = SectionsEndpoint(config: config)
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/sections/get-all?publication=times-select&access_token=1234")
    }
    
    func testRequestTokenEndpoint() {
        
        let sut = RequestTokenEndpoint(config: config)
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/auth/issue-request-token?agent=times-select_app_ios_v1.0&consumer_key=test")
    }
    
    func testAccessTokenEndpoint() {
        
        let sut = AccessTokenEndpoint(config: config, username: "user", password: "pass", requestToken: "1234")
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/auth/issue-access-token?username=user&password=pass&request_token=1234")
    }
    
    func testAccessTokenEndpoint_withCharacters() {
        
        let sut = AccessTokenEndpoint(config: config, username: "user", password: "pass&", requestToken: "1234")
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/auth/issue-access-token?username=user&password=pass%26&request_token=1234")
    }
    
    func testCharacterEncoding() {
        
        let validChars = Array(" !\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~")
        let validConverted = "%20,%21,%22,%23,%24,%25,%26,%27,%28,%29,%2A,%2B,%2C,%2D,%2E,%2F,%3A,%3B,%3C,%3D,%3E,%3F,%40,%5B,%5C,%5D,%5E,%5F,%60,%7B,%7C,%7D,%7E".split(separator: ",")
        
        for character in validChars.enumerated() {
            let password = "password123\(character.element)"
            let sut = AccessTokenEndpoint.encodeURL(value: password, using: .urlPasswordAllowed)
            XCTAssertEqual("password123\(validConverted[character.offset])", sut)
        }
    }
    
    func testRegisterUserEndPoint() {
        
        let sut = RegisterUserEndpoint(config: config, username: "piet@pompies.com")

        if FeatureFlag.newWelcomeFlow.isEnabled {
            XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/user/create?email=piet%40pompies%2Ecom&bypass_activation=true")
        } else {
            XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/user/create?email=piet%40pompies%2Ecom")
        }
    }
    
    func testResetPasswordEndPoint() {
        
        let sut = ResetPasswordEndpoint(config: config, username: "piet@pompies.com")
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/user/resetmail?email=piet@pompies.com")
    }
    
    func testUserInfoEndPoint() {
        
        let sut = UserInfoEndpoint(config: config, accessToken: "1234")
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/user/me?access_token=1234")
    }
    
    func testPastEditionsEndPoint() {
        
        let sut = PastEditionsEndpoint(config: config, section: "editions", limit: 10, page: 1)
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get-all?page=1&publication=times-select&section=editions&exclude_fields=widgets,related_articles,plain_text,blur,blob_key,images&limit=10&date_to=\(Int(Date().timeIntervalSince1970))")
    }
    
    func testSearchEndpoint() {
        
        let sut = SearchEndpoint(config: config, searchTerm: "zuma")
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get-all?page=1&query=zuma&limit=10&compute_related=1&date_to=\(Int(Date().timeIntervalSince1970))")
    }
    
    func testSearchEndpoint_UsesPage() {
        
        let sut = SearchEndpoint(config: config, searchTerm: "zuma", page: 4)
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get-all?page=4&query=zuma&limit=10&compute_related=1&date_to=\(Int(Date().timeIntervalSince1970))")
    }
    
    func testSearchEndpoint_usesToken() {
        
        Keychain.setAccessToken(AccessToken(token: "1234", expires: ""))
        
        let sut = SearchEndpoint(config: config, searchTerm: "zuma")
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get-all?page=1&query=zuma&limit=10&compute_related=1&date_to=\(Int(Date().timeIntervalSince1970))&access_token=1234")
    }
    
    func testUserAccessEndpoint() {
        
        Keychain.setAccessToken(AccessToken(token: "1234", expires: ""))
        
        let sut = ArticleAccessEndpoint(config: config, key: 1)
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get?key=1&exclude_fields=widgets,related_articles,plain_text&access_token=1234")
    }
    
    func testDisqusCommentCountEndpoint() {

        let sut = DisqusThreadEndpoint(config: config, disqusConfig: publication.commentConfig as! DisqusConfig, shareUrl: "/test-url", slug: "test-slug")
        
        XCTAssertEqual(sut.urlString, "https://disqus.com/api/3.0/forums/listThreads?api_key=test&thread:link=test/test-url&forum=test&thread:ident=test-slug")
    }
    
    func testAllArticlesEndpoint_subSection() {
        
        let sut = AllArticlesEndpoint(config: config, section: "sport", subSection: "soccer", publication: "times-select")
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get-all?page=1&section=sport&subsection=soccer&publication=times-select&compute_related=1&date_to=\(Int(Date().timeIntervalSince1970))")
    }
    
    func testAllArticlesEndpoint_SubSectionAndPage3() {
        
        let sut = AllArticlesEndpoint(config: config, section: "sport", subSection: "soccer", publication: "times-select", page: 3)
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get-all?page=3&section=sport&subsection=soccer&publication=times-select&compute_related=1&date_to=\(Int(Date().timeIntervalSince1970))")
    }
    
    func testAllArticlesEndpoint_usesTokenAndSubSection() {
        
        Keychain.setAccessToken(AccessToken(token: "1234", expires: ""))
        
        let sut = AllArticlesEndpoint(config: config, section: "sport", subSection: "soccer", publication: "times-select")
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get-all?page=1&section=sport&subsection=soccer&publication=times-select&compute_related=1&date_to=\(Int(Date().timeIntervalSince1970))&access_token=1234")
    }
    
    func testVideoContentEndpoint() {
        
        let sut = VideoContentEndpoint(config: config, page: 1)
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get-all?page=1&publication=times-select&doc_types=videos")
    }
    
    func testVideoContentEndpoint_usesToken() {
        
        Keychain.setAccessToken(AccessToken(token: "1234", expires: ""))
        
        let sut = VideoContentEndpoint(config: config, page: 2)
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get-all?page=2&publication=times-select&doc_types=videos&access_token=1234")
    }

    func testAudioContentEndpoint() {

        let sut = AudioEndpoint(config: config, page: 1)

        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get-all?page=1&publication=times-select&doc_types=audios")
    }

    func testAudioContentEndpoint_usesToken() {

        Keychain.setAccessToken(AccessToken(token: "1234", expires: ""))

        let sut = AudioEndpoint(config: config, page: 2)

        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get-all?page=2&publication=times-select&doc_types=audios&access_token=1234")
    }
    
    func testDisqusAuthEndpoint() {
        
        Keychain.setAccessToken(AccessToken(token: "1234", expires: ""))
        
        let sut = DisqusAuthEndpoint(config: config, token: "1234")
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/user/disqusauth?access_token=1234")
    }
    
    func testInstagramEmbedEndpoint() {
        let sut = InstagramEmbedEndpoint(config: config, appID: "1234", clientID: "5678", postURL: "www.instagram.com/123456", width: 375)
        
        XCTAssertEqual(sut.urlString, "https://graph.facebook.com/v9.0/instagram_oembed?url=www.instagram.com/123456&access_token=1234%7C5678&maxwidth=375")
    }
    
    func testTeaserEndpoint() {
        
        let sut = TeaserEndpoint(config: config, section: "home", subSection: "notHome")
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/teaser/get-all?section=home&publication=times-select&active=1&allow_future_articles=0&subsection=notHome")
    }
    
    func testLastUpdatedEndpoint() {
        
        let sut = LastUpdatedEndpoint(config: config, key: 12456)
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/article/check-status?key=12456")
    }
    
    func testLastUpdatedEndpoint_usesToken() {
        
        Keychain.setAccessToken(AccessToken(token: "1234", expires: ""))
        
        let sut = LastUpdatedEndpoint(config: config, key: 12456)
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/article/check-status?key=12456&access_token=1234")
    }
    
    func testEditionKey() {
        
        let sut = EditionEndpoint(config: config, key: 1234)
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get?key=1234&publication=times-select&compute_embedded_articles_list=1")
    }
    
    func testEditionKey_usesToken() {
        
        Keychain.setAccessToken(AccessToken(token: "1234", expires: ""))
        
        let sut = EditionEndpoint(config: config, key: 1234)
        
        XCTAssertEqual(sut.urlString, "https://select.timeslive.co.za/apiv1/pub/articles/get?key=1234&publication=times-select&compute_embedded_articles_list=1&access_token=1234")
    }
    
    func testBibliodamExchangeEndpoint() {

        let sut = BibliodamExchangeEndpoint(config: config, url: "https://tisojw-cdn.baobabsuite.com/98xLK6WJ.mp4")

        XCTAssertEqual(sut.urlString, "https://tiso-media.imigino.com/video/1/getIOS?videoUrl=https://tisojw%2Dcdn%2Ebaobabsuite%2Ecom/98xLK6WJ%2Emp4")
    }
}

