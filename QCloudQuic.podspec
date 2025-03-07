#
# Be sure to run `pod lib lint QCloudQuic.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "QCloudQuic"


s.version              = "6.3.9"


  s.summary          = "QCloudQuic 腾讯云iOS-SDK组件"

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
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = "10.12"
  s.static_framework = true
  s.default_subspec = 'Default'
  s.subspec 'Default' do |default|
      default.source_files = 'QCloudQuic/Classes/*', 'QCloudQuic/Classes/QCloudBase/**/*','QCloudQuic/Classes/QuicFramework//*.{h}'
      default.vendored_frameworks = 'QCloudQuic/Classes/QuicFramework/Tquic.framework'
  end
  s.subspec 'v83' do |v83|
    v83.source_files = 'QCloudQuic/Classes/*', 'QCloudQuic/Classes/QCloudBase/**/*','QCloudQuic/Classes/QuicFrameworkv83//*.{h}'
    v83.vendored_frameworks = 'QCloudQuic/Classes/QuicFrameworkv83/Tquic.framework'
  end
end
