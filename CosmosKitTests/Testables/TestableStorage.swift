@testable import CosmosKit
import XCTest

class TestableStorage: Storable {

    var persistEditionCalled = false
    var persistArticleCalled = false
    var getEditionCalled = false
    var getArticleCalled = false
    var removeEditionCalled = false
    var removeArticleCalled = false
    var getBookmarksCalled = false
    var getPersistedEditionsCalled = false
    var removePersistedEditionsCalled = false
    var removeAllBookmarksCalled = false
    var isBookmarkCalled = false
    var isPersistedCalled = false
    var existsCalled = false

    var testBookmarks: [Int64]?
    var testArticle: Article?
    var testEdition: Edition?

    func persist(_ edition: Edition?) -> Bool {
        persistEditionCalled = true
        return true
    }

    func persist(_ article: Article?) -> Bool {
        persistArticleCalled = true
        return true
    }

    func edition(key: Int64) -> Edition? {
        getEditionCalled = true
        return testEdition
    }

    func edition(filename: String) -> Edition? {
        getEditionCalled = true
        return testEdition
    }

    func removeEdition(filename: String) -> Bool {
        removeEditionCalled = true
        return true
    }

    func removeEdition(key: Int64) -> Bool {
        removeEditionCalled = true
        return true
    }

    func article(key: Int64) -> Article? {
        getArticleCalled = true
        return testArticle
    }

    func removeArticle(key: Int64?) -> Bool {
        removeArticleCalled = true
        return true
    }

    func getBookmarks() -> [Int64]? {
        getBookmarksCalled = true
        return testBookmarks
    }

    func getPersistedEditions() -> [Edition]? {
        getPersistedEditionsCalled = true
        return nil
    }

    func removePersistedEditions(excluding keys: [Int64]) {
        removePersistedEditionsCalled = true
    }

    func removeAllBookmarks() -> Bool {
        removeAllBookmarksCalled = true
        return true
    }

    func isBookmark(key: Int64) -> Bool {
        isBookmarkCalled = true
        return true
    }

    func isPersisted(key: Int64) -> Bool {
        isPersistedCalled = true
        return true
    }

    func exists(at path: String) -> Bool {
        existsCalled = true
        return true
    }
}
