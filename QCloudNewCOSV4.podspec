#
# Be sure to run `pod lib lint QCloudCOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "QCloudNewCOSV4"
  s.version          = "5.3.2"
  s.summary          = "New refactored COSV4 framework"

  s.description      = <<-DESC
TODO: Add long description of the pod here.aaa
                       DESC

  s.homepage         = "https://github.com/tencentyun/qcloud-sdk-ios.git"
  s.license          = 'MIT'
  s.author           = { "QCloud Terminal Team" => "QCloudTerminalTeam" }
  s.source           = { :git => "https://github.com/tencentyun/qcloud-sdk-ios.git", :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'QCloudNewCOSV4/Pod/Classes/**'

  s.dependency 'QCloudCore','5.3.2'

end
