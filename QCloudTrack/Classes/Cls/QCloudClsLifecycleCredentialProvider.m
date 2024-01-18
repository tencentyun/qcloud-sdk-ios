//
//  QCloudClsLifecycleCredentialProvider.m
//  Pods-QCloudCOSXMLDemo
//
//  Created by garenwang on 2023/12/26.
//

#import "QCloudClsLifecycleCredentialProvider.h"
#import "QCloudClsSessionCredentials.h"
@interface QCloudClsLifecycleCredentialProvider ()

@property (nonatomic,strong)QCloudClsSessionCredentials * credentials;

@property (nonatomic,strong)QCloudClsSessionCredentials * permanentCredentials;

@property (nonatomic,copy)QCloudCredentialRefreshBlock refreshBlock;

@end

@implementation QCloudClsLifecycleCredentialProvider

-(instancetype)initWithPermanentCredentials:(QCloudClsSessionCredentials *) credentials{
    self = [super init];
    if (self) {
        self.permanentCredentials = credentials;
    }
    return self;
}

-(instancetype)initWithCredentialsRefresh:(QCloudCredentialRefreshBlock) refreshBlock{
    self = [super init];
    if (self) {
        self.refreshBlock = refreshBlock;
    }
    return self;
}

-(void)updatePermanentCredentials:(QCloudClsSessionCredentials *) credentials{
    self.permanentCredentials = credentials;
}

-(QCloudClsSessionCredentials *)getCredentials{
    if (self.permanentCredentials) {
        return self.permanentCredentials;
    }
    if (!self.credentials || self.credentials.isValid) {
        [self refresh];
    }
    return self.credentials;
}

-(void)forceInvalidationCredential{
    self.credentials = nil;
}

-(void)refresh{
    if ( self.credentials == nil || !self.credentials.isValid) {
        if (!self.refreshBlock) {
            return;
        }
        self.credentials = self.refreshBlock();
    }
}
@end
