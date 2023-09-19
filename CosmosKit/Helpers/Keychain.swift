import Foundation
import SwiftKeychainWrapper

class Keychain: NSObject {

    enum Keys: String, CaseIterable {
        case accessToken
        case accessTokenExpiry
        case userEmail
        case userFirstName
        case userLastName
        case guid
        case profileComplete
    }

    static var keychain = KeychainWrapper.standard

    class func setAccessToken(_ accessToken: AccessToken?) {
        if let token = accessToken {
        _ = keychain.set(token.token, forKey: Keychain.Keys.accessToken.rawValue, withAccessibility: .whenUnlockedThisDeviceOnly)
        _ = keychain.set(token.expires, forKey: Keychain.Keys.accessTokenExpiry.rawValue, withAccessibility: .whenUnlockedThisDeviceOnly)
        } else {
            keychain.removeObject(forKey: Keychain.Keys.accessToken.rawValue)
            keychain.removeObject(forKey: Keychain.Keys.accessTokenExpiry.rawValue)
        }
    }

    class func setUser(_ user: CosmosUser?) {
        if let user = user {
            _ = keychain.set(user.email, forKey: Keychain.Keys.userEmail.rawValue, withAccessibility: .whenUnlockedThisDeviceOnly)
            _ = keychain.set(user.firstname ?? "", forKey: Keychain.Keys.userFirstName.rawValue, withAccessibility: .whenUnlockedThisDeviceOnly)
            _ = keychain.set(user.lastname ?? "", forKey: Keychain.Keys.userLastName.rawValue, withAccessibility: .whenUnlockedThisDeviceOnly)
            _ = keychain.set(user.profile_complete ?? false, forKey: Keychain.Keys.profileComplete.rawValue, withAccessibility: .whenUnlockedThisDeviceOnly)
            // NOTE - User GUID Migration: this can be simplified
            if let guid = user.guid {
                _ = keychain.set(guid, forKey: Keychain.Keys.guid.rawValue, withAccessibility: .whenUnlockedThisDeviceOnly)
            }
        } else {
            keychain.removeObject(forKey: Keychain.Keys.userEmail.rawValue)
            keychain.removeObject(forKey: Keychain.Keys.userFirstName.rawValue)
            keychain.removeObject(forKey: Keychain.Keys.userLastName.rawValue)
            keychain.removeObject(forKey: Keychain.Keys.profileComplete.rawValue)
            keychain.removeObject(forKey: Keychain.Keys.accessToken.rawValue)
            keychain.removeObject(forKey: Keychain.Keys.accessTokenExpiry.rawValue)
            keychain.removeObject(forKey: Keychain.Keys.guid.rawValue)
        }
    }

    class func getUser() -> CosmosUser? {
        if let email = keychain.string(forKey: Keychain.Keys.userEmail.rawValue, withAccessibility: .whenUnlockedThisDeviceOnly),
           let fname = keychain.string(forKey: Keychain.Keys.userFirstName.rawValue, withAccessibility: .whenUnlockedThisDeviceOnly),
           let lname = keychain.string(forKey: Keychain.Keys.userLastName.rawValue, withAccessibility: .whenUnlockedThisDeviceOnly),
           let profile_complete = keychain.bool(forKey: Keychain.Keys.profileComplete.rawValue, withAccessibility: .whenUnlockedThisDeviceOnly){
            
            // NOTE - User GUID Migration: this can be included above once a migration  version has been released
            let guid = keychain.string(forKey: Keychain.Keys.guid.rawValue, withAccessibility: .whenUnlockedThisDeviceOnly)
            return CosmosUser(firstname: fname, lastname: lname, email: email, profile_complete: profile_complete, guid: guid)
        }
        return nil
    }

    class func getAccessTokenValue() -> String? {
        return keychain.string(forKey: Keychain.Keys.accessToken.rawValue, withAccessibility: .whenUnlockedThisDeviceOnly)
    }

    class func getAccessToken() -> AccessToken? {
        guard let token = getAccessTokenValue(), let expiry = getAccessTokenExpiry() else {
            return nil
        }
        return AccessToken(token: token, expires: expiry)
    }

    class func getAccessTokenExpiry() -> String? {
        return keychain.string(forKey: Keychain.Keys.accessTokenExpiry.rawValue, withAccessibility: .whenUnlockedThisDeviceOnly)
    }
}
