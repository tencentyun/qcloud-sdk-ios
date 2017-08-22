//
//  QCloudAuthentationCreator.m
//  Pods
//
//  Created by Dong Zhao on 2017/5/2.
//
//

#import "QCloudAuthentationCreator.h"
#import "QCloudSignature.h"
#import "QCloudCredential.h"
#import "QCloudSignatureFields.h"
#import "QCloudHTTPRequest.h"
#import "QCloudRequestSerializer.h"
#import "NSString+QCloudSHA.h"
#import <CommonCrypto/CommonDigest.h>
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

- (QCloudSignature*) signatureForFields:(QCloudSignatureFields *)fields
{
    return nil;
}

- (QCloudSignature*) signatureForCOSXMLRequest:(QCloudHTTPRequest *)reuqest
{
    NSError* error;
    NSURLRequest* urlrequest = [reuqest cachedBuildURLRequest:&error];
    
    
    NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval experationInterVal = nowInterval + 24*60*60;
    NSString * signTime = [NSString stringWithFormat:@"%lld;%lld",(int64_t)nowInterval, (int64_t)experationInterVal];
    //
    NSDictionary* headers = [urlrequest allHTTPHeaderFields];
    
    NSMutableDictionary* dic = [NSMutableDictionary new];
    if (headers[@"Host"]) {
        dic[@"Host"] = headers[@"Host"];
    }
    headers = dic;
    
    
    
    NSDictionary* urlParamters = QCloudURLReadQuery(urlrequest.URL);
    
    NSDictionary* (^LowcaseDictionary)(NSDictionary* origin) = ^(NSDictionary* origin) {
        
        NSMutableDictionary* aim = [NSMutableDictionary new];
        NSArray* allKeys = origin.allKeys;
        
        for (NSString* key in allKeys) {
            NSString* transKey = key;
            if (![key isKindOfClass:[NSString class]]) {
                transKey = [NSString stringWithFormat:@"%@",key];
            }
            NSString* value = origin[key];
            aim[transKey.lowercaseString] = value.lowercaseString;
        }
        return [aim copy];
    };

    // 第一步生成signKey
    NSString* signKey = [NSString qcloudHMACHexsha1:signTime secret:self.credential.secretKey];
    // Step2 构成FormatString
    NSString* headerFormat = QCloudURLEncodeParamters(LowcaseDictionary(headers), YES, NSUTF8StringEncoding);
    NSString* urlFormat = QCloudURLEncodeParamters(LowcaseDictionary(urlParamters), YES, NSUTF8StringEncoding);
    
    NSMutableString* formatString = [NSMutableString new];
    
    void(^AppendFormatString)(NSString*) = ^(NSString* part) {
        [formatString appendFormat:@"%@\n",part];
    };
    
    AppendFormatString(urlrequest.HTTPMethod.lowercaseString);
    NSString* path = urlrequest.URL.path;
    if (path.length == 0) {
        path = @"/";
    }
    AppendFormatString(path);
    AppendFormatString(urlFormat);
    AppendFormatString(headerFormat);
    
    NSString* formatStringSHA = [formatString qcloud_sha1];
    
    // step 3 计算StringToSign
    
    NSString* stringToSign = [NSString stringWithFormat:@"%@\n%@\n%@\n", @"sha1", signTime, formatStringSHA];
    
    // step 4 计算签名
    
    
    NSString* signature = [NSString qcloudHMACHexsha1:stringToSign secret:signKey];
    
    // step 5 构造Authorization
    
    NSString* (^DumpAllKeys)(NSDictionary*) = ^(NSDictionary* info) {
        NSArray* keys = info.allKeys;
        
        NSMutableArray* redirectKeys = [NSMutableArray new];
        for (NSString* key in keys) {
            [redirectKeys addObject:key.lowercaseString];
        }
        [redirectKeys sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        
        NSString* keyString = @"";
        for (int i = 0; i < redirectKeys.count; i ++) {
            keyString = [keyString stringByAppendingString:redirectKeys[i]];
            if (i < (int)redirectKeys.count -1) {
                keyString = [keyString stringByAppendingString:@";"];
            }
        }
        return keyString;
    };
    
    NSString* keyTime = signTime;
    if (self.credential.experationDate && self.credential.validBeginDate) {
        keyTime = [NSString stringWithFormat:@"%lld;%lld",(int64_t)[self.credential.experationDate timeIntervalSince1970],(int64_t)[self.credential.experationDate timeIntervalSince1970] ];
    }
    NSString* authoration = [NSString stringWithFormat:@"q-sign-algorithm=sha1&q-ak=%@&q-sign-time=%@&q-key-time=%@&q-header-list=%@&q-url-param-list=%@&q-signature=%@", self.credential.secretID, signTime, signTime, DumpAllKeys(headers), DumpAllKeys(urlParamters) ,signature];
    return [QCloudSignature signatureWith1Day:authoration];
}
@end
