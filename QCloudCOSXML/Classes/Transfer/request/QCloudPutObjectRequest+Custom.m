//
//  QCloudPutObjectRequest+Custom.m
//  Pods-QCloudCOSXMLDemo
//
//  Created by karisli(李雪) on 2018/8/14.
//

#import "QCloudPutObjectRequest+Custom.h"
#import <QCloudCore/QCloudCore.h>
#import <objc/runtime.h>
@interface QCloudBizHTTPRequest()
@end

@implementation  QCloudPutObjectRequest (Custom)


-(void)setCOSServerSideEncyptionWithCustomerKey:(NSString *)customerKey{
    
    [super setCOSServerSideEncyptionWithCustomerKey:customerKey];
}
-(void)setCOSServerSideEncyptionWithKMSCustomKey:(NSString *)customerKey jsonStr:(NSString *)jsonStr{;
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
