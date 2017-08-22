## 开发准备

### SDK 获取

对象存储服务的 iOS SDK 的下载地址：[iOS SDK](https://github.com/tencentyun/cos_xml_iOS_sdk.git)

更多示例可参考Demo：[iOS Demo](https://github.com/tencentyun/cos_xml_iOS_sdk.git)
（本版本SDK基于XML API封装组成）

### 开发准备

-  iOS 8.0+；
-  手机必须要有网络（GPRS、3G或Wifi网络等）；


### SDK 配置

#### SDK 导入
您可以通过cocoapods或者下载打包好的动态库的方式来集成SDK。在这里我们推荐您使用cocoapods的方式来进行导入。
##### 使用Cocoapods导入(推荐)

在Podfile文件中使用：

~~~
pod "QCloudCOSXML"
~~~

##### 使用打包好的动态库导入

将**QCloudCOSXML.framework和QCloudCore.framework**拖入到工程中即可：

![](http://ericcheungtest-1251668577.cosgz.myqcloud.com/framework%E6%88%AA%E5%9B%BE.png)




并添加以下依赖库：

1. CoreTelephony
2. Foundation
3. SystemConfiguration
4. libstdc++.tbd

#### 工程配置

在 Build Settings 中设置 Other Linker Flags，加入参数 -ObjC。

![参数配置](https://mccdn.qcloud.com/static/img/58327ba5d83809c77da158ff95627ef7/image.png)

在工程info.plist文件中添加App Transport Security Settings 类型，然后在App Transport Security Settings下添加Allow Arbitrary Loads 类型Boolean,值设为YES。



### 初始化

在使用SDK的功能之前，我们需要导入一些必要的头文件和进行一些初始化工作。

引入上传 SDK 的头文件 *QCloudCore/QCloudCore.h,     
 QCloudCore/QCloudCredential.h,      
 QCloudCore/QCloudAuthentationCreator.h,      
 QCloudCore/QCloudServiceConfiguration_Private.h,    
 QCloudCOSXML/QCloudCOSXML.h*，    
 使用 SDK 操作时，需要先实例化 *QCloudCOSXMLService* 和 *QCloudCOSTransferManagerService* 对象。实例化这两个对象之前我们要实例化一个云服务配置对象*QCloudServiceConfiguration*。

#### 方法原型
```
 QCloudServiceConfiguration* configuration = [QCloudServiceConfiguration new];
 configuration.appID = @""//项目ID;
 configuration.regionType = QCloudRegionCNNorth;
```

```
+ (QCloudCOSXMLService*) registerDefaultCOSXMLWithConfiguration:(QCloudServiceConfiguration*)configuration;
```

```
+ (QCloudCOSTransferMangerService*) registerDefaultCOSTransferMangerWithConfiguration:(QCloudServiceConfiguration*)configuration;
```

#### 参数说明

| 参数名称   | 类型         | 是否必填 | 说明                                       |
| ------ | ---------- | ---- | ---------------------------------------- |
| appID  | NSString * | 是    | 项目ID，即APP ID。                            |
| regionType | QCloudRegionType | 是    | bucket被创建的时候机房区域，比如华南园区：QCloudRegionCNSouth，华北园区：QCloudRegionCNNorth |

#### 示例

```objective-c
//AppDelegate.m

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 QCloudServiceConfiguration* configuration = [QCloudServiceConfiguration new];
    configuration.appID = @"1234567";
    configuration.signatureProvider = self;
    configuration.regionType = QCloudRegionCNNorth;
    configuration.endPoint = [[QCloudEndPoint alloc] initWithRegionType:currentRegion serviceType:QCloudServiceCOSXML useSSL:NO];
    [QCloudCOSXMLService registerDefaultCOSXMLWithConfiguration:configuration];
    [QCloudCOSTransferMangerService registerDefaultCOSTransferMangerWithConfiguration:configuration];
    return YES
}

```

## 快速入门

这里演示的上传和下载的基本流程，更多细节可以参考demo；在进行这一步之前必须在腾讯云控制台上申请COS业务的appid；

### STEP - 1 初始化

#### 示例

```objective-c
//AppDelegate.m
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

QCloudServiceConfiguration* configuration = [QCloudServiceConfiguration new];
configuration.appID = @"1234567";
configuration.signatureProvider = self;
configuration.regionType = QCloudRegionCNNorth;
configuration.endPoint = [[QCloudEndPoint alloc] initWithRegionType:currentRegion serviceType:QCloudServiceCOSXML useSSL:NO];
[QCloudCOSXMLService registerDefaultCOSXMLWithConfiguration:configuration];
[QCloudCOSTransferMangerService registerDefaultCOSTransferMangerWithConfiguration:configuration];
}
```

需要注意的是QCloudServiceConfiguration的signatureProvider对象需要实现QCloudSignatureProvider协议。 
####示例
```objective-c
//AppDelegate.m
- (void) signatureWithFields:(QCloudSignatureFields*)fileds
                     request:(QCloudBizHTTPRequest*)request
                  urlRequest:(NSURLRequest*)urlRequst
                   compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock
{
    QCloudCredential* credential = [QCloudCredential new];
    credential.secretID = @"您的SecretID";
    credential.secretKey = @"您的SecretKey";
    QCloudAuthentationCreator* creator = [[QCloudAuthentationCreator alloc] initWithCredential:credential];
    QCloudSignature* signature =  [creator signatureForCOSXMLRequest:request];
    continueBlock(signature, nil);
}

```

### STEP - 2 上传文件

在这里我们假设您已经申请了自己业务bucket。事实上，SDK所有的请求对应了相应的Request类，只要生成相应的请求，设置好相应的属性，然后将请求交给QCloudCOSXMLService对象，就可以完成相应的动作。其中，request的body部分传入需要上传的文件在本地的URL（NSURL* 类型）。    
        
上传文件的接口需要用到签名来进行身份认证，我们的请求会自动向初始化时指定的遵循QCloudSignatureProvider协议的对象去请求签名。签名如何生成可以参考下一章节中的生成签名。
    
需要留意的是，URL所对应的文件在上传过程中是不能进行变更的，否则会导致出错。


#### 示例

```objective-c
  QCloudCOSXMLUploadObjectRequest* put = [QCloudCOSXMLUploadObjectRequest new];
    
    NSURL* url = /*文件的URL*/;
    put.object = @"文件名.jpg";
    put.bucket = /*bucket名*/;
    put.body =  url;
    [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    }];
    [put setFinishBlock:^(id outputObject, NSError *error) {
 
    }];
    [[QCloudCOSTransferMangerService defaultCOSTRANSFERMANGER] UploadObject:put];

```

####QCloudCOSXMLUploadObjectRequest参数含义    
| 参数名称   | 类型         | 是否必填 | 说明                                       |
| ------ | ---------- | ---- | ---------------------------------------- |
| Object  | NSString * | 是    | 上传文件（对象）的文件名，也是对象的key          |
|bucket|NSString * |是|上传的存储桶的名称|
|body|BodyType|是|需要上传的文件的路径。填入NSURL * 类型变量|
| storageClass | QCloudCOSStorageClass | 是    |  对象的存储级别 |
|cacheControl|NSString * |否|RFC 2616中定义的缓存策略|
|contentDisposition|NSString *|否|RFC 2616中定义的文件名称|
|expect|NSString * | 否 |当使用expect=@"100-Continue"时，在收到服务端确认后才会发送请求内容|
|expires| NSString * |否 | RFC 2616中定义的过期时间|
|accessControlList|NSString * |否| 定义 Object 的 ACL 属性。有效值：private，public-read-write，public-read；默认值：private|
|grantRead|NSString * |否|赋予被授权者读的权限。格式： id=" ",id=" "；当需要给子账户授权时，id="qcs::cam::uin/\<OwnerUin>:uin/\<SubUin>"，当需要给根账户授权时，id="qcs::cam::uin/\<OwnerUin>:uin/\<OwnerUin>"  其中OwnerUin指的是根账户的ID，而SubUin指的是子账户的ID|
|grantWrite|NSString * |否| 授予被授权者写的权限。格式同上。|
|grantFullControl|NSString * |否| 授予被授权者读写权限。格式同上。|


### STEP - 3 下载文件

#### 示例

```objective-c
  QCloudGetObjectRequest* request = [QCloudGetObjectRequest new];
  //设置下载的路径URL，如果设置了，文件将会被下载到指定路径中
  request.downloadingURL = [NSURL URLWithString:QCloudTempFilePathWithExtension(@"downding")];
  request.object = @“你的Object-Key”;
  request.bucket = @"你的bucket名";
  [request setFinishBlock:^(id outputObject, NSError *error) {
    //additional actions after finishing
}];
	[request setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
	 //下载过程中的进度
	}];
	[[QCloudCOSXMLService defaultCOSXML] GetObject:request];
```

## 生成签名

SDK中的请求需要用到签名，以确访问的用户的身份，也保障了访问的安全性。在SDK中可以生成签名，每个请求会向QCloudServiceConfiguration对象中的signatureProvider对象来请求生成签名。我们可以将负责生成签名的对象在一开始赋值给signatureProvider，该生成签名的对象需要遵循QCloudSignatureProvider协议，并实现生成签名的方法：
<pre objective-c>
- (void) signatureWithFields:(QCloudSignatureFields* )fileds    
                     request:(QCloudBizHTTPRequest* )request    
                  urlRequest:(NSURLRequest* )urlRequst    
                   compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock
</pre>
基于安全性的考虑，我们建议您在服务器端实现签名的过程。您也可以在本地生成签名，请参考例子：

```
- (void) signatureWithFields:(QCloudSignatureFields*)fileds
                     request:(QCloudBizHTTPRequest*)request
                  urlRequest:(NSURLRequest*)urlRequst
                   compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock
{
    QCloudCredential* credential = [QCloudCredential new];
    credential.secretID = @"您的secretID";
    credential.secretKey = @"您的scretKey";
    
    QCloudAuthentationCreator* creator = [[QCloudAuthentationCreator alloc] initWithCredential:credential];
    QCloudSignature* signature =  [creator signatureForCOSXMLRequest:request];
    continueBlock(signature, nil);
}

```



## 存储桶操作

### 列举存储桶内的内容

#### 方法原型

进行存储桶操作之前，我们需要导入头文件QCloudCOSXML/QCloudCOSXML.h。在此之前您需要完成前文中的STEP-1初始化操作。先生成一个QCloudGetBucketRequest实例，然后填入一些需要的额外的限制条件，通过并获得内容。具体步骤如下：    
1.实例化QCloudGetBucketRequest，填入需要的参数。    
2.调用QCloudCOSXMLService对象中的GetBucket方法发出请求。    
3.从回调的finishBlock中的QCloudListBucketResult获取具体内容。    
#### QCloudGetBucketRequest参数说明

| 参数名称   | 类型         | 是否必填 | 说明                                 |
| ------ | ---------- | ---- | ---------------------------------- |
| bucket  | NSString * | 是    | 存储桶名                      |
| region | NSString * | 否    |前缀匹配，用来规定返回的文件前缀地址 |
|delimiter|NSString *|否|定界符为一个符号，如果有 Prefix，则将 Prefix 到 delimiter 之间的相同路径归为一类，定义为 Common Prefix，然后列出所有 Common Prefix。如果没有 Prefix，则从路径起点开始|
|encodingType|NSString * |否|规定返回值的编码方式，可选值:url|
marker| NSString * | 否 | 默认以UTF-8二进制顺序列出条目，所有列出条目从marker开始|
|maxKeys|int | 否 |单次返回的最大条目数量，默认1000|

#### 示例

```objective-c
    QCloudGetBucketRequest* request = [QCloudGetBucketRequest new];
    request.bucket = @“testBucket”;
    request.maxKeys = 1000;
    [request setFinishBlock:^(QCloudListBucketResult * _Nonnull result, NSError * _Nonnull error) {
    //additional actions after finishing
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetBucket:request];
```

### 获取存储桶的ACL（Access Control List）

####方法原型
进行存储桶操作之前，我们需要导入头文件QCloudCOSXML/QCloudCOSXML.h。在此之前您需要完成前文中的STEP-1初始化操作。先生成一个QCloudGetBucketACLRequest实例，然后填入一些需要的额外的限制条件，通过并获得内容。具体步骤如下：    
1.实例化QCloudGetBucketACLRequest，填入获取ACL的bucket。    
2.调用QCloudCOSXMLService对象中的GetBucketACL方法发出请求。    
3.从回调的finishBlock中的QCloudACLPolicy获取具体内容。    


####QCloudGetBucketACLRequest参数说明
| 参数名称   | 类型         | 是否必填 | 说明                                 |
| ------ | ---------- | ---- | ---------------------------------- |
| bucket  | NSString * | 是    | 存储桶名                      |

####返回结果QCloudACLPolicy参数说明

| 参数名称   | 类型         |   说明                                 |
| ------ | ---------- |  ---------------------------------- |
| owner  | QCloudACLOwner * | 存储桶持有者的信息                 |
|accessControlList|NSArray * |被授权者与权限的信息|
####示例

```objective-c
  QCloudGetBucketACLRequest* getBucketACl   = [QCloudGetBucketACLRequest new];
    getBucketACl.bucket = self.bucket;
    [getBucketACl setFinishBlock:^(QCloudACLPolicy * _Nonnull result, NSError * _Nonnull error) {
        //QCloudACLPolicy中包含了bucket的ACL信息。
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] GetBucketACL:getBucketACl];

```




###设置存储桶的ACL(Access Control List)

####方法原型
进行存储桶操作之前，我们需要导入头文件QCloudCOSXML/QCloudCOSXML.h。在此之前您需要完成前文中的STEP-1初始化操作。先生成一个QCloudPutBucketACLRequest实例，然后填入一些需要的额外的限制条件，通过并获得内容。具体步骤如下：    
1.实例化QCloudPutBucketACLRequest，填入需要设置的bucket，然后根据设置值的权限类型分别填入不同的参数。    
2.调用QCloudCOSXMLService对象中的PutBucketACL方法发出请求。    
3.从回调的finishBlock中的获取设置是否成功，并做设置成功后的一些额外动作。   

#### QCloudPutBucketACLRequest参数说明
| 参数名称   | 类型         | 是否必填 | 说明                                 |
| ------ | ---------- | ---- | ---------------------------------- |
| bucket  | NSString * | 是    | 存储桶名                      |
|accessControlList|NSString * |否| 定义 Object 的 ACL 属性。有效值：private，public-read-write，public-read；默认值：private|
|grantRead|NSString * |否|赋予被授权者读的权限。格式： id=" ",id=" "；当需要给子账户授权时，id="qcs::cam::uin/\<OwnerUin>:uin/\<SubUin>"，当需要给根账户授权时，id="qcs::cam::uin/\<OwnerUin>:uin/\<OwnerUin>"  其中OwnerUin指的是根账户的ID，而SubUin指的是子账户的ID|
|grantWrite|NSString * |否| 授予被授权者写的权限。格式同上。|
|grantFullControl|NSString * |否| 授予被授权者读写权限。格式同上。|



####示例
```objective-c
    QCloudPutBucketACLRequest* putACL = [QCloudPutBucketACLRequest new];
    NSString* appID = @“您的APP ID”;
    NSString *ownerIdentifier = [NSString stringWithFormat:@"qcs::cam::uin/%@:uin/%@", appID, appID];
    NSString *grantString = [NSString stringWithFormat:@"id=\"%@\"",ownerIdentifier];
    putACL.grantFullControl = grantString;
    putACL.bucket = @“您要操作的bucket名”;
    [putACL setFinishBlock:^(id outputObject, NSError *error) {
    //error occucs if error != nil
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketACL:putACL];

```


###获取存储桶的CORS(跨域访问)设置

####方法原型
进行存储桶操作之前，我们需要导入头文件QCloudCOSXML/QCloudCOSXML.h。在此之前您需要完成前文中的STEP-1初始化操作。先生成一个QCloudPutBucketCORSRequest实例，然后填入一些需要的额外的限制条件，通过并获得内容。具体步骤如下：    
1.实例化QCloudPutBucketCORSRequest，填入需要获取CORS的bucket。    
2.调用QCloudCOSXMLService对象中的GetBucketCORS方法发出请求。    
3.从回调的finishBlock中获取结果。结果封装在了QCloudCORSConfiguration对象中，该对象的rules属性是一个数组，数组里存放着一组QCloudCORSRule，具体的CORS设置就封装在QCloudCORSRule对象里。   

#### QCloudPutBucketCORSRequest参数说明

| 参数名称   | 类型         | 是否必填 | 说明                                 |
| ------ | ---------- | ---- | ---------------------------------- |
| bucket  | NSString * | 是    | 存储桶名                      |


#### 返回结果QCloudCORSConfiguration参数说明
| 参数名称   | 类型         | 说明                                 |
| ------ | ---------- | ---------------------------------- |
| rules  | NSArray<QCloudCORSRule*> *  | 放置CORS的数组, 数组内容为QCloudCORSRule实例      |

####QCloudCORSRule参数说明

| 参数名称   | 类型         | 说明                                 |
| ------ | ---------- | ---------------------------------- |
| identifier  | NSString *   | 配置规则的ID                 |
|allowedMethod|NSArray<NSString*> * |允许的 HTTP 操作，枚举值：GET，PUT，HEAD，POST，DELETE|
|allowedOrigin|NSString * | 允许的访问来源，支持通配符 * , 格式为：协议://域名[:端口]如：http://www.qq.com |
|allowedHeader|NSArray<NSString * > * | 在发送 OPTIONS 请求时告知服务端，接下来的请求可以使用哪些自定义的 HTTP 请求头部，支持通配符 * |
|maxAgeSeconds|int|设置 OPTIONS 请求得到结果的有效期|
|exposeHeader|NSString * |设置浏览器可以接收到的来自服务器端的自定义头部信息|    




####示例
```objective-c
	QCloudGetBucketCORSRequest* corsReqeust = [QCloudGetBucketCORSRequest new];
	corsReqeust.bucket = self.bucket;
	    
	[corsReqeust setFinishBlock:^(QCloudCORSConfiguration * _Nonnull result, NSError * _Nonnull error) {
	    //CORS设置封装在result中。
	  
  	}];
	    
	[[QCloudCOSXMLService defaultCOSXML] GetBucketCORS:corsReqeust];

```    




###设置存储桶的CORS（跨域访问）

####方法原型
进行存储桶操作之前，我们需要导入头文件QCloudCOSXML/QCloudCOSXML.h。在此之前您需要完成前文中的STEP-1初始化操作。先生成一个QCloudPutBucketCORSRequest实例，然后填入一些需要的额外的限制条件，通过并获得内容。具体步骤如下：    
1.实例化QCloudPutBucketCORSRequest，设置bucket，并且将需要的CORS装入QCloudCORSRule中，如果有多组CORS设置，可以将多个QCloudCORSRule放在一个NSArray里，然后将该数组填入QCloudCORSConfiguration的rules属性里，放在request中。    
2.调用QCloudCOSXMLService对象中的PutBucketCORS方法发出请求。    
3.从回调的finishBlock中的获取设置成功与否（error是否为空），并且做一些设置后的额外动作。   

#### QCloudPutBucketCORSRequest参数说明
| 参数名称   | 类型         | 是否必填 | 说明                                 |
| ------ | ---------- | ---- | ---------------------------------- |
| bucket  | NSString * | 是    | 存储桶名                      |
|corsConfiguration|QCloudCORSConfiguration * |是|封装了CORS的具体参数|


####QCloudCORSConfiguration参数说明 

| 参数名称   | 类型         | 说明                                 |
| ------ | ---------- | ---------------------------------- |
| rules  | NSArray<QCloudCORSRule*> *  | 放置CORS的数组, 数组内容为QCloudCORSRule实例      |

####QCloudCORSRule参数说明

| 参数名称   | 类型         | 说明                                 |
| ------ | ---------- | ---------------------------------- |
| identifier  | NSString *   | 配置规则的ID                 |
|allowedMethod|NSArray<NSString*> * |允许的 HTTP 操作，枚举值：GET，PUT，HEAD，POST，DELETE|
|allowedOrigin|NSString * | 允许的访问来源，支持通配符 * , 格式为：协议://域名[:端口]如：http://www.qq.com |
|allowedHeader|NSArray<NSString * > * | 在发送 OPTIONS 请求时告知服务端，接下来的请求可以使用哪些自定义的 HTTP 请求头部，支持通配符 * |
|maxAgeSeconds|int|设置 OPTIONS 请求得到结果的有效期|
|exposeHeader|NSString * |设置浏览器可以接收到的来自服务器端的自定义头部信息|    



####示例

```objective-c
    QCloudPutBucketCORSRequest* putCORS = [QCloudPutBucketCORSRequest new];
    QCloudCORSConfiguration* cors = [QCloudCORSConfiguration new];
    
    QCloudCORSRule* rule = [QCloudCORSRule new];
    rule.identifier = @"sdk";
    rule.allowedHeader = @[@"origin",@"host",@"accept",@"content-type",@"authorization"];
    rule.exposeHeader = @"ETag";
    rule.allowedMethod = @[@"GET",@"PUT",@"POST", @"DELETE", @"HEAD"];
    rule.maxAgeSeconds = 3600;
    rule.allowedOrigin = @"*";
    
    cors.rules = @[rule];
    
    putCORS.corsConfiguration = cors;
    putCORS.bucket = @"您要设置的bucket";
    [putCORS setFinishBlock:^(id outputObject, NSError *error) {
        if (!error) {
        //success
        }
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketCORS:putCORS];
	


```    






###获取存储桶的地域信息

####方法原型
进行存储桶操作之前，我们需要导入头文件QCloudCOSXML/QCloudCOSXML.h。在此之前您需要完成前文中的STEP-1初始化操作。先生成一个QCloudGetBucketLocationRequest实例，然后填入一些需要的额外的限制条件，通过并获得内容。具体步骤如下：    
1.实例化QCloudGetBucketLocationRequest，填入bucket名。    
2.调用QCloudCOSXMLService对象中的GetBucketLocation方法发出请求。    
3.从回调的finishBlock中的获取具体内容。   

#### QCloudGetBucketLocationRequest参数说明

| 参数名称   | 类型         | 是否必填 | 说明                                 |
| ------ | ---------- | ---- | ---------------------------------- |
| bucket  | NSString * | 是    | 存储桶名                      |


####返回结果QCloudBucketLocationConstraint参数说明
| 参数名称   | 类型        | 说明                                 |
| ------ | ---------- |  ---------------------------------- |
| locationConstraint  |NSString* |说明 Bucket 所在区域，枚举值：cn-north，cn-east，sg，cn-southwest，cn-south|



####示例
```objective-c

  QCloudGetBucketLocationRequest* locationReq = [QCloudGetBucketLocationRequest new];
    locationReq.bucket = @"您的bucket名";
    __block QCloudBucketLocationConstraint* location;
    [locationReq setFinishBlock:^(QCloudBucketLocationConstraint * _Nonnull result, NSError * _Nonnull error) {
        location = result;
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetBucketLocation:locationReq];

```


###删除存储桶CORS设置

####方法原型
进行存储桶操作之前，我们需要导入头文件QCloudCOSXML/QCloudCOSXML.h。在此之前您需要完成前文中的STEP-1初始化操作。先生成一个QCloudDeleteBucketCORSRequest实例，然后填入一些需要的额外的限制条件，通过并获得内容。具体步骤如下：    
1.实例化QCloudDeleteBucketCORSRequest，填入需要的参数。    
2.调用QCloudCOSXMLService对象中的方法发出请求。    
3.从回调的finishBlock中的获取具体内容。   

#### QCloudDeleteBucketCORSRequest参数说明
| 参数名称   | 类型         | 是否必填 | 说明                                 |
| ------ | ---------- | ---- | ---------------------------------- |
| bucket  | NSString * | 是    | 存储桶名                      |
####示例
```objective-c
 QCloudDeleteBucketCORSRequest* deleteCORS = [QCloudDeleteBucketCORSRequest new];
    deleteCORS.bucket = self.bucket;
    [deleteCORS setFinishBlock:^(id outputObject, NSError *error) {
        //success if error == nil
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteBucketCORS:deleteCORS];
```

###查询Bucket中正在进行的分块上传

####方法原型
进行存储桶操作之前，我们需要导入头文件QCloudCOSXML/QCloudCOSXML.h。在此之前您需要完成前文中的STEP-1初始化操作。先生成一个QCloudListBucketMultipartUploadsRequest实例，然后填入一些需要的额外的限制条件，通过并获得内容。具体步骤如下：    
1.实例化QCloudListBucketMultipartUploadsRequest，填入需要的参数，如返回结果的前缀、编码方式等。    
2.调用QCloudCOSXMLService对象中的ListBucketMultipartUploads方法发出请求。    
3.从回调的finishBlock中的获取具体内容。   

#### QCloudListBucketMultipartUploadsRequest参数说明
| 参数名称   | 类型         | 是否必填 | 说明                                 |
| ------ | ---------- | ---- | ---------------------------------- |
| bucket  | NSString * | 是    | 存储桶名                      |
| prefix | NSString * | 否    |限定返回的 Object key 必须以 Prefix 作为前缀。
注意使用 prefix 查询时，返回的 key 中仍会包含 Prefix |
|delimiter|NSString *|否|定界符为一个符号，如果有 Prefix，则将 Prefix 到 delimiter 之间的相同路径归为一类，定义为 Common Prefix，然后列出所有 Common Prefix。如果没有 Prefix，则从路径起点开始|
|encodingType|NSString * |否|规定返回值的编码方式，可选值:url|
keyMarker| NSString * | 否 |列出条目从该 key 值开始	|
|uploadIDMarker|int | 否 |列出条目从该 UploadId 值开始|
|maxUploads|int|否|设置最大返回的multipart数量，合法值1到1000|

####返回结果QCloudListMultipartUploadsResult参数说明

| 参数名称   | 类型         | 是否必填 | 说明                                 |
| ------ | ---------- | ---- | ---------------------------------- |
| bucket  | NSString * | 是    | 存储桶名                      |
| prefix | NSString * | 否    |限定返回的 Object key 必须以 Prefix 作为前缀。注意使用 prefix 查询时，返回的 key 中仍会包含 Prefix |
|delimiter|NSString *|否|定界符为一个符号，如果有 Prefix，则将 Prefix 到 delimiter 之间的相同路径归为一类，定义为 Common Prefix，然后列出所有 Common Prefix。如果没有 Prefix，则从路径起点开始|
|encodingType|NSString * |否|规定返回值的编码方式，可选值:url|
keyMarker| NSString * | 否 |列出条目从该 key 值开始	|
|maxUploads|int|否|设置最大返回的multipart数量，合法值1到1000|



####示例
```objecitve-c
 QCloudListBucketMultipartUploadsRequest* uploads = [QCloudListBucketMultipartUploadsRequest new];
    uploads.bucket = self.bucket;
    uploads.maxUploads = 1000;
    __block NSError* resulError;
    __block QCloudListMultipartUploadsResult* multiPartUploadsResult;
    [uploads setFinishBlock:^(QCloudListMultipartUploadsResult* result, NSError *error) {
        multiPartUploadsResult = result;
        localError = error;
    }];
    [[QCloudCOSXMLService defaultCOSXML] ListBucketMultipartUploads:uploads];

```










##文件操作
在COS中，每个文件就是一个Object(对象)。对文件的操作，其实也就是对对象的操作。

###查询对象的ACL（Access Control List）

####方法原型
进行文件操作之前，我们需要导入头文件QCloudCOSXML/QCloudCOSXML.h。在此之前您需要完成前文中的STEP-1初始化操作。先生成一个QCloudGetObjectACLRequest实例，然后填入一些需要的额外的限制条件，通过并获得内容。具体步骤如下：    
1.实例化QCloudGetObjectACLRequest，填入存储桶的名称，和需要查询对象的名称。    
2.调用QCloudCOSXMLService对象中的GetObjectACL方法发出请求。    
3.从回调的finishBlock中的获取的QCloudACLPolicy对象中获取封装好的ACL的具体信息。   

#### QCloudGetObjectACLRequest参数说明

| 参数名称   | 类型         | 是否必填 | 说明                                 |
| ------ | ---------- | ---- | ---------------------------------- |
| bucket  | NSString * | 是    | 存储桶名                      |
|object|NSString * |是| 对象名 |

####示例

```objective-c
 request.bucket = self.aclBucket;
    request.object = @"对象的名称";
    request.bucket = @"对象所在bucket"
    __block QCloudACLPolicy* policy;
    [request setFinishBlock:^(QCloudACLPolicy * _Nonnull result, NSError * _Nonnull error) {
        policy = result;
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetObjectACL:request];


```


###设置对象的ACL（Access Control List）

####方法原型
进行对象操作之前，我们需要导入头文件QCloudCOSXML/QCloudCOSXML.h。在此之前您需要完成前文中的STEP-1初始化操作。先生成一个QCloudPutObjectACLRequest实例，然后填入一些需要的额外的限制条件，通过并获得内容。具体步骤如下：    
1.实例化QCloudPutObjectACLRequest，填入bucket名，和一些额外需要的参数，如授权的具体信息等。    
2.调用QCloudCOSXMLService对象中的方法发出请求。    
3.从回调的finishBlock中获取设置的完成情况，若error为空，则设置成功。   

#### QCloudPutObjectACLRequest参数说明


| 参数名称   | 类型         | 是否必填 | 说明                                 |
| ------ | ---------- | ---- | ---------------------------------- |
| bucket  | NSString * | 是    | 存储桶名                      |
|object|NSString * |是|对象名|
|accessControlList|NSString * |否| 定义 Object 的 ACL 属性。有效值：private，public-read-write，public-read；默认值：private|
|grantRead|NSString * |否|赋予被授权者读的权限。格式： id=" ",id=" "；当需要给子账户授权时，id="qcs::cam::uin/\<OwnerUin>:uin/\<SubUin>"，当需要给根账户授权时，id="qcs::cam::uin/\<OwnerUin>:uin/\<OwnerUin>"  其中OwnerUin指的是根账户的ID，而SubUin指的是子账户的ID|
|grantWrite|NSString * |否| 授予被授权者写的权限。格式同上。|
|grantFullControl|NSString * |否| 授予被授权者读写权限。格式同上。|
####示例
```objective-c
    QCloudPutObjectACLRequest* request = [QCloudPutObjectACLRequest new];
    request.object = @"需要设置ACL的对象名";
    request.bucket = @"对象所在存储桶名";
    NSString *ownerIdentifier = [NSString stringWithFormat:@"qcs::cam::uin/%@:uin/%@",self.appID, self.appID];
    NSString *grantString = [NSString stringWithFormat:@"id=\"%@\"",ownerIdentifier];
    request.grantFullControl = grantString;
    __block NSError* localError;
    [request setFinishBlock:^(id outputObject, NSError *error) {
        localError = error;
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] PutObjectACL:request];
```


###下载文件

####方法原型
进行文件操作之前，我们需要导入头文件QCloudCOSXML/QCloudCOSXML.h。在此之前您需要完成前文中的STEP-1初始化操作。先生成一个实例，然后填入一些需要的额外的限制条件，通过并获得内容。具体步骤如下：    
1.实例化，填入需要的参数。    
2.调用QCloudCOSXMLService对象中的方法发出请求。    
3.从回调的finishBlock中的获取具体内容。   

#### 参数说明

| 参数名称   | 类型         | 是否必填 | 说明                                 |
| ------ | ---------- | ---------- | ---------------------------------- |
| bucket  | NSString * | 是 | 存储桶名                      |
|object|NSString * |是|对象名|
|range|NSString * |否|RFC 2616 中定义的指定文件下载范围，以字节（bytes）为单位|
|ifModifiedSince|NSString * |否|如果文件修改时间晚于指定时间，才返回文件内容。否则返回 412 (not modified)|
|responseContentType|NSString * |否|设置响应头部中的 Content-Type参数|
|responseContentLanguage|NSString * |否|设置响应头部中的Content-Language参数|
|responseContentExpires|NSString * |否|设置响应头部中的Content-Expires参数|
|responseCacheControl|NSString * |否|设置响应头部中的Cache-Control参数|
|responseContentDisposition|NSString * |否|设置响应头部中的 Content-Disposition 参数。|
|responseContentEncoding|NSString * |否|设置响应头部中的 Content-Encoding 参数|

####示例

```objective-c
  QCloudGetObjectRequest* request = [QCloudGetObjectRequest new];
  //设置下载的路径URL，如果设置了，文件将会被下载到指定路径中
  request.downloadingURL = [NSURL URLWithString:QCloudTempFilePathWithExtension(@"downding")];
  request.object = @“你的Object-Key”;
  request.bucket = @"你的bucket名";
  [request setFinishBlock:^(id outputObject, NSError *error) {
    //additional actions after finishing
}];
	[request setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
	 //下载过程中的进度
	}];
	[[QCloudCOSXMLService defaultCOSXML] GetObject:request];
```



### Object 跨域访问配置的预请求

####方法原型
进行文件操作之前，我们需要导入头文件QCloudCOSXML/QCloudCOSXML.h。在此之前您需要完成前文中的STEP-1初始化操作。先生成一个QCloudOptionsObjectRequest实例，然后填入一些需要的额外的限制条件，通过并获得内容。具体步骤如下：    
1.实例化QCloudOptionsObjectRequest，填入需要设置的对象名、存储桶名、模拟跨域访问请求的http方法和模拟跨域访问允许的访问来源    
2.调用QCloudCOSXMLService对象中的方法发出请求。    
3.从回调的finishBlock中的获取具体内容。   

#### QCloudOptionsObjectRequest参数说明


| 参数名称   | 类型   |是否必填      | 说明                                 |
| ------ | ---------- | -------|---------------------------------- |
| object  | NSString *   |是|对象名              |
|bucket|NSString * |是| 存储桶名 |
|accessControlRequestMethod|NSArray<NSString*> * |是|模拟跨域访问的请求HTTP方法|
|origin|NSString * | 是|模拟跨域访问允许的访问来源，支持通配符 * , 格式为：协议://域名[:端口]如：http://www.qq.com |
|allowedHeader|NSArray<NSString * > * | 否|在发送 OPTIONS 请求时告知服务端，接下来的请求可以使用哪些自定义的 HTTP 请求头部，支持通配符 * |
####示例
```objective-c

 QCloudOptionsObjectRequest* request = [[QCloudOptionsObjectRequest alloc] init];
    request.bucket =@"存储桶名";
    request.origin = @"*";
    request.accessControlRequestMethod = @"get";
    request.accessControlRequestHeaders = @"host";
    request.object = @"对象名";
    __block id resultError;
    [request setFinishBlock:^(id outputObject, NSError* error) {
        resultError = error;
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] OptionsObject:request];
    


```


###删除单个对象

####方法原型
进行文件操作之前，我们需要导入头文件QCloudCOSXML/QCloudCOSXML.h。在此之前您需要完成前文中的STEP-1初始化操作。先生成一个QCloudDeleteObjectRequest实例，然后填入一些需要的额外的限制条件，通过并获得内容。具体步骤如下：    
1.实例化QCloudDeleteObjectRequest，填入需要的参数。    
2.调用QCloudCOSXMLService对象中的方法发出请求。    
3.从回调的finishBlock中的获取具体内容。   

#### QCloudDeleteObjectRequest参数说明
| 参数名称   | 类型   |是否必填      | 说明                                 |
| ------ | ---------- | -------|---------------------------------- |
| object  | NSString *   |是|对象名              |
|bucket|NSString * |是| 存储桶名 |
####示例

```objective-c

QCloudDeleteObjectRequest* deleteObjectRequest = [QCloudDeleteObjectRequest new];
    deleteObjectRequest.bucket = @"存储桶名";
    deleteObjectRequest.object = @"对象名";
        
    __block NSError* resultError;
    [deleteObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
        resultError = error;
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteObject:deleteObjectRequest];

```

###删除多个对象

####方法原型
进行文件操作之前，我们需要导入头文件QCloudCOSXML/QCloudCOSXML.h。在此之前您需要完成前文中的STEP-1初始化操作。先生成一个QCloudDeleteMultipleObjectRequest实例，然后填入一些需要的额外的限制条件，通过并获得内容。具体步骤如下：    
1.实例化QCloudDeleteMultipleObjectRequest，填入需要的参数。    
2.调用QCloudCOSXMLService对象中的方法发出请求。    
3.从回调的finishBlock中的获取具体内容。   

#### QCloudDeleteMultipleObjectRequest参数说明

| 参数名称   | 类型   |是否必填      | 说明                                 |
| ------ | ---------- | -------|---------------------------------- |
| object  | NSString *   |是|对象名              |
|deleteObjects|QCloudDeleteInfo * |是| 封装了需要批量删除的多个对象的信息|



#### QCloudDeleteInfo参数说明
| 参数名称   | 类型   |是否必填      | 说明                                 |
| ------ | ---------- | -------|---------------------------------- |
| objects  |  NSArray<QCloudDeleteObjectInfo * > *   |是|存放需要删除对象信息的数组  |


####QCloudDeleteObjectInfo参数说明
| 参数名称   | 类型   |是否必填      | 说明                                 |
| ------ | ---------- | -------|---------------------------------- |
| key  | NSString *   |是|对象名              |


####示例
```objective-c

QCloudDeleteMultipleObjectRequest* delteRequest = [QCloudDeleteMultipleObjectRequest new];
    delteRequest.bucket = self.aclBucket;
    
    QCloudDeleteObjectInfo* deletedObject0 = [QCloudDeleteObjectInfo new];
    deletedObject0.key = @"第一个对象名";
    
    QCloudDeleteObjectInfo* deleteObject1 = [QCloudDeleteObjectInfo new];
    deleteObject1.key = @"第二个对象名";
    
    QCloudDeleteInfo* deleteInfo = [QCloudDeleteInfo new];
    deleteInfo.quiet = NO;
    deleteInfo.objects = @[ deletedObject0,deleteObject2];
    
    delteRequest.deleteObjects = deleteInfo;
    
    __block NSError* resultError;
    [delteRequest setFinishBlock:^(QCloudDeleteResult* outputObject, NSError *error) {
        localError = error;
        deleteResult = outputObject;
    }];
    
    
    [[QCloudCOSXMLService defaultCOSXML] DeleteMultipleObject:delteRequest];
    

```


###初始化分片上传

####方法原型
进行文件操作之前，我们需要导入头文件QCloudCOSXML/QCloudCOSXML.h。在此之前您需要完成前文中的STEP-1初始化操作。先生成一个QCloudInitiateMultipartUploadRequest实例，然后填入一些需要的额外的限制条件，通过并获得内容。具体步骤如下：    
1.实例化QCloudInitiateMultipartUploadRequest，填入需要的参数。    
2.调用QCloudCOSXMLService对象中的InitiateMultipartUpload方法发出请求。    
3.从回调的finishBlock中的获取具体内容。   

#### 参数说明

| 参数名称   | 类型         | 是否必填 | 说明                                       |
| ------ | ---------- | ---- | ---------------------------------------- |
| Object  | NSString * | 是    | 上传文件（对象）的文件名，也是对象的key          |
|bucket|NSString * |是|上传的存储桶的名称|
|body|BodyType|是|需要上传的文件的路径。填入NSURL * 类型变量|
| storageClass | QCloudCOSStorageClass | 是    |  对象的存储级别 |
|cacheControl|NSString * |否|RFC 2616中定义的缓存策略|
|contentDisposition|NSString *|否|RFC 2616中定义的文件名称|
|expect|NSString * | 否 |当使用expect=@"100-continue"时，在收到服务端确认后才会发送请求内容|
|expires| NSString * |否 | RFC 2616中定义的过期时间|
|storageClass|QCloudCOSStorageClass|否|对象的存储级别|
|accessControlList|NSString * |否| 定义 Object 的 ACL 属性。有效值：private，public-read-write，public-read；默认值：private|
|grantRead|NSString * |否|赋予被授权者读的权限。格式： id=" ",id=" "；当需要给子账户授权时，id="qcs::cam::uin/\<OwnerUin>:uin/\<SubUin>"，当需要给根账户授权时，id="qcs::cam::uin/\<OwnerUin>:uin/\<OwnerUin>"  其中OwnerUin指的是根账户的ID，而SubUin指的是子账户的ID|
|grantWrite|NSString * |否| 授予被授权者写的权限。格式同上。|
|grantFullControl|NSString * |否| 授予被授权者读写权限。格式同上。|



####示例
```objective-c

QCloudInitiateMultipartUploadRequest* initrequest = [QCloudInitiateMultipartUploadRequest new];
    initrequest.bucket = @"存储桶名";
    initrequest.object = @"object名";
    __block QCloudInitiateMultipartUploadResult* initResult;
    [initrequest setFinishBlock:^(QCloudInitiateMultipartUploadResult* outputObject, NSError *error) {
        initResult = outputObject;
    }];
    [[QCloudCOSXMLService defaultCOSXML] InitiateMultipartUpload:initrequest];
    
```


             
           
###获取对象meta信息

####方法原型
进行文件操作之前，我们需要导入头文件QCloudCOSXML/QCloudCOSXML.h。在此之前您需要完成前文中的STEP-1初始化操作。先生成一个QCloudHeadObjectRequest实例，然后填入一些需要的额外的限制条件，通过并获得内容。具体步骤如下：    
1.实例化QCloudHeadObjectRequest，填入需要的参数。    
2.调用QCloudCOSXMLService对象中的HeadObject方法发出请求。    
3.从回调的finishBlock中的获取具体内容。   

#### QCloudHeadObjectRequest参数说明
| 参数名称   | 类型         | 是否必填 | 说明                                       |
| ------ | ---------- | ---- | ---------------------------------------- |
| Object  | NSString * | 是    | 对象名          |
|bucket|NSString * |是|对象所在存储桶的名称|
|ifModifiedSince|NSString * |是|如果文件修改时间晚于指定时间，才返回文件内容。否则返回 304 (not modified)|
####示例
```objective-c
QCloudHeadObjectRequest* headerRequest = [QCloudHeadObjectRequest new];
    headerRequest.object = @“对象名”;
    headerRequest.bucket = @"bucket名";
    
    __block id resultError;
    [headerRequest setFinishBlock:^(NSDictionary* result, NSError *error) {
        resultError = error;
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] HeadObject:headerRequest];

```


###追加文件
Append Object 接口请求可以将一个 Object（文件）以分块追加的方式上传至指定 Bucket 中。Object 属性为 Appendable 时，才能使用 Append Object 接口上传。
Object 属性可以在 Head Object 操作中查询到，发起 Head Object 请求时，会返回自定义 Header 的『x-cos-object-type』，该 Header 只有两个枚举值：Normal 或者 Appendable。通过 Append Object 操作创建的 Object 类型为 Appendable 文件；通过 Put Object 上传的 Object 是 Normal 文件。
当 Appendable 的 Object 被执行 Put Object 的请求操作以后，原 Object 被覆盖，属性改变为 Normal 。
追加上传的 Object 建议大小 1M-5G。如果 Position 的值和当前 Object 的长度不致，COS 会返回 409 错误。如果 Append 一个 Normal 属性的文件，COS 会返回 409 ObjectNotAppendable。

####方法原型
进行文件操作之前，我们需要导入头文件QCloudCOSXML/QCloudCOSXML.h。在此之前您需要完成前文中的STEP-1初始化操作。先生成一个QCloudAppendObjectRequest实例，然后填入一些需要的额外的限制条件，通过并获得内容。具体步骤如下：    
1.实例化QCloudAppendObjectRequest，填入需要的参数。    
2.调用QCloudCOSXMLService对象中的AppendObject方法发出请求。    
3.从回调的finishBlock中的获取具体内容。   

#### QCloudAppendObjectRequest参数说明
| 参数名称   | 类型         | 是否必填 | 说明                                       |
| ------ | ---------- | ---- | ---------------------------------------- |
| Object  | NSString * | 是    | 上传文件（对象）的文件名，也是对象的key          |
|bucket|NSString * |是|上传的存储桶的名称|
|position|int|是|追加操作的起始点，单位：字节；首次追加 position=0，后续追加 position= 当前 Object 的 content-length|
|body|BodyType|是|需要上传的文件的路径。填入NSURL * 类型变量|
| storageClass | QCloudCOSStorageClass | 是    |  对象的存储级别 |
|cacheControl|NSString * |否|RFC 2616中定义的缓存策略|
|contentDisposition|NSString *|否|RFC 2616中定义的文件名称|
|expect|NSString * | 否 |当使用expect=@"100-continue"时，在收到服务端确认后才会发送请求内容|
|expires| NSString * |否 | RFC 2616中定义的过期时间|
|storageClass|QCloudCOSStorageClass|否|对象的存储级别|
|accessControlList|NSString * |否| 定义 Object 的 ACL 属性。有效值：private，public-read-write，public-read；默认值：private|
|grantRead|NSString * |否|赋予被授权者读的权限。格式： id=" ",id=" "；当需要给子账户授权时，id="qcs::cam::uin/\<OwnerUin>:uin/\<SubUin>"，当需要给根账户授权时，id="qcs::cam::uin/\<OwnerUin>:uin/\<OwnerUin>"  其中OwnerUin指的是根账户的ID，而SubUin指的是子账户的ID|
|grantWrite|NSString * |否| 授予被授权者写的权限。格式同上。|
|grantFullControl|NSString * |否| 授予被授权者读写权限。格式同上。|
####示例

```objective-c 
 QCloudAppendObjectRequest* put = [QCloudAppendObjectRequest new];
    put.object = [NSUUID UUID].UUIDString;
    put.bucket = @“bucket名”;
    put.body =  文件的URL，NSURL*类型
    __block NSDictionary* result = nil;
    [put setFinishBlock:^(id outputObject, NSError *error) {
        result = outputObject;
    }];
    [[QCloudCOSXMLService defaultCOSXML] AppendObject:put];

```



