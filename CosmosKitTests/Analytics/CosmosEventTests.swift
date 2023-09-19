import XCTest
@testable import CosmosKit

class CosmosEventsTests: XCTestCase {

    var testCosmos: TestableCosmos!

    override func setUp() {
        testCosmos = TestableCosmos()
        testCosmos.testIsLoggedIn = true
    }
    
    
    func test_notificationOpen() {
        
        let sut = CosmosEvents.notificationOpen(slug: "test", headline: "test")
        XCTAssertEqual(sut.name, "notification_opened")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid",
                                                                                               "article_headline": "test",
                                                                                               "article_slug": "test"])
    }
    
    func test_notificationFailed() {
        
        let sut = CosmosEvents.notificationFailed(articleKey: "test")
        XCTAssertEqual(sut.name, "notification_failed")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid",
                                                                                               "article_key": "test"])
    }
    
    func test_notificationMalformed() {
        
        let sut = CosmosEvents.notificationMalformed
        XCTAssertEqual(sut.name, "notification_malformed")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid"])
    }
    
    func test_error() {
        
        let sut = CosmosEvents.error(description: "test")
        XCTAssertEqual(sut.name, "Error")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid",
                                                                                               "description": "test"])
    }
    
    func test_search() {
        
        let sut = CosmosEvents.search(term: "test")
        XCTAssertEqual(sut.name, "screen_search")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid",
                                                                                               "term": "test"])
    }
    
    func test_bookmarks() {
        
        let sut = CosmosEvents.bookmarks
        XCTAssertEqual(sut.name, "screen_bookmarks")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid"])
    }
    
    func test_bookmarked() {
        
        let sut = CosmosEvents.bookmarked(slug: "test")
        XCTAssertEqual(sut.name, "bookmark_added")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid",
                                                                                               "article_slug": "test"])
    }
    
    func test_bookmarkRemoved() {
        
        let sut = CosmosEvents.bookmarkRemoved(slug: "test")
        XCTAssertEqual(sut.name, "bookmark_removed")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid",
                                                                                               "article_slug": "test"])
    }
    
    func test_homePage() {
        
        let sut = CosmosEvents.homePage
        XCTAssertEqual(sut.name, "screen_homepage")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid"])
    }
    
    func test_section() {
        
        let sut = CosmosEvents.section(section: "test")
        XCTAssertEqual(sut.name, "screen_section")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid",
                                                                                               "section": "test"])
    }
    
    func test_forgotPassword() {
        
        let sut = CosmosEvents.forgotPassword
        XCTAssertEqual(sut.name, "screen_forgot_password")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid"])
    }
    
    func test_signIn() {
        
        let sut = CosmosEvents.signIn
        XCTAssertEqual(sut.name, "screen_signIn")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid"])
    }
    
    func test_register() {
        
        let sut = CosmosEvents.register
        XCTAssertEqual(sut.name, "screen_register")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid"])
    }
    
    func test_adLoadError() {
        
        let sut = CosmosEvents.adLoadError(articleIndex: 0, articleCount: 1)
        XCTAssertEqual(sut.name, "ad_load_error")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos)["is_online"] as? String, "true")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos)["is_logged"] as? String, "true")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos)["article_count"] as? Int, 1)
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos)["article_index"] as? Int, 0)
    }
    
    func test_article() {
        
        let sut = CosmosEvents.article(articleKey: "test")
        XCTAssertEqual(sut.name, "screen_article")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid",
                                                                                               "article_key": "test"])
    }
    
    func test_edition() {
        
        let sut = CosmosEvents.edition(key: "test")
        XCTAssertEqual(sut.name, "screen_edition")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid",
                                                                                               "edition_key": "test"])
    }
    
    func test_pastEditions() {
        
        let sut = CosmosEvents.pastEditions
        XCTAssertEqual(sut.name, "screen_past_editions")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid"])
    }
    
    func test_settings() {
        
        let sut = CosmosEvents.settings
        XCTAssertEqual(sut.name, "screen_settings")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid"])
    }
    
    func test_sections() {
        
        let sut = CosmosEvents.sections
        XCTAssertEqual(sut.name, "screen_sections")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid"])
    }
    
    func test_authors() {
        
        let sut = CosmosEvents.authors
        XCTAssertEqual(sut.name, "screen_authors")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid"])
    }
    
    func test_author() {
        
        let sut = CosmosEvents.author(key: "test")
        XCTAssertEqual(sut.name, "screen_author")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid",
                                                                                               "author_key": "test"])
    }
    
    func test_videos() {
        
        let sut = CosmosEvents.videos
        XCTAssertEqual(sut.name, "screen_videos")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid"])
    }
    
    func test_videoArticleOpened() {
        
        let sut = CosmosEvents.videoArticleOpened(key: "123", title: "test")
        XCTAssertEqual(sut.name, "video_article_open")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid",
                                                                                               "article_key": "123",
                                                                                               "article_headline": "test"])
    }
    
    func test_videoplayed() {
        
        let sut = CosmosEvents.videoPlayed(key: "test123", url: "test")
        XCTAssertEqual(sut.name, "video_play")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["article_key": "test123",
                                                                                               "video_url": "test",
                                                                                               "is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid"])
    }
    
    func test_comments() {
        
        let sut = CosmosEvents.comments(slug: "test")
        XCTAssertEqual(sut.name, "screen_comments")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid",
                                                                                               "article_slug": "test"])
    }

    func test_audioArticleOpened() {

        let sut = CosmosEvents.audioArticleOpened(key: "124", title: "test")

        XCTAssertEqual(sut.name, "audio_article_open")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid",
                                                                                               "article_key": "124",
                                                                                               "article_headline": "test"])
    }

    func test_audioPlayed() {

        let sut = CosmosEvents.audioPlayed(key: "124", url: "test.com")

        XCTAssertEqual(sut.name, "audio_play")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid",
                                                                                               "article_key": "124",
                                                                                               "video_url": "test.com"])
    }

    func test_forgotPasswordConfirm() {

        let sut = CosmosEvents.forgotPasswordConfirm

        XCTAssertEqual(sut.name, "screen_forgot_password_confirm")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid"])
    }

    func test_screen_audio() {

        let sut = CosmosEvents.audio

        XCTAssertEqual(sut.name, "screen_audio")
        XCTAssertEqual(sut.parameters(online: true, cosmos: testCosmos) as? [String: String], ["is_online": "true",
                                                                                               "is_logged": "true",
                                                                                               "guid": "testguid"])
    }
}
