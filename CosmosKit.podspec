#
#  Be sure to run `pod spec lint CosmosKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#

Pod::Spec.new do |s|

  s.name         = "CosmosKit"
  s.version      = "2.1.8"
  s.summary      = "Provide access to the Cosmos API"

  s.description  = <<-DESC
This Pod will provide access to the Cosmos API.
                   DESC

  s.homepage     = "http://flatcircle.io"

  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "Flat Circle" => "info@flatcircle.io" }

  s.platform     = :ios, "12.0"

  s.source       = { :git => "https://github.com/flatcircle/CosmosKit_ios.git", :tag => "#{s.version}" }

  s.source_files  = "CosmosKit", "CosmosKit/**/*.{h,m,swift}"
  s.swift_version = "5.0"
  s.resource_bundles = {
    "CosmosKit" => ["CosmosKit/**/*.{storyboard,xib,xcassets,html,json,js,strings}"]
  }
  s.static_framework = true
  s.dependency 'YoutubePlayer-in-WKWebView'
  s.dependency 'SwiftKeychainWrapper'
  s.dependency 'DTCoreText'
  s.dependency 'ReachabilitySwift'
  s.dependency 'Kingfisher'
  s.dependency 'lottie-ios', '3.5.0'
  s.dependency 'AMScrollingNavbar'
  s.dependency 'BTNavigationDropdownMenu'
  s.dependency 'Google-Mobile-Ads-SDK'
  s.dependency 'Firebase/Messaging'
end
