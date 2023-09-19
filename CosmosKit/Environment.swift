import Foundation

struct Environment {

    enum InstallEnvironment {
        case testflight
        case debug
        case appStore
    }

    static var installEnvironment: InstallEnvironment {
        #if DEBUG
            return .debug
        #else
            if isRunningInTestFlightEnvironment() {
                return .testflight
            } else if isRunningInAppStoreEnvironment() {
                return .appStore
            } else {
                return .debug
            }
        #endif
    }

    static var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    static var isRelease: Bool {
        #if DEBUG
            return false
        #else
            return true
        #endif
    }

    static func showDebugMenu() -> Bool {
        installEnvironment != .appStore
    }

    static func isSimulator() -> Bool {
        TARGET_OS_SIMULATOR != 0
    }
}
private extension Environment {

    static func isRunningInTestFlightEnvironment() -> Bool {
        if isSimulator() {
            return false
        } else {
            if isAppStoreReceiptSandbox() && !hasEmbeddedMobileProvision() {
                return true
            } else {
                return false
            }
        }
    }

    static func isRunningInAppStoreEnvironment() -> Bool {
        if isSimulator() {
            return false
        } else {
            if isAppStoreReceiptSandbox() || hasEmbeddedMobileProvision() {
                return false
            } else {
                return true
            }
        }
    }

    static func hasEmbeddedMobileProvision() -> Bool {
        if let _ = Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") {
            return true
        }
        return false
    }

    static func isAppStoreReceiptSandbox() -> Bool {
        if isSimulator() {
            return false
        } else {
            if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL, appStoreReceiptURL.lastPathComponent == "sandboxReceipt" {
                return true
            }
            return false
        }
    }
}
