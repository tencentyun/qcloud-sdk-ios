//
//  QCloudAuthentationCreator.m
//  Pods
//
//  Created by Dong Zhao on 2017/5/2.
//
//

#import "QCloudAuthentationCreator.h"
#import "QCloudError.h"
@implementation QCloudAuthentationCreator
- (instancetype) initWithCredential:(QCloudCredential *)credential
{
    self = [super init];
    if (!self) {
        return self;
    }
    _credential = credential;
    return self;
}
- (QCloudSignature*) signatureForData:(id)signData
{
    @throw [NSException exceptionWithName:QCloudErrorDomain reason:@"请在子类中实现该函数" userInfo:nil];
}
@end
