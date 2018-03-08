# 快速集成与入门

## 前言
**对于新接入COS SDK的用户，我们推荐使用[基于XML API封装的SDK](https://cloud.tencent.com/document/product/436/11280)**    
对于种种原因仍需要使用V4 SDK的用户，可以使用这一版我们基于旧版本V4 SDK重构后的SDK。

## 开发准备

### SDK 获取

对象存储服务的 iOS SDK 地址：[iOS SDK](https://github.com/tencentyun/qcloud-sdk-ios.git)    
需要下载打包好的Framework格式的SDK可以从realease中选择需要的版本进行下载。

更多示例可参考Demo：[iOS Demo](https://github.com/tencentyun/qcloud-sdk-ios-samples.git)    
（本版本SDK基于COS JSON API封装组成）

### 环境要求

-  iOS 8.0+；
-  手机必须要有网络（GPRS、3G或Wifi网络等）；


### SDK 配置

#### SDK 导入
您可以通过cocoapods或者下载打包好的动态库的方式来集成SDK。在这里我们推荐您使用cocoapods的方式来进行导入。
##### 使用Cocoapods导入(推荐)

在Podfile文件中使用：

~~~
pod 'QCloduCOSNewV4'
~~~

##### 使用打包好的动态库导入

将我们提供的**QCloudNewCOSV4.framework和QCloudCore.framework**拖入到工程中, 并且勾选 Copy items if needed：
![](http://eric-image-bed-1253653367.cosgz.myqcloud.com/Frameworks%E6%88%AA%E5%9B%BE.png  )
并添加以下依赖库：

1. CoreTelephony
2. Foundation
3. SystemConfiguration
4. libstdc++.tbd

#### 工程配置

在 Build Settings 中设置 Other Linker Flags，加入参数 -ObjC。

![参数配置](http://ericcheung-1253653367.cosgz.myqcloud.com/WechatIMG24.jpeg)

默认情况下，我们的SDK使用的是HTTP协议。为了在iOS系统上可以运行，您需要开启允许通过HTTP传输。具体操作步骤是在工程info.plist文件中添加App Transport Security Settings 类型，然后在App Transport Security Settings下添加Allow Arbitrary Loads 类型Boolean,值设为YES。或者您可以在集成SDK的APP的info.plist中需要添加如下代码：
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
**注意这段配置的作用是使URL是myqcloud.com后缀的HTTP请求可以发出。如果您使用了动态加速功能，那么请设置对应的后缀**    

## 快速入门
在本章节里，将会讲述如何从0开始，快速使用SDK完成最简单的上传文件的操作。     

需要完成最简单的上传文件操作，我们需要做以下几步：    
1. 初始化
2. 在获取签名的回调里，通过在线/本地生成签名
3. 构建一个上传对象的请求，并且发送。    

接下来我们将一步步详细地说明如何操作。每一步都会有具体的代码示例，你可以将代码粘贴到项目中，修改参数后运行。因为是快速入门，演示的都是可以完成操作的最低要求。如果希望使用更高级的功能，可以参考我们的注释或者接口文档里更详细的参数说明。


### 一、初始化

在使用SDK的功能之前，我们需要导入一些必要的头文件和进行一些初始化工作。

引入上传 SDK 初始化必须的头文件
```
#import "QCloudCOSV4TransferManagerService.h"
#import "QCloudCOS.h"
#import "QCloudV4EndPoint.h"
```

 使用 SDK 操作时，需要先实例化 *QCloudCOSV4Service* 和 *QCloudCOSV4TransferManagerService* 对象。实例化这两个对象之前我们要实例化一个云服务配置对象*QCloudServiceConfiguration*。

#### 例子
```objective-c
//AppDelete.m

- (BOOL)application:(UIApplication* )application didFinishLaunchingWithOptions:(NSDictionary* )launchOptions {
    // Override point for customization after application launch.
    [self initCOS];
    return YES;
}

- (void)initCOS {
    QCloudServiceConfiguration* configuration = [[QCloudServiceConfiguration alloc ] init];
    configuration.appID = @"您的APPID";
    configuration.signatureProvider = self;
    QCloudV4EndPoint* endpoint = [[QCloudV4EndPoint alloc] init];
    endpoint.regionName = @"服务园区名称，例如gz";
    endpoint.serviceHostSubfix = @"file.myqcloud.com";
    configuration.endpoint = endpoint;

    [QCloudCOSV4Service registerDefaultCOSV4WithConfiguration:configuration];
    [QCloudCOSV4TransferManagerService registerDefaultCOSV4TransferMangerWithConfiguration:configuration];
}

```



#### QCloudServiceConfiguration参数说明

| 参数名称   | 类型         | 是否必填 | 说明                                       |
| ------ | ---------- | ---- | ---------------------------------------- |
| appID  | NSString * | 是    | 项目ID，即APP ID。                            |
|signatureProvider|id|是|签名的提供者。请求发出前会向该provider对象请求签名，对象需要实现签名的回调方法|

#### QCloudV4EndPoint参数说明

| 参数名称   | 类型         | 是否必填 | 说明                                       |
| ------ | ---------- | ---- | ---------------------------------------- |
| regionName  | NSString * | 是    | 服务园区名称                            |
| serviceHostSubfix|NSString*|是|服务后缀名称，默认填file.myqcloud.com。如果使用动态加速的话，可以使用动态加速对应的服务后缀名|
|useHTTPS|BOOL|否|是否通过HTTPS传输数据。填YES的话，会通过HTTPS协议发出请求|


### 二、生成签名
SDK里绝大部分的请求都要通过签名来鉴权。在前面初始化过程中，我们指定了签名的提供者。接下来，我们需要在签名提供者里面实现签名的回调。在前一章节中，我们签名的提供者是AppDelegate，那么这里我们也以在该对象里实现签名回调为例。    

```objective-c
- (void) signatureWithFields:(QCloudSignatureFields* )fileds    
                     request:(QCloudBizHTTPRequest* )request    
                  urlRequest:(NSURLRequest* )urlRequst    
                   compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock
```

在签名回调里，需要完成的是生成一个包含签名的QCloudSignature对象，并且将该对象作为continueBlock的参数，调用continueBlock即可，SDK会自动帮你完成后续的操作。    

在该回调里面获取签名有两种方式：    

1.通过永久的SecretID，SecretKey生成签名。**（极其不推荐这种方式，密钥放在客户端本地会有极大的泄露风险）**         

```objective-c
- (void)signatureWithFields:(QCloudSignatureFields* )fileds request:(QCloudBizHTTPRequest* )request urlRequest:(NSMutableURLRequest * )urlRequst compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock {
    QCloudCredential* credential = [QCloudCredential new];
    credential.secretID = @"填入控制台获取的SecretID";
    credential.secretKey = @"填入控制台获取的SecretKey";
    QCloudAuthentationV4Creator* creator = [[QCloudAuthentationV4Creator alloc] initWithCredential:credential];
    QCloudSignature* signature =  [creator signatureForData:fileds];
    continueBlock(signature, nil);
}
```     



2.向服务器请求签名。（**推荐**，将实现签名的过程放在服务器端，最大限度保障了安全）
```objective-c
- (void)signatureWithFields:(QCloudSignatureFields* )fileds request:(QCloudBizHTTPRequest* )request urlRequest:(NSMutableURLRequest * )urlRequst compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock {
    //在这里先向签名服务器请求签名。
    NSString* authorizationFromServer = @"这是服务器返回的最终签名"
    QCloudSignature* signature =  [QCloudSignature signatureWith1Day:authorizationFromServer];
    continueBlock(signature, nil);
}
```
### 三、上传文件    
上传文件或者使用其它的接口都是类似的，分为三个步骤：
1. 构建相应的request
2. 填入参数
3. 通过 QCloudCOSV4Service 或者 QCloudCOSV4TransferMangerService 执行request    

至于每个接口的作用，是否有某个接口，建议直接查看QCloudCOSV4Service,  QCloudCOSV4TransferMangerService, 以及每个request中的注释。

#### 上传文件例子    
```objective-c
- (void)uploadObjectWithPath:(NSString* path) {
  QCloudCOSV4UploadObjectRequest* request = [[QCloudCOSV4UploadObjectRequest alloc] init];
  request.bucket = @"填入存储桶名称";
  request.fileName = @"填入文件名";
  request.filePath = @"填入文件在本地的URL";

  //文件在上传过程中的进度回调
  [request setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSent) {
    NSLog(@"bytesSent:%i totalByteSent:%i totalBytesExpectedToSent:%i",bytesSent,totalBytesSent,totalBytesExpectedToSent);
  }];

  //上传结束后的回调
  [request setFinishBlock:^(QCloudUploadObjectResult* result, NSError* error) {
    if (nil == error) {
        NSLog(@"Upload finished!");
        //获取可以用于以后下载的URL
        NSStrung* downloadURL = result.url;
    }
  }];

  //调用TransferManager发出请求
  [[QCloudCOSV4TransferManagerService defaultCOSV4TransferManager] uploadObject:request];

}
```

# 详细接口文档
前面我们提到过，当环境搭好了以后，SDK的接口调用方式都是以下这三步：
1. 生成一个对应的request
2. 填好参数
3. 如果是上传文件的接口，使用QCloudCOSV4TransferManagerService 发出请求。如果是其他接口，那么使用QCloudCOSV4Service发出请求。    

明白这一点以后，接下来我们不会赘述每个接口如何具体操作。对于每个接口，我们会给出作用说明、示例、输入与输出参数列表和注意事项。如果需要使用该接口的基础功能，直接复制例子的代码即可运行。若需要更多扩展的功能，可以参照参数列表和示例。    

**在所有接口的完成回调里，若没有error，则都可以视为成功。**

## 文件相关接口

### 上传文件
这是一个聚合的上传文件的接口，调用这个接口无需考虑是简单上传还是分片上传等问题，SDK内部会进行判断并根据情况使用合适的上传方式，无需管理。
#### 示例
```objective-c
QCloudCOSV4UploadObjectRequest* request = [[QCloudCOSV4UploadObjectRequest alloc] init];
request.bucket = @"填入存储桶名称";
request.fileName = @"填入文件名";
request.filePath = @"填入文件在本地的URL";

//文件在上传过程中的进度回调
[request setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSent) {
	NSLog(@"bytesSent:%i totalByteSent:%i totalBytesExpectedToSent:%i",bytesSent,totalBytesSent,totalBytesExpectedToSent);
}];

//上传结束后的回调
[request setFinishBlock:^(QCloudUploadObjectResult* result, NSError* error) {
	if (nil == error) {
			NSLog(@"Upload finished!");
			//获取可以用于以后下载的URL
			NSStrung* downloadURL = result.url;
	}
}];

//调用TransferManager发出请求
[[QCloudCOSV4TransferManagerService defaultCOSV4TransferManager] uploadObject:request];

}
```

#### QCloudCOSV4UploadObjectRequest参数说明    
|名称|类型|是否必填|作用|    
|-------|-------|------------|-------|    
|filePath|NSString*|是|上传的文件在本地的URL|
|bizAttribute|NSString*|否|文件的自定义属性|
|insertOnley|BOOL|否|同名文件覆盖选项，有效值：0 覆盖（删除已有的重名文件，存储新上传的文件）1 不覆盖（若已存在重名文件，则不做覆盖，返回“上传失败”; 若新上传文件sha值与已存在重名文件相同，返回成功）。默认为 1 不覆盖。|
|bucket|NSString*|是|COS上面的存储桶名|
|directory|NSString*|否|在COS存储桶下的目录|
|fileName|NSString*|是|在COS上面的文件名|

#### QCloudUploadObjectResult参数说明

|名称|类型|作用|    
|-------|-------|-------|    
|accessURL|NSString*|通过 CDN 访问该文件的资源链接（访问速度更快）|
|resourcePath|NSString*|该文件在 COS 中的相对路径名，可作为其 ID 标识。 格式/<APPID>/<BucketName>/<ObjectName>。推荐业务端存储 resource_path，然后根据业务需求灵活拼接资源 url（通过 CDN 访问 COS 资源的 url 和直接访问 COS 资源的 url 不同）。|
|sourceUrl|NSString*|（不通过 CDN）直接访问 COS 的资源链接。该链接经过了URL Encode|
|url|NSString*|不通过 CDN）直接访问 COS 的资源链接。该链接没有经过URL Encode|

### 简单上传文件
小于20M的文件可以使用简单上传。我们推荐使用前面的上传接口，它会自动判断是否需要分片上传并进行处理。
#### 示例
```objective-c
		QCloudUploadObjectSimpleRequest* request = [[QCloudUploadObjectSimpleRequest alloc] init];
    request.bucket = testBucket;
    request.filePath = @"填入文件本地路径";
    request.fileName = @"填入文件在COS上的文件名";
		[request setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSent) {
			//设置进度回调
	 }];
	 [request setFinishBlock:^(QCloudUploadObjectResult* result, NSError* error) {
		 //设置完成回调
	 }];
	 [[QCloudCOSV4Service defaultCOSV4] UploadObjectSimple:request];

```
#### QCloudUploadObjectSimpleRequest参数说明
|名称|类型|是否必填|作用|    
|-------|-------|------------|-------|    
|filePath|NSString*|是|上传的文件在本地的URL|
|bizAttribute|NSString*|否|文件的自定义属性|
|insertOnley|BOOL|否|同名文件覆盖选项，有效值：0 覆盖（删除已有的重名文件，存储新上传的文件）1 不覆盖（若已存在重名文件，则不做覆盖，返回“上传失败”; 若新上传文件sha值与已存在重名文件相同，返回成功）。默认为 1 不覆盖。|
|bucket|NSString*|是|COS上面的存储桶名|
|directory|NSString*|否|在COS存储桶下的目录|
|fileName|NSString*|是|在COS上面的文件名|
#### 返回结果QCloudUploadObjectResult参数说明    
|名称|类型|作用|    
|-------|-------|-------|    
|accessURL|NSString*|通过 CDN 访问该文件的资源链接（访问速度更快）|
|resourcePath|NSString*|该文件在 COS 中的相对路径名，可作为其 ID 标识。 格式/<APPID>/<BucketName>/<ObjectName>。推荐业务端存储 resource_path，然后根据业务需求灵活拼接资源 url（通过 CDN 访问 COS 资源的 url 和直接访问 COS 资源的 url 不同）。|
|sourceUrl|NSString*|（不通过 CDN）直接访问 COS 的资源链接。该链接经过了URL Encode|
|url|NSString*|不通过 CDN）直接访问 COS 的资源链接。该链接没有经过URL Encode|

### 初始化分片上传
#### 示例
```objective-c
QCloudUploadSliceInitRequest* request = [QCloudUploadSliceInitRequest new];
 request.sliceSize = //分片大小;
 request.sha = //文件sha值;
 request.fileSize = //;
 request.uploadParts = middleSHAs;

 	request.bucket = self.bucket;
 	request.directory = self.directory;
 	request.fileName = self.fileName;
  [request setFinishBlock:^(QCloudUploadSliceInitResult*  outputObject, NSError*  error) {
		//初始化完成回调
	}];
	[QCloudCOSV4Service defaultCOSV4] performRequest:request];

```
#### QCloudUploadSliceInitRequest参数说明
|名称|类型|是否必填|作用|    
|-------|-------|------------|-------|    
|filePath|NSString*|是|上传的文件在本地的URL|
|bizAttribute|NSString*|否|文件的自定义属性|
|bucket|NSString*|是|COS上面的存储桶名|
|directory|NSString*|否|在COS存储桶下的目录|
|fileName|NSString*|是|在COS上面的文件名|
|sliceSize|int64_t|是|每个分片的大小|
|fileSize|int64_t|是|上传的文件大小|
|sha|NSString*|是|文件的sha值|
|uploadParts|NSArray*|是|存放每个分片的信息的数组|

#### QCloudUploadSliceInitResult参数说明

|名称|类型|作用|    
|-------|-------|-------|  
|session|NSString*|唯一标识此文件传输过程的 id，由后台下发|
|sliceSize|int64_t|分片大小，单位为 Byte。有效值为512KB, 1MB, 2MB, 3MB|
|url|NSString*|未经过URL Encode的URL。不经过CDN的话可以使用该URL下载|
|accessURL|NSString*|通过 CDN 访问该文件的资源链接（访问速度更快）|    
|sourceURL|NSString*|（不通过 CDN ）直接访问 COS 的资源链接|
|resourcePath|NSString*|该文件在 COS 中的相对路径名，可作为其 ID 标识。 格式 '/appid/bucket/filename'。推荐业务端存储 resource_path，然后根据业务需求灵活拼接资源 url（通过 CDN 访问 COS 资源的 url 和直接访问 COS 资源的 url 不同）。|     


### 逐个上传分片
#### 示例
```objective-c
QCloudUploadSliceDataRequest* dataRequest = [QCloudUploadSliceDataRequest new];
			 dataRequest.sha = @"文件的sha值"
			 dataRequest.offset = @"该分片的偏移量"
			 dataRequest.sliceLength = @"该分片的长度";
			 dataRequest.localPath = @"文件在本地的路径";

			 dataRequest.fileName = @"在COS上的文件名";
			 dataRequest.directory = @"在COS上的文件路径";
			 dataRequest.bucket = @"存储同名";
			 dataRequest.session = @"标志该次分片上传的session";
			 dataRequest.fileLength = @"文件的总大小";

		 [dataRequest setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
			 //设置上传进度回调
		  }];
		  [dataRequest setFinishBlock:^(QCloudUploadSliceResult* outputObject, NSError* error ) {
			  //设置完成回调
		  }];
		[[QCloudCOSV4Service defaultCOSV4] performRequest:dataRequest];

```
#### QCloudUploadSliceDataRequest参数说明
|名称|类型|是否必填|作用|    
|-------|-------|------------|-------|  
|bucket|NSString*|是|在COS上的存储桶名|
|directory|NSString*|否|在COS上存储桶下的路径|
|fileName|NSString|是|在COS上的文件名|
|localPath|NSString*|是|文件在本地的路径|
|session|NSString*|是|唯一标识此文件传输过程的 id，由后台下发|
|offset|int64_t|是|偏移量|
|sliceLength|int64_t|是|分片大小|
|sha|NSString*|是|全文的sha, 如果初始化分片上传操作指定了sha参数，那么分片上传也必须带上sha参数|
|fileLength|int64_t|是|文件的大小|
#### QCloudUploadSliceResult参数说明
|名称|类型|作用|    
|-------|-------|-------|    
|session|NSString*|唯一标识此文件传输过程的 id，由后台下发|
|offset|int64_t|该分片的偏移量|
|dataLength|int64_t|该分片的大小|
### 结束上传分传
#### 示例
```objective-c
		QCloudUploadSliceFinishRequest* finish = [QCloudUploadSliceFinishRequest new];
		finish.bucket = @"COS上的存储桶名";
		finish.directory = @"COS上的目录名";
		finish.fileName = @"COS上的文件名";

		finish.session = @"标志该次分片上传的session";
		finish.filesize = @"文件的总大小";
		finish.sha = @"文件的sha值";
		[finish setFinishBlock:^(QCloudUploadSliceFinishResult*  result, NSError*  error) {
			//设置上传回调
		}];
		[[QCloudCOSV4Service defaultCOSV4] performRequest:finish];
```
#### QCloudUploadSliceFinishRequest 参数说明
|名称|类型|是否必填|作用|    
|-------|-------|------------|-------|    
|bucket|NSString*|是|在COS上的存储桶名|
|directory|NSString*|否|在COS上存储桶下的路径|
|fileName|NSString|是|在COS上的文件名|
|session|NSString*|是|唯一标识此文件传输过程的 id，由后台下发|
|sha|NSString*|是|全文的sha, 如果初始化分片上传操作指定了sha参数，那么分片上传也必须带上sha参数|
|fileSize|int64_t|是|文件大小，需要与初始化分片上传时指定的文件大小一致，否则会返回-4019|

#### QCloudUploadSliceFinishResult参数说明
|名称|类型|作用|    
|-------|-------|-------|    
|accessURL|NSString*|通过 CDN 访问该文件的资源链接（访问速度更快）|
|resourcePath|NSString*|该文件在 COS 中的相对路径名，可作为其 ID 标识。 格式/<APPID>/<BucketName>/<ObjectName>。推荐业务端存储 resource_path，然后根据业务需求灵活拼接资源 url（通过 CDN 访问 COS 资源的 url 和直接访问 COS 资源的 url 不同）。|
|sourceUrl|NSString*|（不通过 CDN）直接访问 COS 的资源链接。该链接经过了URL Encode|
|url|NSString*|不通过 CDN）直接访问 COS 的资源链接。该链接没有经过URL Encode|

### 查询上传分片
#### 示例
```objective-c
QCloudListUploadSliceRequest* request = [[QCloudListUploadSliceRequest alloc] init];
 request.bucket = @"填入存储桶名";
 request.fileName = @"填入文件名";
 [request setFinishBlock:^(QCloudListUploadSliceResult* result, NSError* error) {
	 //设置完成回调
 }];
 [[QCloudCOSV4Service defaultCOSV4] ListUploadSlice:request];
```
#### QCloudListUploadSliceRequest参数说明
|名称|类型|是否必填|作用|    
|-------|-------|------------|-------|    
|bucket|NSString*|是|在COS上的存储桶名|
|directory|NSString*|否|在COS上存储桶下的路径|
|fileName|NSString|是|在COS上的文件名|
#### QCloudListUploadSliceResult参数说明
|名称|类型|作用|    
|-------|-------|-------|  
|filesize|int64_t|文件大小|
|listParts|NSArray*|已经完全上传的文件分片信息|
|session|NSString*|唯一标识此文件传输过程的 id，命中秒传则不携带|
|sliceSize|int64_t| 分片大小，单位为 Byte。有效值：524288 (512 KB), 1048576 (1 MB), 2097152 (2 MB), 3145728 (3 MB)|

### 查询文件属性
#### 示例
```objective-c
QCloudFileAttributesRequest* request = [[QCloudFileAttributesRequest alloc] init];
	 request.bucket = @"填入存储桶名";
	 request.fileName = @"填入文件名";
	 	 [request setFinishBlock:^(QCloudFileInfo* result, NSError* error) {
	 }];
	 [[QCloudCOSV4Service defaultCOSV4] FileAttributes:request];
```
#### QCloudFileAttributesRequest参数说明
|名称|类型|是否必填|作用|    
|-------|-------|------------|-------|    
|bucket|NSString*|是|在COS上的存储桶名|
|directory|NSString*|否|在COS上存储桶下的路径|
|fileName|NSString|是|在COS上的文件名|
#### QCloudFileInfo参数说明
|名称|类型|作用|    
|-------|-------|-------|    
|accessURL|NSString*|通过 CDN 访问该文件的资源链接（访问速度更快）|
|sourceUrl|NSString*|（不通过 CDN）直接访问 COS 的资源链接。该链接经过了URL Encode|
|attribute|NSString*|COS 服务调用方自定义属性，可通过 查询目录属性 获取该属性值|
|customHeaders|NSDictionary*|用户自定义头部|
|name|NSString*|文件名|
|fileSize|int64_t|文件大小，当类型为文件时返回|
|fileLength|int64_t|文件已传输大小，当类型为文件时返回|
|sha|NSString|文件 sha，当类型为文件时返回|
|ctime|NSString*|创建时间，10位 Unix 时间戳|
|mtime|NSString*|修改时间，10位 Unix 时间戳|
### 更新文件属性
#### 示例
```objective-c
QCloudUpdateFileAttributesRequest* request = [[QCloudUpdateFileAttributesRequest alloc] init];
	request.bucket = testBucket;
	request.fileName = @"填入文件名";
	request.attributes = @"填入自定义属性";
	request.flag = QCloudUpdateAttributeFlagBizAttr;
	[request setFinishBlock:^(NSDictionary* result, NSError* error) {
			//设置完成回调
	}];
	[[QCloudCOSV4Service defaultCOSV4] UpdateFileAttributes:request];
```
#### QCloudUpdateFileAttributesRequest参数说明
|名称|类型|是否必填|作用|    
|-------|-------|------------|-------|    
|bucket|NSString*|是|在COS上的存储桶名|
|directory|NSString*|否|在COS上存储桶下的路径|
|fileName|NSString|是|在COS上的文件名|
|customHeaders|NSDictionary*|否|用户自定义 header，在执行更新操作时，只需填写需要增加或修改的项|
|authority|NSString*|否|Object 的权限，默认与 Bucket 权限一致，此时不会返回该字段。如果设置了独立权限，则会返回该字段。有效值：eInvalid（空权限），此时系统会默认调取 Bucket 权限，eWRPrivate（私有读写） ，eWPrivateRPublic （公有读私有写）|
|flag|QCloudUpdateAttributeFlag|是|更新属性的时候需要带上一个flag，更新属性时该flag为QCloudUpdateAttributeFlagBizAttr|
|attributes|NSString*|COS 服务调用方自定义属性，可通过 查询目录属性 获取该属性值|
### 复制文件
#### 示例
```objective-c
QCloudCopyFileRequest* request = [[QCloudCopyFileRequest alloc] init];
	 request.bucket = @"填入存储桶名";
	 request.fileName = @"填入COS上的文件名";
	 request.destination = @"复制到的目的COSPath";
	 XCTestExpectation* expectation = [self expectationWithDescription:@"Copy File"];
	 [request setFinishBlock:^(NSDictionary* result, NSError* error) {
			 XCTAssertNil(error);
			 [expectation fulfill];
	 }];
	 [[QCloudCOSV4Service defaultCOSV4] CopyFile:request];
```
#### QCloudCopyFileRequest参数说明
|名称|类型|是否必填|作用|    
|-------|-------|------------|-------|    
|bucket|NSString*|是|在COS上的存储桶名|
|directory|NSString*|否|在COS上存储桶下的路径|
|fileName|NSString||是|在COS上的文件名|
|destination|NSString*|是|复制到的目的COSPath|
### 下载文件
#### 示例
```objective-c
QCloudDownloadFileRequest* downloadRequest = [[QCloudDownloadFileRequest alloc] init];
	 downloadRequest.fileURL = @"文件的URL。注意需要没有URL Encode过的URL";
	 downloadRequest.downloadingURL = @"如果设置了该URL的话，那么文件将会被下载到URL里。否则会在存放在内存中，在完成回调中返回。";

	 [downloadRequest setFinishBlock:^(id outputObject, NSError* error) {
		//下载完成回调
	 }];
	 [[QCloudCOSV4Service defaultCOSV4] DownloadFile:downloadRequest];
```
#### QCloudDownloadFileRequest参数说明
|名称|类型|是否必填|作用|    
|-------|-------|------------|-------|  
|fileURL|NSString*|是|文件在COS上面的URL。注意需要没有URL Encode过的URL|    

### 移动文件
#### 示例
```objective-c
		QCloudMoveFileRequest* request = [[QCloudMoveFileRequest alloc] init];
		request.bucket = testBucket;
		request.destination = @"testMove.txt";
		request.fileName = testFileName;
		request.finishBlock = ^(id outputObject , NSError* error) {
		};
		[[QCloudCOSV4Service defaultCOSV4] MoveFile:request];
```
#### QCloudMoveFileRequest参数说明
|名称|类型|是否必填|作用|    
|-------|-------|------------|-------|    
|bucket|NSString*|是|COS上面的存储桶名|
|directory|NSString*|否|在COS存储桶下的目录|
|fileName|NSString*|是|在COS上面的文件名|
|destination|NSString*|是|目标路径（不带路径则为当前路径下，带路径则会移动到携带指定的路径下）|
|overWrite|BOOL|否|覆盖写入目标文件选项，有效值:0 不覆盖（若已存在重名文件，则不做覆盖，返回“移动失败”）1 覆盖。默认值为 0 不覆盖。|
### 删除文件
#### 示例
```objective-c
			QCloudDeleteFileRequest* request = [[QCloudDeleteFileRequest alloc] init];
			request.bucket = testBucket;
			request.fileName = @"填入文件名";
			[request setFinishBlock:^(NSDictionary* reuslt, NSError* error) {
					//删除完成回调
			}];
			[[QCloudCOSV4Service defaultCOSV4] DeleteFile:request];
```
#### QCloudDeleteFileRequest参数说明
|名称|类型|是否必填|作用|    
|-------|-------|------------|-------|    
|bucket|NSString*|是|COS上面的存储桶名|
|directory|NSString*|否|在COS存储桶下的目录|
|fileName|NSString*|是|在COS上面的文件名|

## 目录相关接口   
### 创建目录

#### 示例
```objective-c
	QCloudCreateDirectoryRequest* request = [[QCloudCreateDirectoryRequest alloc] init];
	 request.bucket = testBucket;
	 request.directory = testDirectory;
	 [request setFinishBlock:^(QCloudCreateDirectoryResult* result, NSError* error) {
		 //完成回调
	 }];
	 [[QCloudCOSV4Service defaultCOSV4] CreateDirectory:request];

```
#### QCloudCreateDirectoryRequest参数说明
|名称|类型|是否必填|作用|    
|-------|-------|------------|-------|    
|bucket|NSString*|是|COS上面的存储桶名|
|directory|NSString*|否|在COS存储桶下的目录|
|bizAttribute|NSString*|否|自定义属性|
#### QCloudCreateDirectoryResult参数说明
|名称|类型|作用|    
|-------|-------|-------|  
|ctime|NSString*|文件夹创建时间|

### 查询目录属性
#### 示例
```objective-c
		QCloudDirectoryAttributesRequest* request = [[QCloudDirectoryAttributesRequest alloc] init];
		request.bucket = testBucket;
		request.directory = testDirectory;
		[request setFinishBlock:^(QCloudDirectoryAttributesResult* result, NSError* error) {
			//设置完成回调
		}]；
		[[QCloudCOSV4Service defaultCOSV4] DirectoryAttributes:request];
```
#### QCloudDirectoryAttributesRequest参数说明
|名称|类型|是否必填|作用|    
|-------|-------|------------|-------|    
|bucket|NSString*|是|COS上面的存储桶名|
|directory|NSString*|否|在COS存储桶下的目录|

#### QCloudDirectoryAttributesResult参数说明
|名称|类型|作用|    
|-------|-------|-------|    
|attributes|NSString*|COS 服务调用方自定义属性|
|createTime|NSString*|创建时间，10 位 Unix 时间戳（UNIX时间是从协调世界时 1970 年 1 月 1 日 0 时 0 分 0 秒起的总秒数）|
|lastModifiedTime|NSString*|修改时间，10 位 Unix 时间戳（UNIX时间是从协调世界时 1970 年 1 月 1 日 0 时 0 分 0 秒起的总秒数）|

### 列出目录
#### 示例
```objective-c
QCloudListDirectoryRequest* request = [[QCloudListDirectoryRequest alloc] init];
			request.bucket = @"存储桶名称";
			request.directory = @"目录名";
			request.number = 1000;
			[request setFinishBlock:^(QCloudListDirectoryResult* result, NSError* error) {
				//完成回调
			}];
			[[QCloudCOSV4Service defaultCOSV4] ListDirectory:request];
```
#### QCloudListDirectoryRequest参数说明
|名称|类型|是否必填|作用|    
|-------|-------|------------|-------|    
|bucket|NSString*|是|COS上面的存储桶名|
|directory|NSString*|否|在COS存储桶下的目录|
|context|NSString*|否|透传字段，查看第一页，则传空字符串。若需要翻页，需要将前一页返回值中的context透传到参数中。|
|number|int|否|返回的条目。默认199，最大199|
#### QCloudListDirectoryResult参数说明
|名称|类型|作用|    
|-------|-------|-------|
|context|NSString*|透传字段，用于翻页，业务端不需理解，需要往后翻页则透传给腾讯云|
|listOver|BOOL|是否有内容可以继续往后翻页|
|files|NSArray*|文件和文件夹列表，若当前目录下不存在文件或文件夹，则该返回值可能为空|
### 删除目录
#### 示例
```objective-c
QCloudDeleteDirectoryRequest* request = [[QCloudDeleteDirectoryRequest alloc] init];
							 request.bucket = @"bucket";
							 request.directory = @"Directory";
							 [request setFinishBlock:^(NSDictionary* result, NSError* error) {
									//删除完成回调
							 }];
							 [[QCloudCOSV4Service defaultCOSV4] DeleteDirectory:request];

```
#### QCloudDeleteDirectoryRequest参数说明
|名称|类型|是否必填|作用|    
|-------|-------|------------|-------|    
|bucket|NSString*|是|COS上面的存储桶名|
|directory|NSString*|否|在COS存储桶下的目录|
