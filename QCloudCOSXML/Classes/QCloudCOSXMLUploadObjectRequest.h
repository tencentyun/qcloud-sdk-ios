//
//  QCloudCOSXMLUploadObjectRequest.h
//  Pods
//
//  Created by Dong Zhao on 2017/5/23.
//
//

#import <QCloudCore/QCloudCore.h>
#import "QCloudCOSStorageClassEnum.h"


FOUNDATION_EXTERN NSString* const QCloudUploadResumeDataKey;

typedef NSData* QCloudCOSXMLUploadObjectResumeData;
@class QCloudUploadObjectResult;
@interface QCloudCOSXMLUploadObjectRequest<BodyType> : QCloudAbstractRequest

/**
 上传文件（对象）的文件名，也是对象的key
 */
@property (strong, nonatomic) NSString *object;


/**
 存储桶名称
 */
@property (strong, nonatomic) NSString *bucket;


/**
 需要上传的文件的路径。填入NSURL*类型变量
 */
@property (strong, nonatomic) BodyType body;


/**
 RFC 2616 中定义的缓存策略，将作为 Object 元数据保存
 */
@property (strong, nonatomic) NSString *cacheControl;

/**
 RFC 2616 中定义的文件名称，将作为 Object 元数据保存
 */
@property (strong, nonatomic) NSString *contentDisposition;

/**
 当使用 Expect: 100-continue 时，在收到服务端确认后，才会发送请求内容
 */
@property (strong, nonatomic) NSString *expect;

/**
 RFC 2616 中定义的过期时间，将作为 Object 元数据保存
 */
@property (strong, nonatomic) NSString *expires;

@property (strong, nonatomic) NSString *contentSHA1;

/**
 对象的存储级别
 */
@property (assign, nonatomic) QCloudCOSStorageClass storageClass;


/**
 定义 Object 的 ACL(Access Control List) 属性。有效值：private，public-read-write，public-read；默认值：private
 */
@property (strong, nonatomic) NSString *accessControlList;


/**
 赋予被授权者读的权限。格式：id=" ",id=" "；
 当需要给子账户授权时，id="qcs::cam::uin/<OwnerUin>:uin/<SubUin>"，
 当需要给根账户授权时，id="qcs::cam::uin/<OwnerUin>:uin/<OwnerUin>"
 */
@property (strong, nonatomic) NSString *grantRead;


/**
 赋予被授权者写的权限。格式：id=" ",id=" "；
 当需要给子账户授权时，id="qcs::cam::uin/<OwnerUin>:uin/<SubUin>"，
 当需要给根账户授权时，id="qcs::cam::uin/<OwnerUin>:uin/<OwnerUin>"
 */
@property (strong, nonatomic) NSString *grantWrite;


/**
 赋予被授权者读写权限。格式: id=" ",id=" " ；
 当需要给子账户授权时，id="qcs::cam::uin/<OwnerUin>:uin/<SubUin>"，
 当需要给根账户授权时，id="qcs::cam::uin/<OwnerUin>:uin/<OwnerUin>"
 */
@property (strong, nonatomic) NSString *grantFullControl;


/**
 表明该请求是否已经被中断
 */
@property (assign, atomic, readonly) BOOL aborted;
- (void) setFinishBlock:(void (^)(QCloudUploadObjectResult* result, NSError *))QCloudRequestFinishBlock;
#pragma resume
+ (instancetype) requestWithRequestData:(QCloudCOSXMLUploadObjectResumeData)resumeData;
- (QCloudCOSXMLUploadObjectResumeData) cancelByProductingResumeData:(NSError* __autoreleasing*)error;


- (void) abort:(QCloudRequestFinishBlock)finishBlock;
@end
