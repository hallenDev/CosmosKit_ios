platform :ios, '12.0'
install! 'cocoapods', :deterministic_uuids => false, :warn_for_unused_master_specs_repo => false

target 'CosmosKitDemo' do
use_frameworks!

  pod 'SwiftLint'
  pod 'CosmosKit', :path => './'

end

target 'CosmosKit' do
  use_frameworks!

  pod 'SwiftLint' # code linting
  pod 'YoutubePlayer-in-WKWebView' # used for playing youtube widgets
  pod 'SwiftKeychainWrapper' # used to store things securely in they keychain
  pod 'DTCoreText' # used to parse html strings
  pod 'ReachabilitySwift' # used for network handling
  pod 'Kingfisher' # used to load images from url
  pod 'lottie-ios', '3.5.0' # used for animations, version specified: 3.2.1 introduced an issue where the pod has no content
  pod 'AMScrollingNavbar'
  #pod 'BTNavigationDropdownMenu', :git => 'git@github.com:flatcircle/BTNavigationDropdownMenu.git' # used for the drop down nav menu
  pod 'BTNavigationDropdownMenu', :git => 'https://www.github.com/flatcircle/         .git' # used for the drop down nav menu
  pod 'Google-Mobile-Ads-SDK' # used for ads
  pod 'Firebase/Messaging' # for push notification subscriptions
  pod 'SwiftLint'

  target 'CosmosKitTests' do
    inherit! :search_paths
  end

end

post_install do |pi|
   pi.pods_project.targets.each do |t|
       t.build_configurations.each do |bc|
           if bc.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] == '8.0'
             bc.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
           end
       end
   end
end
