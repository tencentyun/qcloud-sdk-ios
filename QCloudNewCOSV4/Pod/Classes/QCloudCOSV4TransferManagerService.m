//
//  QCloudCOSV4TransferManagerService.m
//  QCloudCOS
//
//  Created by erichmzhang(张恒铭) on 06/11/2017.
//

#import "QCloudCOSV4TransferManagerService.h"
#import "QCloudCOSV4Error.h"
#import "QCloudError.h"
#import "QCloudThreadSafeMutableDictionary.h"
#import "QCloudOperationQueue.h"
#import "QCloudCOSV4UploadObjectRequest.h"
#import "QCloudUploadObjectRequest_Private.h"
static QCloudCOSV4TransferManagerService* COSTransferMangerService = nil;
QCloudThreadSafeMutableDictionary* QCloudCOSV4TransferMangerServiceCache()
{
    static QCloudThreadSafeMutableDictionary* CloudcostransfermangerService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CloudcostransfermangerService = [QCloudThreadSafeMutableDictionary new];
    });
    return CloudcostransfermangerService;
}
@interface QCloudCOSV4TransferManagerService()
@property (nonatomic, strong) QCloudOperationQueue* uploadFileQueue;
@end


@implementation QCloudCOSV4TransferManagerService
+ (QCloudCOSV4TransferManagerService*)defaultCOSV4TransferManager {
    @synchronized (self) {
        if (!COSTransferMangerService) {
            @throw [NSException exceptionWithName:QCloudErrorDomain reason:@"您没有配置默认的OCR服务配置，请配置之后再调用该方法" userInfo:nil];
        }
        return COSTransferMangerService;
    }
}

+ (QCloudCOSV4TransferManagerService*) registerDefaultCOSV4TransferMangerWithConfiguration:(QCloudServiceConfiguration*)configuration
{
    @synchronized (self) {
        COSTransferMangerService = [[QCloudCOSV4TransferManagerService alloc] initWithConfiguration:configuration];
    }
    return COSTransferMangerService;
}


+ (QCloudCOSV4TransferManagerService*) registerDefaultCOSV4TransferMangerWithConfiguration:(QCloudServiceConfiguration*)configuration withKey:(NSString*)key;
{
    QCloudCOSV4TransferManagerService* costransfermangerService =[[QCloudCOSV4TransferManagerService alloc] initWithConfiguration:configuration];
    [QCloudCOSV4TransferMangerServiceCache() setObject:costransfermangerService  forKey:key];
    return costransfermangerService;
}

- (instancetype)initWithConfiguration:(QCloudServiceConfiguration *)configuration {
    self = [super initWithConfiguration:configuration];
    _uploadFileQueue = [[QCloudOperationQueue alloc] init];
    return self;
}
- (void) loadAuthorizationForBiz:(QCloudBizHTTPRequest*)bizRequest urlRequest:(NSMutableURLRequest*)urlrequest compelete:(QCloudHTTPAuthentationContinueBlock)cotinueBlock
{
    [self loadCOSV4AuthorizationForBiz:bizRequest urlRequest:urlrequest compelete:cotinueBlock];
}

- (void)uploadObject:(QCloudCOSV4UploadObjectRequest *)request {
    request.transferManager = self;
    request.runOnService = self;
    QCloudFakeRequestOperation* operation = [[QCloudFakeRequestOperation alloc] initWithRequest:request];
    [self.uploadFileQueue addOpreation:operation];
}

@end
