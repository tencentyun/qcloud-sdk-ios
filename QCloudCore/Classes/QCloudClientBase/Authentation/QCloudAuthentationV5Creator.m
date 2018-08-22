//
//  QCloudAuthentationV5Creator.m
//  Pods
//
//  Created by Dong Zhao on 2017/8/31.
//
//

#import "QCloudAuthentationV5Creator.h"
#import "QCloudSignature.h"
#import "QCloudCredential.h"
#import "QCloudSignatureFields.h"
#import "QCloudHTTPRequest.h"
#import "QCloudRequestSerializer.h"
#import "NSString+QCloudSHA.h"
#import <CommonCrypto/CommonDigest.h>
#import "QCloudLogger.h"
#import "QCloudURLHelper.h"
@implementation NSDictionary(HeaderFilter)
- (NSDictionary*)filteHeaders; {
    NSMutableDictionary* signedHeaders = [[NSMutableDictionary alloc] init];
    __block  const NSMutableArray* shouldSignedHeaderList = @[ @"Content-Length", @"Content-MD5"];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //签名的Headers列表：x开头的(x-cos-之类的),content-length,content-MD5
        BOOL shouldSigned = NO;
        for (NSString* header in shouldSignedHeaderList) {
            if ([header isEqualToString:((NSString*)key)]) {
                shouldSigned = YES;
            }
        }
        NSArray* headerSeperatedArray = [key componentsSeparatedByString:@"-"];
        if ([headerSeperatedArray firstObject] && [headerSeperatedArray.firstObject isEqualToString:@"x"]) {
            shouldSigned = YES;
        }
        if (shouldSigned) {
            signedHeaders[key]=obj;
        }
    }];
    return  [signedHeaders copy];
}
@end

@implementation NSURL(QCloudExtension)

/**
 返回 COS 签名中用到的 path , 。如果没有path时，为 /
 
 例如
 1. URL 为: http://test-123456.cos.ap-shanghai.myqcloud.com?delimiter=%2F&max-keys=1000&prefix=test%2F
 
 path为 /
 
 2. URL为: http://test-123456.cos.ap-shanghai.myqcloud.com/test
 path 为 test
 
 3. URL为: http://test-123456.cos.ap-shanghai.myqcloud.com/test/
 path 为 test/
 
 
 @return COS签名中定义的 path
 */

- (NSString*)qcloud_path {
    NSString* path = QCloudPercentEscapedStringFromString(self.path);
    //absoluteString in NSURL is URLEncoded
    NSRange pathRange = [self.absoluteString rangeOfString:path];
    NSUInteger URLLength = self.absoluteString.length;
    if ( pathRange.location == NSNotFound ) {
        return self.path;
    }
    NSUInteger pathLocation = pathRange.location + pathRange.length;
    if (pathLocation >= URLLength) {
        return self.path;
    }
    if ( [self.absoluteString characterAtIndex:(pathLocation)] == '/' ) {
        path = [self.path stringByAppendingString:@"/"];
        return path;
    }
   
    return self.path;
}

@end

@implementation QCloudAuthentationV5Creator

- (QCloudSignature*) signatureForData:(NSMutableURLRequest *)urlrequest
{
    if (self.credential.token) {
        [urlrequest setValue:self.credential.token forHTTPHeaderField:@"x-cos-security-token"];
    }
    int64_t nowInterval = 0;
    if (self.credential.startDate) {
        nowInterval = [self.credential.startDate timeIntervalSince1970];
    } else {
        nowInterval = [[NSDate date] timeIntervalSince1970];
    }
    //  默认一个签名为10分钟有效，防止签名时间过长，导致泄露
    NSTimeInterval experationInterVal = nowInterval + 10*60;
    if (self.credential.experationDate) {
        experationInterVal = [self.credential.experationDate timeIntervalSince1970];
    }
    NSString * signTime = [NSString stringWithFormat:@"%lld;%lld",(int64_t)nowInterval, (int64_t)experationInterVal];
    //
    NSDictionary* headers = [[urlrequest allHTTPHeaderFields] filteHeaders];
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
            aim[transKey.lowercaseString] = value;
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
    NSString* path = urlrequest.URL.qcloud_path;
    if (path.length == 0) {
        path = @"/";
    }
    AppendFormatString(path);
    AppendFormatString(urlFormat);
    AppendFormatString(headerFormat);
    
    NSString* formatStringSHA = [formatString qcloud_sha1];
    QCloudLogDebug(@"format string is %@",formatString);
    // step 3 计算StringToSign
    
    NSString* stringToSign = [NSString stringWithFormat:@"%@\n%@\n%@\n", @"sha1", signTime, formatStringSHA];
    QCloudLogDebug(@"StringToSign is %@",stringToSign);
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
    
    //key有效期
    NSString* keyTime = signTime;
    NSString* authoration = [NSString stringWithFormat:@"q-sign-algorithm=sha1&q-ak=%@&q-sign-time=%@&q-key-time=%@&q-header-list=%@&q-url-param-list=%@&q-signature=%@", self.credential.secretID, signTime, keyTime, DumpAllKeys(headers), DumpAllKeys(urlParamters) ,signature];
    QCloudLogDebug(@"authoration is %@", authoration);
    return [QCloudSignature signatureWith1Day:authoration];
}


@end

