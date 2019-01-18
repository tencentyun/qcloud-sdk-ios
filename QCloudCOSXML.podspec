Pod::Spec.new do |s|
  s.name             = "QCloudCOSXML"
s.version              = "5.5.9"
  s.summary          = "QCloudCOSXML 腾讯云iOS-SDK组件"

  s.homepage         = "https://cloud.tencent.com/"
  s.license          = 'MIT'
  s.author           = { "QCloud Terminal Team" => "QCloudTerminalTeam" }
  s.source           = { :git => "https://github.com/tencentyun/qcloud-sdk-ios.git", :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'QCloudCOSXML/Classes/**/*'
  s.dependency "QCloudCore",'5.5.9'
  s.static_framework = true

  s.subspec 'Transfer' do |sbt|
    sbt.source_files = 'QCloudCOSXML/Classes/*','QCloudCOSXML/Classes/Transfer/**/*','QCloudCOSXML/Classes/Base/*'
    sbt.dependency "QCloudCore",'5.5.9'
 #   sbt.static_framework=true
  end
end
