// swiftlint:disable force_cast
import Foundation

class UserAgentBuilder {
    var userAgent = ""

    func darwinVersion() -> UserAgentBuilder {
        var sysinfo = utsname()
        uname(&sysinfo)
        let darvinV = String(bytes: Data(bytes: &sysinfo.release, count: Int(_SYS_NAMELEN)),
                             encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
        userAgent += " Darwin/\(darvinV)"
        return self
    }

    func CFNetworkVersion() -> UserAgentBuilder {
//        let dictionary = Bundle(identifier: "com.apple.CFNetwork")?.infoDictionary!
//        let version = dictionary?["CFBundleShortVersionString"] as! String
        userAgent += " CFNetwork/"
        return self
    }

    func deviceVersion() -> UserAgentBuilder {
        let currentDevice = UIDevice.current
        userAgent += " \(currentDevice.systemName)/\(currentDevice.systemVersion)"
        return self
    }

    func deviceName() -> UserAgentBuilder {
        var sysinfo = utsname()
        uname(&sysinfo)
        userAgent +=  " " + String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)),
                                   encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
        return self
    }

    func appNameAndVersion() -> UserAgentBuilder {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let name = dictionary["CFBundleName"] as! String
        userAgent += "\(name)/\(version)"
        return self
    }

    func gzip() -> UserAgentBuilder {
        userAgent += "; gzip"
        return self
    }

    func build() -> String {
        return self.appNameAndVersion().deviceName().deviceVersion().CFNetworkVersion().darwinVersion().gzip().userAgent
    }
}
