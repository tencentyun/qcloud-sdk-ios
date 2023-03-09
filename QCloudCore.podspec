#
# Be sure to run `pod lib lint QCloudCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "QCloudCore"


s.version              = "6.2.1"



  s.summary          = "QCloudCore--腾讯云iOS-SDK Foundation"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
QCloudCore--腾讯云iOS-SDK Foundation。提供腾讯云iOS相关SDK的基础能力，包括网络、日志、编程框架、辅助工具等等
                       DESC

  s.homepage         = "https://cloud.tencent.com/"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "QCloud Terminal Team" => "QCloudTerminalTeam" }
  s.source           = { :git => "https://github.com/tencentyun/qcloud-sdk-ios.git", :tag => s.version.to_s }
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = "10.12"
  s.frameworks ='CoreMedia', "Accelerate", "SystemConfiguration"
  s.libraries = "z","c++"
  s.static_framework = true
    s.default_subspec = 'Default'
    s.subspec 'Default' do |default|
        default.source_files = 'QCloudCore/Classes/Base/**/*'
        default.ios.vendored_frameworks = 'QCloudCore/Classes/BeaconFramework/BeaconAPI_Base.framework','QCloudCore/Classes/BeaconFramework/QimeiSDK.framework'
    end
    s.subspec 'WithoutMTA' do |withoutMTA|
        withoutMTA.source_files = 'QCloudCore/Classes/Base/**/*'
    end
end
