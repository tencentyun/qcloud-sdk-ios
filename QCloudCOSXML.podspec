Pod::Spec.new do |s|
  s.name             = "QCloudCOSXML"


s.version              = "6.4.7"


  s.summary          = "QCloudCOSXML 腾讯云iOS-SDK组件"

  s.homepage         = "https://cloud.tencent.com/"
  s.license          = 'MIT'
  s.author           = { "QCloud Terminal Team" => "QCloudTerminalTeam" }
  s.source           = { :git => "https://github.com/tencentyun/qcloud-sdk-ios.git", :tag => s.version.to_s }
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = "10.12"
  s.resource_bundles = {'QCloudCOSXML' => ['QCloudCOSXML/PrivacyInfo.xcprivacy']}
  s.static_framework = true
  s.default_subspec = 'Default'
  s.subspec 'Default' do |default|
    default.ios.deployment_target = '10.0'
    default.source_files = 'QCloudCOSXML/Classes/**/*','QCloudCOSXML/Classes/QCloudCOSXML/*'
  default.dependency "QCloudCore",'6.4.7'
  end
  s.subspec 'Slim' do |slim|
    slim.ios.deployment_target = '10.0'
    slim.osx.deployment_target = "10.12"
    slim.source_files = 'QCloudCOSXML/Classes/**/*','QCloudCOSXML/Classes/QCloudCOSXML/*'
  slim.dependency "QCloudCore/WithoutMTA",'6.4.7'
  end
  s.subspec 'Transfer' do |transfer|
    transfer.ios.deployment_target = '10.0'
    transfer.osx.deployment_target = "10.12"
    transfer.source_files = 'QCloudCOSXML/Classes/*','QCloudCOSXML/Classes/Transfer/**/*','QCloudCOSXML/Classes/Base/**/*'
  transfer.dependency "QCloudCore/WithoutMTA",'6.4.7'

  end
  
  s.subspec 'Widget' do |widget|
    widget.ios.deployment_target = '10.0'
    widget.osx.deployment_target = "10.12"
    widget.source_files = 'QCloudCOSXML/Classes/*','QCloudCOSXML/Classes/Transfer/**/*','QCloudCOSXML/Classes/Base/**/*'
    widget.exclude_files = 'QCloudCOSXML/Classes/Base/QCloudLogManager.h','QCloudCOSXML/Classes/Base/QCloudLogManager.m'
  widget.dependency "QCloudCore/WithoutMTA",'6.4.7'
  end

end
