//
//  QCloudGetPresignedURLRequest.m
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 17/01/2018.
//

#import "QCloudGetPresignedURLRequest.h"
#import "QCloudCOSXMLService.h"
#import <QCloudCore/NSError+QCloudNetworking.h>
@interface QCloudGetPresignedURLRequest()
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *internalRequestParameters;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *internalRequestHeaders;
//@property (nonatomic, copy) void(^finishBlock)(QCloudGetPresignedURLResult* result, NSError* error);
@end

@implementation QCloudGetPresignedURLRequest
- (NSDictionary<NSString *, NSString *> *)requestHeaders {
    return [NSDictionary dictionaryWithDictionary:self.internalRequestHeaders];
}

- (NSDictionary<NSString *, NSString *> *)requestParameters {
    return [NSDictionary dictionaryWithDictionary:self.internalRequestParameters];
}
- (NSString *)contentType {
    return [self.internalRequestHeaders objectForKey:@"Content-Type"];
}

- (void)setContentType:(NSString *)contentType {
    [self setValue:contentType forRequestHeader:@"Content-Type"];
}

- (NSString *)contentMD5 {
    return [self.internalRequestHeaders objectForKey:@"Content-MD5"];
}

- (void)setContentMD5:(NSString *)contentMD5 {
    [self setValue:contentMD5 forRequestHeader:@"Content-MD5"];
}

- (void)setValue:(NSString * _Nullable)value forRequestHeader:(NSString *)requestHeader {
    [self.internalRequestHeaders setValue:value forKey:requestHeader];
}

- (void)setValue:(NSString * _Nullable)value forRequestParameter:(NSString *)requestParameter {
    [self.internalRequestParameters setValue:value forKey:requestParameter];
}



- (void)setFinishBlock:(void (^)(QCloudGetPresignedURLResult *, NSError *))finishBlock {
    [super setFinishBlock:finishBlock];
}

- (NSURLRequest*) buildURLRequest:(NSError *__autoreleasing *)error {
    __block NSMutableURLRequest* mutableURLRequest = [[NSMutableURLRequest alloc] init];
    [mutableURLRequest setHTTPMethod:self.HTTPMethod];
    NSError* buildError;
    if (!self.bucket) {
        buildError =[NSError qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid message:[NSString stringWithFormat:@"paramter[bucket] which cannot be nil is invalid (nil)"]];
    }
    NSMutableString* URLString = [[NSMutableString alloc] init];
    [URLString appendString:[self.runOnService.configuration.endpoint serverURLWithBucket:self.bucket appID:self.runOnService.configuration.appID].absoluteString];
    if (self.object) {
        [URLString appendFormat:@"/%@",self.object];
    }
    
    [self.requestHeaders enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [mutableURLRequest setValue:key forHTTPHeaderField:obj];
    }];
    
    NSString* paramters = QCloudURLEncodeParamters(self.requestParameters, NO, NSUTF8StringEncoding);
    NSString* resultURL;
    if (paramters && paramters.length > 0) {
        if ([URLString hasPrefix:@"?"]) {
            URLString = [[paramters substringFromIndex:1] mutableCopy];
        }
        NSRange range = [URLString rangeOfString:@"?"];
        if (range.location != NSNotFound) {
            if ([URLString hasSuffix:@"?"]) {
                resultURL = [NSString stringWithFormat:@"%@%@",URLString, paramters];
            } else {
                if ([URLString hasSuffix:@"&"]) {
                    resultURL = [NSString stringWithFormat:@"%@%@",URLString,paramters];
                } else {
                    resultURL = [NSString stringWithFormat:@"%@&%@",URLString, paramters];
                }
            }
        } else {
            resultURL = [NSString stringWithFormat:@"%@?%@",URLString, paramters];
        }
    } else {
        resultURL = [URLString copy];
    }
    [mutableURLRequest setURL:[NSURL URLWithString:resultURL]];
    
    return mutableURLRequest;
}

@end
