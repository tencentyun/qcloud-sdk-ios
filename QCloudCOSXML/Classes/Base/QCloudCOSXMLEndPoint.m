//
//  QCloudCOSXMLEndPoint.m
//  Pods
//
//  Created by Dong Zhao on 2017/8/22.
//
//

#import "QCloudCOSXMLEndPoint.h"
#import "NSString+RegularExpressionCategory.h"
@implementation QCloudCOSXMLEndPoint

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _isPrefixURL = YES;
    _serviceName = @"myqcloud.com";
    return self;
}



- (NSString *)formattedBucket:(NSString*)bucket withAPPID:(NSString*)APPID {
    NSInteger subfixLength = APPID.length + 1;
    if (bucket.length <= subfixLength) {
        return bucket;
    }
    NSString* APPIDSubfix = [NSString stringWithFormat:@"-%@",APPID];
    if (APPIDSubfix) {
        NSString* subfixString = [bucket substringWithRange:NSMakeRange(bucket.length - subfixLength  , subfixLength)];
        if ([subfixString isEqualToString:APPIDSubfix]) {
            return [bucket substringWithRange:NSMakeRange(0, bucket.length - subfixLength)];
        }
    }else{
        if (!APPID) {
             @throw [NSException exceptionWithName:kQCloudNetworkDomain reason:[NSString stringWithFormat:@"您没有配置AppID就使用了服务%@", self.class] userInfo:nil];
        }
    }
   
    //should not reach here
    return bucket;
}

-(NSURL *)serverURLWithBucket:(NSString *)bucket appID:(NSString *)appID regionName:(NSString *)regionName{
    if (self.serverURLLiteral) {
        return self.serverURLLiteral;
    }
    
    NSString* scheme = @"https";
    if (!self.useHTTPS) {
        scheme = @"http";
    }
    static NSString *regularExpression = @"[a-zA-Z0-9.-]*";
    BOOL isLegal = [bucket matchesRegularExpression:regularExpression];
    NSAssert(isLegal, @"bucket name contains illegal character! It can only contains a-z, A-Z, 0-9, '.' and '-' ");
    if (!isLegal) {
        QCloudLogDebug(@"bucket %@ contains illeagal character, building service url pregress  returns immediately", bucket);
        return  nil;
    }
    NSString* formattedBucketName = [self formattedBucket:bucket withAPPID:appID];
    if (appID) {
        formattedBucketName = [NSString stringWithFormat:@"%@-%@",formattedBucketName,appID];
    }
    NSString *regionNametmp = nil;
    if (regionName) {
        regionNametmp = regionName;
    }else{
        regionNametmp = self.regionName;
    }
    NSURL *serverURL;

    serverURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@.cos.%@.%@",scheme,formattedBucketName,regionNametmp,self.serviceName]];
    if (!self.isPrefixURL) {
         serverURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@.cos.%@/%@",scheme,regionNametmp,self.serviceName,formattedBucketName]];
    }
    if (self.suffix) {
        serverURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@.%@",scheme,formattedBucketName,self.suffix]];
        if (!self.isPrefixURL) {
            serverURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/%@",scheme,self.suffix,formattedBucketName]];
        }
    }
    QCloudLogDebug(@"serverURL:  %@",serverURL);
    return serverURL;
}
-(void)setIsPrefixURL:(BOOL)isPrefixURL{
    _isPrefixURL = isPrefixURL;
}
- (void)setRegionName:(QCloudRegion)regionName {
    //Region 仅允许由 a-z, A-Z, 0-9, 英文句号. 和 - 构成。
    if ([self.serviceName isEqualToString:@"myqcloud.com"]) {
        NSParameterAssert(regionName);
        static NSString *regularExpression = @"[a-zA-Z0-9.-]*";
        BOOL isLegal = [regionName matchesRegularExpression:regularExpression];
        NSAssert(isLegal, @"Region name contains illegal character! It can only contains a-z, A-Z, 0-9, '.' and '-' ");
        if (!isLegal) {
            QCloudLogDebug(@"Region %@ contains illeagal character, setter returns immediately", regionName);
            return ;
        }
    }
   
   
    _regionName = regionName;
}
- (id)copyWithZone:(NSZone *)zone {
    QCloudCOSXMLEndPoint* endpoint = [super copyWithZone:nil];
    endpoint.regionName = self.regionName;
    endpoint.serviceName = self.serviceName;
    endpoint.isPrefixURL = self.isPrefixURL;
    endpoint.suffix = self.suffix;
    return endpoint;
}
@end
