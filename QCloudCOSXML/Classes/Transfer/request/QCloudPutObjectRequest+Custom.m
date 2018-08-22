//
//  QCloudPutObjectRequest+Custom.m
//  Pods-QCloudCOSXMLDemo
//
//  Created by karisli(李雪) on 2018/8/14.
//

#import "QCloudPutObjectRequest+Custom.h"
#import <QCloudCore/NSObject+HTTPHeadersContainer.h>
#import <objc/runtime.h>
@interface QCloudBizHTTPRequest()
- (void)__notifySuccess:(id)object;
@end

@implementation  QCloudPutObjectRequest (Custom)
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setEnableMD5Verification:YES];
    }
    return self;
}

- (void) __notifySuccess:(id)object
{
    if (!self.enableMD5Verification || ((NSObject*)object).__originHTTPURLResponse__ == nil) {
        [super __notifySuccess:object];
        return ;
    }
    
    NSString* MD5FromETag = [((NSObject*)object).__originHTTPURLResponse__ allHeaderFields][@"Etag"];
    if (MD5FromETag) {
        MD5FromETag =[MD5FromETag substringWithRange:NSMakeRange(1, MD5FromETag.length-2)];
    }
    NSString* localMD5String ;
    if ([self.body isKindOfClass:[NSData class]]) {
        localMD5String = QCloudEncrytNSDataMD5(self.body);
    } else if ([self.body isKindOfClass:[NSURL class]]) {
        localMD5String = QCloudEncrytFileMD5(((NSURL*)self.body).path);
    }
    
    NSError* resultError;
    if ((localMD5String!=nil) && !([localMD5String.lowercaseString isEqualToString:MD5FromETag])) {
        NSMutableString* errorMessageString = [[NSMutableString alloc] init];
        [errorMessageString appendFormat:@"简单上传过程中MD5校验与本地不一致，请检查本地文件在上传过程中是否发生了变化,建议调用删除接口将COS上的文件删除并重新上传,本地计算的 MD5 值:%@, 返回的 ETag值:%@",localMD5String,MD5FromETag];
        if ( [((NSObject*)object).__originHTTPURLResponse__ allHeaderFields][@"x-cos-request-id"]!= nil) {
            NSString* requestID = [((NSObject*)object).__originHTTPURLResponse__ allHeaderFields][@"x-cos-request-id"];
            [errorMessageString appendFormat:@", Request id:%@",requestID];
        }
        resultError = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeMD5NotMatch message:errorMessageString];
    }
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.finishBlock(object, resultError);
    });
    
    [self.benchMarkMan benginWithKey:kRNBenchmarkLogicOnly];
    if ([self.delegate respondsToSelector:@selector(QCloudHTTPRequestDidFinished:succeedWithObject:)]){
        [self.delegate QCloudHTTPRequestDidFinished:self succeedWithObject:object];
    }
    
    
    [self.benchMarkMan markFinishWithKey:kRNBenchmarkLogicOnly];
}

- (BOOL)enableMD5Verification {
    NSNumber* number = objc_getAssociatedObject(self, @selector(enableMD5Verification));
    return [number boolValue];
}

- (void)setEnableMD5Verification:(BOOL)enableMD5Verification {
    NSNumber* number = [NSNumber numberWithBool:enableMD5Verification];
    objc_setAssociatedObject(self, @selector(enableMD5Verification), number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setCOSServerSideEncyptionWithCustomerKey:(NSString *)customerKey{
    
    [super setCOSServerSideEncyptionWithCustomerKey:customerKey];
    self.enableMD5Verification = NO;
}
-(void)setCOSServerSideEncyptionWithKMSCustomKey:(NSString *)customerKey jsonStr:(NSString *)jsonStr{
    self.enableMD5Verification = NO;
    self.customHeaders[@"x-cos-server-side-encryption"] = @"cos/kms";
    if(customerKey){
        self.customHeaders[@"x-cos-server-side-encryption-cos-kms-key-id"] = customerKey;
    }
    if(jsonStr){
        //先将string转换成data
        NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        self.customHeaders[@"x-cos-server-side-encryption-context"] = [data base64EncodedStringWithOptions:0];
    }
}
@end
