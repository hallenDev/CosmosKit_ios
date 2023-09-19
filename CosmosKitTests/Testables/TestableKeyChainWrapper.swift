@testable import CosmosKit
import XCTest
import SwiftKeychainWrapper

class TestableKeyChainWrapper: KeychainWrapper {

    var setStringCalled = false
    var getStringCalled = false
    var stringKeys = [String]()
    var setStringValues = [String]()
    var getStringValues = [String: String]()
    var removeKeys = [String]()
    var removeCalled = false

    init() {
        super.init(serviceName: "testing")
    }

    override func set(_ value: String, forKey key: String, withAccessibility accessibility: KeychainItemAccessibility?, isSynchronizable: Bool = false) -> Bool {
        setStringCalled = true
        stringKeys.append(key)
        setStringValues.append(value)
        getStringValues[key] = value
        return true
    }

    override func string(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility?, isSynchronizable: Bool = false) -> String? {
        getStringCalled = true
        return getStringValues[key]
    }

    override func removeObject(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility?, isSynchronizable: Bool = false) -> Bool {
        removeCalled = true
        removeKeys.append(key)
        return true
    }
}
