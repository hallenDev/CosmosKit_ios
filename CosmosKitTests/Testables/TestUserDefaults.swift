@testable import CosmosKit

class TestUserDefaults: UserDefaults {

    var lastUsedKey: String?
    var lastSetValue: Any?
    var returnObject: Any?
    var returnBool: Bool = false
    var objectForKeyCalled = false
    var boolForKeyCalled = false
    var setValueCalled =  false
    var setBoolValueCalled =  false
    var removeObjectCalled = false

    override func object(forKey defaultName: String) -> Any? {
        lastUsedKey = defaultName
        objectForKeyCalled = true
        return returnObject
    }

    override func bool(forKey defaultName: String) -> Bool {
        lastUsedKey = defaultName
        boolForKeyCalled = true
        return returnBool
    }

    override func set(_ value: Any?, forKey defaultName: String) {
        lastUsedKey = defaultName
        lastSetValue = value
        setValueCalled = true
    }

    override func set(_ value: Bool, forKey defaultName: String) {
        lastUsedKey = defaultName
        lastSetValue = value
        setBoolValueCalled = true
    }

    override func removeObject(forKey defaultName: String) {
        lastUsedKey = defaultName
        removeObjectCalled = true
    }
}
