#
# Be sure to run `pod lib lint QCloudTrack.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "QCloudTrack"
s.version              = "6.3.9"
  s.summary          = "QCloudTrack 腾讯云iOS-SDK组件"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.aaa
                       DESC

  s.homepage         = "https://cloud.tencent.com/"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "QCloudTerminalLab" => "g_PDTC_storage_DEV_terminallab@tencent.com" }
  s.source           = { :git => "https://github.com/tencentyun/qcloud-sdk-ios.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  # s.frameworks = 'UIKit', 'MapKit'
  s.static_framework = true
  s.ios.deployment_target = '9.0'
  s.default_subspec = 'Default'
  
  s.subspec 'Default' do |default|
    default.ios.deployment_target = '9.0'
    default.osx.deployment_target = "10.12"
    default.source_files = 'QCloudTrack/Classes/*.{h,m}','QCloudTrack/Classes/Default/*.{h,m}','QCloudTrack/Classes/Default/*/*.{h,m}'
  end
  
  s.subspec 'Beacon' do |beacon|
    beacon.ios.deployment_target = '9.0'
    beacon.osx.deployment_target = "10.12"
    beacon.source_files = 'QCloudTrack/Classes/*.{h,m}','QCloudTrack/Classes/Default/*.{h,m}','QCloudTrack/Classes/Default/*/*.{h,m}','QCloudTrack/Classes/Beacon/*.{h,m}'
    beacon.vendored_frameworks = 'QCloudTrack/Classes/BeaconFramework/COSBeaconAPI_Base.framework','QCloudTrack/Classes/BeaconFramework/QimeiSDK.framework'
  end
  
  s.subspec 'Cls' do |cls|
    cls.ios.deployment_target = '9.0'
    cls.source_files = 'QCloudTrack/Classes/*.{h,m}',
                      'QCloudTrack/Classes/Default/*.{h,m}',
                      'QCloudTrack/Classes/Default/*/*.{h,m}',
                      'QCloudTrack/Classes/Cls/*.{h,m}'
    cls.dependency "TencentCloudLogProducer"
  end
end
