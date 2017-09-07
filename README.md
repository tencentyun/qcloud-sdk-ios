# 腾讯云 存储SDK for iOS

## 前言  
您可以在新建项目，配置好SDK或者在已有的项目中集成进SDK，或者先运行下Demo感受下SDK是如何运作的。下载Demo体验请前点击[Demo下载地址](https://github.com/tencentyun/qcloud-sdk-ios-samples.git)。  

使用我们的SDK前，您需要配置好开发环境：  
- Xcode 7 或更新的版本
- 运行环境为 iOS 8 以上       

本仓库中只包含了SDK的代码和docset格式的文档。如果需要更多的信息可以浏览腾讯云官网。具体SDK的文档在对应目录下的REAME.md中。

## 集成SDK
您可以通过Cocoapods集成、下载源代码或者使用我们打包好的动态库来进行SDK的集成工作。在这里我们推荐您使用Cocoapods的方式来进行集成。在您的podfile中加入需要集成的库即可。
```
pod 'QCloudCOSXML'
```    
其他的具体的集成方式可以详见具体库的文档。

## 文档集成
我们提供了docset格式的文档，在仓库的Documents目录中，或者可以从release中下载。您可以直接使用Dash来打开。也可以将文档集成到Xcode中去。
### 集成文档到Xcode
您只需要docset格式的文档移动至 ~/Library/Developer/Shared/Documentation/DocSets文件夹中，然后重启Xcode即可将文档安装至Xcode中。安装成功后可以在Xcode的Help-Documentation and API Reference中查看。您也可以使用命令行完成这一过程
```
 $ cd docset所在路径
```
```
 $ mkdir -p ~/Library/Developer/Shared/Documentation/DocSets
```
```
 $ mv com.tencent.qcloudcosxml.ios.docset ~/Library/Developer/Shared/Documentation/DocSets
```

## iOS9适配
我们的SDK是运行在HTTP上的。由于iOS9之后苹果引入App Transport Security (ATS)特性，集成SDK的APP需要一些额外的步骤来适配iOS9和以上的系统。   

在集成SDK的APP的info.plist中需要添加如下代码：
```
<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSExceptionDomains</key>
		<dict>
			<key>myqcloud.com</key>
			<dict>
				<key>NSIncludesSubdomains</key>
				<true/>
				<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
				<true/>
			</dict>
		</dict>
	</dict>
```
