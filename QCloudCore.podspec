#
# Be sure to run `pod lib lint QCloudCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "QCloudCore"
s.version              = "5.6.1"
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
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.ios.deployment_target = '8.0'
  s.source_files = "QCloudCore/Classes/**/**/*"
  s.frameworks ='CoreMedia', "Accelerate", "SystemConfiguration" 
  s.libraries = "z","c++"
  s.public_header_files = "QCloudCore/Classes/**/*.h"
  s.static_framework = true
  s.vendored_libraries='QCloudCore/Classes/QualityAssurance/libmtasdk.a'
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
