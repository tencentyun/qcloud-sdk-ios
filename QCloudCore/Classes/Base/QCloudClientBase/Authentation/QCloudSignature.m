//
//  QCloudSignature.m
//  Pods
//
//  Created by Dong Zhao on 2017/4/5.
//
//

#import "QCloudSignature.h"
#import "NSDate+QCloudComapre.h"
#define QCloudSignatureExpiration(days) [NSDate dateWithTimeIntervalSinceNow:(days)*60 * 60 * 24]
#define QCloudSignatureMaxExpiration QCloudSignatureExpiration(30)

@interface QCloudSignature ()
@property (nonatomic, assign, readwrite) QCloudSignatureSourceType sourceType;
@end

@implementation QCloudSignature

- (void)setSignatureSourceType:(QCloudSignatureSourceType)sourceType {
    _sourceType = sourceType;
}
+ (QCloudSignature *)signatureWith1Day:(NSString *)signature {
    return [[self alloc] initWithSignature:signature expiration:QCloudSignatureExpiration(1)];
}
+ (QCloudSignature *)signatureWith7Day:(NSString *)signature {
    return [[self alloc] initWithSignature:signature expiration:QCloudSignatureExpiration(7)];
}
+ (QCloudSignature *)signatureWithMaxExpiration:(NSString *)signature {
    return [[self alloc] initWithSignature:signature expiration:QCloudSignatureExpiration(7)];
}

- (instancetype)initWithSignature:(NSString *)signature expiration:(NSDate *)expiration {
    self = [super init];
    if (!self) {
        return self;
    }
    _sourceType = QCloudSignatureSourceTypeServer;
    _signature = signature;
    if ([expiration qcloud_isLaterThan:QCloudSignatureMaxExpiration]) {
        expiration = QCloudSignatureMaxExpiration;
    }
    _expiration = expiration;
    return self;
}
@end
