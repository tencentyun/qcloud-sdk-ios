Pod::Spec.new do |s|
  s.name             = "QCloudCOSXML"

s.version              = "5.6.4"

  s.summary          = "QCloudCOSXML 腾讯云iOS-SDK组件"

  s.homepage         = "https://cloud.tencent.com/"
  s.license          = 'MIT'
  s.author           = { "QCloud Terminal Team" => "QCloudTerminalTeam" }
  s.source           = { :git => "https://github.com/tencentyun/qcloud-sdk-ios.git", :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = "10.12"

  s.static_framework = true

  s.default_subspec = 'Default'
  s.subspec 'Default' do |default|
  default.source_files = 'QCloudCOSXML/Classes/**/*','Models/request.model','QCloudCOSXML/Classes/QCloudCOSXML/*'
    default.dependency "QCloudCore",'5.6.4'
    end
  s.subspec 'Slim' do |slim|
  slim.source_files = 'QCloudCOSXML/Classes/**/*','Models/request.model','QCloudCOSXML/Classes/QCloudCOSXML/*'
  slim.dependency "QCloudCore/WithoutMTA"
  end
  s.subspec 'Transfer' do |transfer|
  transfer.source_files = 'QCloudCOSXML/Classes/*','QCloudCOSXML/Classes/Transfer/**/*','QCloudCOSXML/Classes/Base/*'
  transfer.dependency "QCloudCore/WithoutMTA"
  end

end
