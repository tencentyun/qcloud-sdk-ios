//
//  QCloudSignatureFields.m
//  Pods
//
//  Created by Dong Zhao on 2017/4/21.
//
//

#import "QCloudSignatureFields.h"
#import "QCloudFileUtils.h"
#import "QCLOUDRestNet.h"
@implementation QCloudSignatureFields
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _once = NO;
    return self;
}
- (NSString* ) filed
{
    NSString* filed = @"/";
    if (self.appID.length) {
        filed = QCloudPathJoin(filed, self.appID);
    }
    if (self.bucket.length) {
        filed = QCloudPathJoin(filed, self.bucket);
    }
    if (self.directory.length) {
        filed = QCloudPathJoin(filed, self.directory);
        filed= QCloudPathJoin(filed, @"/");
    }
    if (self.fileName.length) {
        filed = QCloudPathJoin(filed, self.fileName);
    }
    filed = QCloudStrigngURLEncode(filed, NSUTF8StringEncoding);
    return filed;
}
@end
