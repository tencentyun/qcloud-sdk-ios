Pod::Spec.new do |s|
  s.name             = "QCloudCOSXML"


s.version              = "6.5.5"


  s.summary          = "QCloudCOSXML 腾讯云iOS-SDK组件"

  s.homepage         = "https://cloud.tencent.com/"
  s.license          = 'MIT'
  s.author           = { "QCloud Terminal Team" => "QCloudTerminalTeam" }
  s.source           = { :git => "https://github.com/tencentyun/qcloud-sdk-ios.git", :tag => s.version.to_s }
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = "10.13"
  s.resource_bundles = {'QCloudCOSXML' => ['QCloudCOSXML/PrivacyInfo.xcprivacy']}
  s.static_framework = true
  s.pod_target_xcconfig = { 'LLVM_LTO' => 'NO' }
  s.default_subspec = 'Default'
  s.subspec 'Default' do |default|
    default.ios.deployment_target = '10.0'
    default.source_files = 'QCloudCOSXML/Classes/**/*','QCloudCOSXML/Classes/QCloudCOSXML/*'
  default.dependency "QCloudCore",'6.5.5'
  end
  s.subspec 'Slim' do |slim|
    slim.source_files = 'QCloudCOSXML/Classes/**/*','QCloudCOSXML/Classes/QCloudCOSXML/*'
    slim.osx.exclude_files = 'QCloudCOSXML/Classes/Base/QCloudAbstractRequest+Quality.*'
  slim.dependency "QCloudCore/WithoutMTA",'6.5.5'
  end
  s.subspec 'Transfer' do |transfer|
    transfer.source_files = 'QCloudCOSXML/Classes/*','QCloudCOSXML/Classes/Transfer/**/*','QCloudCOSXML/Classes/Base/**/*'
    transfer.osx.exclude_files = 'QCloudCOSXML/Classes/Base/QCloudAbstractRequest+Quality.*'
  transfer.dependency "QCloudCore/WithoutMTA",'6.5.5'

  end
  
  s.subspec 'Widget' do |widget|
    widget.ios.deployment_target = '10.0'
    # widget.osx.deployment_target = "10.12"
    widget.source_files = 'QCloudCOSXML/Classes/*','QCloudCOSXML/Classes/Transfer/**/*','QCloudCOSXML/Classes/Base/**/*'
    widget.exclude_files = 'QCloudCOSXML/Classes/Base/QCloudLogManager.h','QCloudCOSXML/Classes/Base/QCloudLogManager.m'
  widget.dependency "QCloudCore/WithoutMTA",'6.5.3'
  end

end
