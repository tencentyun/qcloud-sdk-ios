//
//  QCloudGetPresignedURLRequest.m
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 17/01/2018.
//

#import "QCloudGetPresignedURLRequest.h"
#import "QCloudCOSXMLService.h"
#import <QCloudCore/NSError+QCloudNetworking.h>
@interface QCloudGetPresignedURLRequest ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *internalRequestParameters;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *internalRequestHeaders;
@property (nonatomic, strong) NSMutableArray *internalUriComponents;
//@property (nonatomic, copy) void(^finishBlock)(QCloudGetPresignedURLResult* result, NSError* error);
@end

@implementation QCloudGetPresignedURLRequest
- (instancetype)init {
    self = [super init];
    if (self) {
        self.internalRequestParameters = [NSMutableDictionary dictionary];
        self.internalRequestHeaders = [NSMutableDictionary dictionary];
        self.internalUriComponents = [NSMutableArray array];
        self.isUseSignature = YES;
        self.signHost = YES;
    }
    return self;
}
- (NSDictionary<NSString *, NSString *> *)requestHeaders {
    return [NSDictionary dictionaryWithDictionary:self.internalRequestHeaders];
}

- (NSDictionary<NSString *, NSString *> *)requestParameters {
    return [NSDictionary dictionaryWithDictionary:self.internalRequestParameters];
}

-(NSMutableArray<NSString *> *)uriComponents{
    return [NSMutableArray arrayWithArray:self.internalUriComponents];
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

- (void)setValue:(NSString *_Nullable)value forRequestHeader:(NSString *)requestHeader {
    [self.internalRequestHeaders setValue:value forKey:requestHeader];
}

- (void)setURICompnent:(NSString *)component{
    [self.internalUriComponents addObject:component];
}
- (void)setValue:(NSString *_Nullable)value forRequestParameter:(NSString *)requestParameter {
    [self.internalRequestParameters setValue:value forKey:requestParameter];
}

- (void)setFinishBlock:(void (^_Nullable)(QCloudGetPresignedURLResult *_Nullable result, NSError *_Nullable error))finishBlock {
    [super setFinishBlock:finishBlock];
}

- (NSURLRequest *)buildURLRequest:(NSError *__autoreleasing *)error {
    __block NSMutableURLRequest *mutableURLRequest = [[NSMutableURLRequest alloc] init];
    [mutableURLRequest setHTTPMethod:self.HTTPMethod];
    NSError *buildError;
    if (!self.bucket) {
        buildError =
            [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                                  message:[NSString stringWithFormat:@"InvalidArgument:paramter[bucket] which cannot be nil is invalid (nil)"]];
    }
    NSMutableString *URLString = [[NSMutableString alloc] init];
    [URLString appendString:[self.runOnService.configuration.endpoint serverURLWithBucket:self.bucket
                                                                                    appID:self.runOnService.configuration.appID
                                                                               regionName:self.regionName]
                                .absoluteString];
    if (self.object) {
        [URLString appendFormat:@"/%@", self.object];
    }
    
    [self.uriComponents enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [URLString appendFormat:@"?%@", obj];
    }];
    
   
    if(self.signHost){
        NSURL *url = [NSURL URLWithString:URLString];
        [self.internalRequestHeaders setValue:url.host forKey:@"host"];
    }
    [self.requestHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSString *_Nonnull obj, BOOL *_Nonnull stop) {
        [mutableURLRequest setValue:obj forHTTPHeaderField:key];
    }];
    

    
    NSString *paramters = QCloudURLEncodeParamters(self.requestParameters, NO, NSUTF8StringEncoding);
    NSString *resultURL;
    if (paramters && paramters.length > 0) {
        if ([URLString hasPrefix:@"?"]) {
            URLString = [[paramters substringFromIndex:1] mutableCopy];
        }
        NSRange range = [URLString rangeOfString:@"?"];
        if (range.location != NSNotFound) {
            if ([URLString hasSuffix:@"?"]) {
                resultURL = [NSString stringWithFormat:@"%@%@", URLString, paramters];
            } else {
                if ([URLString hasSuffix:@"&"]) {
                    resultURL = [NSString stringWithFormat:@"%@%@", URLString, paramters];
                } else {
                    resultURL = [NSString stringWithFormat:@"%@&%@", URLString, paramters];
                }
            }
        } else {
            resultURL = [NSString stringWithFormat:@"%@?%@&", URLString, paramters];
        }
    } else {
        resultURL = [URLString copy];
    }

    NSString *encodedString = (NSString *)
        //当不管url中的中文是否已经utf-8转码了，都可以解决将中文字符转为utf-8的问题，且不是二次转码
        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,

                                                                  (CFStringRef)resultURL,

                                                                  (CFStringRef) @"!$&'()*+,-./:;=?@_~%#[]",

                                                                  NULL,

                                                                  kCFStringEncodingUTF8));
    [mutableURLRequest setURL:[NSURL URLWithString:encodedString]];
 
    return mutableURLRequest;
}

@end
