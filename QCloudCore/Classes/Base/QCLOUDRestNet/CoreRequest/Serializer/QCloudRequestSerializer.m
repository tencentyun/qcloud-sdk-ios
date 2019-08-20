//
//  QCloudRequestSerializer.m
//  QCloudNetworking
//
//  Created by tencent on 15/9/23.
//  Copyright © 2015年 QCloudTernimalLab. All rights reserved.
//
#import "QCloudRequestSerializer.h"
#import "QCloudRequestData.h"
#import "NSHTTPCookie+QCloudNetworking.h"
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import "QCloudReachability.h"
#import "QCloudHTTPBodyPart.h"
#import "QCloudLogger.h"
#import "QCloudFileUtils.h"
#import "QCloudWeakProxy.h"
#import "QCloudXMLDictionary.h"
#import "QCloudEncryt.h"
#import "QCloudFileOffsetBody.h"
#import "QCloudURLHelper.h"
NSString* const HTTPMethodPOST = @"POST";
NSString* const HTTPMethodGET = @"GET";
NSString* const HTTPHeaderHOST = @"HOST";
NSString* const HTTPHeaderContentType = @"Content-Type";
NSString* const HTTPHeaderContentTypeURLEncode = @"application/x-www-form-urlencoded; charset=utf-8";


inline NSString* QCloudEnuserNoneNullString(NSString* str) {
    if (!str) {
        return @"";
    } else {
        return str;
    }

}



NSString* QCloudStrigngURLEncode(NSString *string , NSStringEncoding stringEncoding)
{
    NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (CFStringRef)string,
                                                                                                    NULL,
                                                                                                    CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^`"),
                                                                                                    CFStringConvertNSStringEncodingToEncoding(stringEncoding)));
    if (escaped_value) {
        return escaped_value;
    }
    return @"";
}





NSString* QCloudStrigngURLEncodeWithoutSpecials(NSString *string , NSStringEncoding stringEncoding)
{
    NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (CFStringRef)string,
                                                                                                    NULL,
                                                                                                    CFSTR("?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),
                                                                                                    CFStringConvertNSStringEncodingToEncoding(stringEncoding)));
    if (escaped_value) {
        return escaped_value;
    }
    return @"";
}

NSString* QCloudStringURLDecode(NSString* string, NSStringEncoding encoding) {
    NSString *decoded = [string stringByReplacingPercentEscapesUsingEncoding:encoding];
    return decoded;
}


NSString* QCloudURLEncodeUTF8(NSString* string) {
    return QCloudStrigngURLEncode(string, NSUTF8StringEncoding);
}

NSString* QCloudURLDecodeUTF8(NSString* string) {
    return QCloudStringURLDecode(string, NSUTF8StringEncoding);
}


NSString* QCloudNSURLEncode(NSString* url) {
    url = url.lowercaseString;
    NSArray* schemes = @[@"http://", @"https://"];
    for (NSString* scheme in schemes) {
        if ([url hasPrefix:scheme]) {
            url = [url substringFromIndex:scheme.length];
            url = [NSString stringWithFormat:@"%@%@",scheme, QCloudStrigngURLEncodeWithoutSpecials(url, NSUTF8StringEncoding)];
            break;
        }
    }
    return url;
}


NSString* QCloudEncodeURL(NSString* url) {
    BOOL hasSubfix = [url hasSuffix:@"/"];
    NSString* http  = @"http://";
    NSString* https = @"https://";
    NSString* prefix = @"";
    if ([url.lowercaseString hasPrefix:http]) {
       url = [url substringFromIndex:http.length];
        prefix = http;
    } else if ([url.lowercaseString hasPrefix:https]) {
        url  = [url substringFromIndex:https.length];
        prefix = https;
    }
    NSArray* compnents = [url componentsSeparatedByString:@"/"];
    NSString* path = prefix;
    for (NSString* component in compnents) {
        path = QCloudPathJoin(path, QCloudStrigngURLEncode(component, NSUTF8StringEncoding));
    }
    if (hasSubfix) {
        path = QCloudPathJoin(path, @"/");
    }
    return path;
}


NSDictionary* QCloudURLReadQuery(NSURL* url)
{
    NSString* query = url.query;
    if (!query) {
        return @{};
    }
    NSMutableDictionary* queryDic = [NSMutableDictionary new];
    NSArray* keyvalues = [query componentsSeparatedByString:@"&"];
    for (NSString* kv in keyvalues) {
        NSArray* vs = [kv componentsSeparatedByString:@"="];
        if (vs.count == 2) {
            queryDic[QCloudStringURLDecode(vs[0], NSUTF8StringEncoding)] = QCloudStringURLDecode(vs[1], NSUTF8StringEncoding);
        } else if (vs.count == 1) {
            queryDic[QCloudStringURLDecode(vs.firstObject, NSUTF8StringEncoding)] = @"";
        }
    }
    return queryDic;
}

 NSString*  QCloudURLEncodeParamters(NSDictionary* dic, BOOL willUrlEncoding, NSStringEncoding stringEncoding){
    NSArray* allKeys = dic.allKeys;
    allKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableString* path = [NSMutableString new];
    for (int i = 0; i < allKeys.count; i++) {
        if (i > 0) {
            [path appendString:@"&"];
        }
        NSString* key = allKeys[i];
        NSString* value = dic[key];
        if (willUrlEncoding) {
            key = QCloudStrigngURLEncode(key, stringEncoding);
            value = QCloudStrigngURLEncode(value, stringEncoding);
        }

        NSString* segement = [NSString stringWithFormat:@"%@=%@", key, value];
        [path appendString:segement];
    }
    return [path copy];
}

 NSString* QCloudURLAppendParamters(NSString* base, NSString* paramters)
{
    if (paramters.length == 0) {
        return base;
    }
    if ([paramters hasPrefix:@"?"]) {
        paramters = [paramters substringFromIndex:1];
    }
    
    NSRange range = [base rangeOfString:@"?"];
    if (range.location != NSNotFound) {
        if ([base hasSuffix:@"?"]) {
            return [NSString stringWithFormat:@"%@%@",base, paramters];
        } else {
            if ([base hasSuffix:@"&"]) {
                return [NSString stringWithFormat:@"%@%@",base,paramters];
            } else {
                return [NSString stringWithFormat:@"%@&%@",base, paramters];
            }

        }
    } else {
        return [NSString stringWithFormat:@"%@?%@",base, paramters];
    }
}


QCloudRequestSerializerBlock QCloudURLAssembleWithParamters = ^(NSMutableURLRequest* request, QCloudRequestData* data, NSError* __autoreleasing*error){
   
    NSString* path = QCloudPathJoin(data.serverURL , data.URIMethod);
    path = QCloudURLAppendParamters(path, QCloudURLEncodeParamters(data.allParamters, NO, data.stringEncoding));
    NSURL* url = [NSURL URLWithString:path];
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    return urlRequest;
};


QCloudRequestSerializerBlock QCloudFuseParamtersASMultiData =  ^(NSMutableURLRequest* request, QCloudRequestData* data, NSError* __autoreleasing*error)
{
    NSArray* keys = data.allParamters.allKeys;
    for(NSString* key in keys) {
        NSString* value = data.allParamters[key];
        NSCAssert([value isKindOfClass:[NSString class]], @"请传入NSString类型的Value Key:%@ Value:%@",key,value);
        NSData* indata = [value dataUsingEncoding:data.stringEncoding];
        QCloudHTTPBodyPart* part = [[QCloudHTTPBodyPart alloc] initWithData:indata];
        [part setValue:[NSString stringWithFormat:@"form-data; name=\"%@\"", key]forHeaderKey:@"Content-Disposition"];
        [data.multiDataStream insertBodyPart:part];
    }
    
    return request;
};


QCloudRequestSerializerBlock QCloudFuseMultiFormData = ^(NSMutableURLRequest* request, QCloudRequestData* data, NSError* __autoreleasing*error)
{
    if(data.multiDataStream.hasData) {
        [data.multiDataStream setInitialAndFinalBoundaries];
        [request setHTTPBodyStream:(NSInputStream*)[QCloudWeakProxy proxyWithTarget:data.multiDataStream]];
        
        [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", data.multiDataStream.boundary] forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%llu", [data.multiDataStream contentLength]] forHTTPHeaderField:@"Content-Length"];
    }

    return request;
};


NSString* QCloudURLFuseAllPathComponents(NSArray* componets)
{
    NSString* path = @"";
    for (NSString* com  in componets) {
        if (com.length > 0) {
            path = QCloudPathJoin(path, com);
        }
    }
    path = QCloudPercentEscapedStringFromString(path);
    return path;
}

QCloudRequestSerializerBlock QCloudURLFuseSimple = ^(NSMutableURLRequest* request, QCloudRequestData* data, NSError* __autoreleasing*error) {
    NSMutableArray* coms = [NSMutableArray new];
    if(data.URIMethod.length) {
        [coms addObject:data.URIMethod];
    }
    if (data.URIComponents.count) {
        [coms addObjectsFromArray:data.URIComponents];
    }
    NSString* path = QCloudURLFuseAllPathComponents(coms);
    path =  QCloudPathJoin(data.serverURL, path);
    NSURL* url = [NSURL URLWithString:path];
    if (nil == url) {
        url = [NSURL URLWithString:QCloudURLEncodeUTF8(path)];
    }
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    return urlRequest;
};

QCloudRequestSerializerBlock QCloudURLFuseWithParamters = ^(NSMutableURLRequest* request, QCloudRequestData* data, NSError* __autoreleasing*error) {
  
    NSString* path = QCloudPathJoin(data.serverURL, data.URIMethod);
    path = QCloudURLAppendParamters(path, QCloudURLEncodeParamters(data.allParamters, NO,data.stringEncoding));
    NSURL* url = [NSURL URLWithString:path];
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    return urlRequest;
};

QCloudRequestSerializerBlock QCloudURLFuseWithJSONParamters =  ^(NSMutableURLRequest* request, QCloudRequestData* data, NSError* __autoreleasing*error) {
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data.allParamters options:NSJSONWritingPrettyPrinted error:error];
    if(*error) {
        return (NSMutableURLRequest*)nil;
    }
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Content-Type"];
    [request setValue:[@([jsonData length]) stringValue] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonData];
    return request;
};


QCloudRequestSerializerBlock QCloudURLFuseWithXMLParamters =  ^(NSMutableURLRequest* request, QCloudRequestData* data, NSError* __autoreleasing*error) {
    if(data.allParamters.count){
        NSString* str = [data.allParamters qcxml_XMLString];
        [request setValue:[NSString stringWithFormat:@"application/xml"] forHTTPHeaderField:@"Content-Type"];
        NSData* bodyData = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setValue:[@([bodyData length]) stringValue] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:bodyData];
    }
    return request;
};

QCloudRequestSerializerBlock QCloudURLFuseWithURLEncodeParamters = ^(NSMutableURLRequest* request, QCloudRequestData* data, NSError* __autoreleasing*error) {
    NSString* urlStr = nil;
    if (request.URL.absoluteString.length > 0) {
        urlStr = request.URL.absoluteString;
    } else {
        urlStr = QCloudPathJoin(data.serverURL, data.URIMethod);
    }
    urlStr = QCloudURLAppendParamters(urlStr, QCloudURLEncodeParamters(data.allParamters, YES, data.stringEncoding));
    NSURL* url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    return urlRequest;
};


QCloudRequestSerializerBlock QCloudURLFuseURIMethodASURLParamters = ^(NSMutableURLRequest* request, QCloudRequestData* data, NSError* __autoreleasing*error) {
    
    NSString* urlStr = nil;
    if (request.URL.absoluteString.length > 0) {
        urlStr = request.URL.absoluteString;
    } else {
        urlStr = data.serverURL;
        NSMutableArray* coms = [NSMutableArray new];
        if (data.URIComponents.count) {
            [coms addObjectsFromArray:data.URIComponents];
        }
        NSString* path = QCloudURLFuseAllPathComponents(coms);
        urlStr = QCloudPathJoin(urlStr, path);
    }
    
    NSMutableDictionary* methodParamters = [NSMutableDictionary new];
    if (data.URIMethod) {
        methodParamters[data.URIMethod] = @"";
        urlStr = QCloudURLAppendParamters(urlStr, QCloudURLEncodeParamters(methodParamters, YES, data.stringEncoding));
        if([urlStr hasSuffix:@"="]) {
            urlStr = [urlStr substringToIndex:urlStr.length -1];
        }
    }
    NSURL* url = [NSURL URLWithString:urlStr];
    if (!request) {
        request = [[NSMutableURLRequest alloc] initWithURL:url];
    } else {
        [request setURL:url];
    }
    return request;
};


QCloudRequestSerializerBlock QCloudURLFuseContentMD5Base64StyleHeaders = ^(NSMutableURLRequest* request, QCloudRequestData* data, NSError* __autoreleasing*error) {

    if (request.HTTPBody) {
        NSData* data = request.HTTPBody;
        NSString* md5 = QCloudEncrytNSDataMD5Base64(data);
        if (md5) {
            [request setValue:md5 forHTTPHeaderField:@"Content-MD5"];
        }
    } else if (data.directBody) {
        if ([data.directBody isKindOfClass:[NSData class]]) {
            NSData* md5data = data.directBody;
            NSString* md5 = QCloudEncrytNSDataMD5Base64(md5data);
            if (md5) {
                [request setValue:md5 forHTTPHeaderField:@"Content-MD5"];
            }
        } else if ([data.directBody isKindOfClass:[NSURL class]]) {
            NSString* md5 = QCloudEncrytFileMD5Base64([(NSURL*)data.directBody path]);
            if (md5) {
                [request setValue:md5 forHTTPHeaderField:@"Content-MD5"];
            }
        } else if ([data.directBody isKindOfClass:[QCloudFileOffsetBody class]]) {
            QCloudFileOffsetBody* body = (QCloudFileOffsetBody*)data.directBody;
            NSString* md5 = QCloudEncrytFileOffsetMD5Base64(body.fileURL.path, body.offset, body.sliceLength);
            if (md5) {
                [request setValue:md5 forHTTPHeaderField:@"Content-MD5"];
            }
        }
    }
    return request;
};


QCloudRequestSerializerBlock QCloudURLSerilizerHTTPHeaderParamters = ^(NSMutableURLRequest* request, QCloudRequestData* data, NSError* __autoreleasing*error) {
    NSDictionary* allParamters = data.allParamters;
    NSArray* allKeys = allParamters.allKeys;
    for(NSString* key in allKeys) {
        [request setValue:allParamters[key] forHTTPHeaderField:key];
    }
    return request;
};

QCloudRequestSerializerBlock QCloudURLSerilizerAppendURLParamters(NSDictionary* keyValueMaps) {
    return ^(NSMutableURLRequest* request, QCloudRequestData* data, NSError* __autoreleasing*error) {
        
        NSString* urlStr = nil;
        if (request.URL.absoluteString.length > 0) {
            urlStr = request.URL.absoluteString;
        } else {
            urlStr = QCloudPathJoin(data.serverURL, data.URIMethod);
        }
        urlStr = QCloudURLAppendParamters(urlStr, QCloudURLEncodeParamters(keyValueMaps, YES, data.stringEncoding));
        if ([urlStr hasSuffix:@"="]) {
            urlStr = [urlStr substringToIndex:urlStr.length-1];
        }
        NSURL* url = [NSURL URLWithString:urlStr];
        NSMutableURLRequest* urlRequest;
        if (request) {
            urlRequest = [request mutableCopy];
            [urlRequest setURL:url];
        } else {
           urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        }
        return urlRequest;
    };
}



QCloudRequestSerializerBlock QCloudURLSerilizerURLEncodingBody = ^(NSMutableURLRequest* request, QCloudRequestData* data, NSError* __autoreleasing*error) {
    NSDictionary* allParamters = data.allParamters;
    NSString* content = QCloudURLEncodeParamters(allParamters, YES, data.stringEncoding);
    NSData* contentData = [content dataUsingEncoding:data.stringEncoding];
    [request setHTTPBody:contentData];
    [request setValue:HTTPHeaderContentTypeURLEncode forHTTPHeaderField:HTTPHeaderContentType];
    [request setValue:[@(contentData.length)  stringValue] forHTTPHeaderField:@"Content-Length"];
    return request;
};


 QCloudRequestSerializerBlock QCloudURLCleanAllHeader =  ^(NSMutableURLRequest* request, QCloudRequestData* data, NSError* __autoreleasing*error) {
    [request setValue:nil forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:nil forHTTPHeaderField:@"Connection"];
    [request setValue:nil forHTTPHeaderField:@"Cookie"];
    [request setValue:@"" forHTTPHeaderField:HTTPHeaderUserAgent];
    return request;
};



static NSArray* QCloudHTTPReqeustSerializerObservedKeyPath() {
    static NSArray* paths = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        paths = @[
                  NSStringFromSelector(@selector(allowsCellularAccess)),
                  NSStringFromSelector(@selector(cachePolicy)),
                  NSStringFromSelector(@selector(HTTPShouldSetCookies)),
                  NSStringFromSelector(@selector(HTTPShouldUsePipelining)),
                  NSStringFromSelector(@selector(networkServiceType)),
                  NSStringFromSelector(@selector(timeoutInterval))
                  ];
        
    });
    return paths;
}

static void *QCloudHTTPRequestSerializerObserverContext = &QCloudHTTPRequestSerializerObserverContext;

@interface QCloudRequestSerializer ()
{
    NSMutableSet*           _mutableChangedPaths;
    NSDictionary*    _defaultHTTPHeaders;
}
@end

@implementation QCloudRequestSerializer
@synthesize shouldAuthentication = _shouldAuthentication;
- (void) dealloc
{
    for (NSString* selector in QCloudHTTPReqeustSerializerObservedKeyPath()) {
        if ([self respondsToSelector:NSSelectorFromString(selector)]) {
            @try {
                [self removeObserver:self forKeyPath:selector];
            } @catch (NSException *exception) {
                QCloudLogDebug(@"没有该观察者");
            }
        }
    }
}

- (void) __commonInit
{
    //
    _mutableChangedPaths    = [NSMutableSet new];
    for (NSString* keyPath in QCloudHTTPReqeustSerializerObservedKeyPath()) {
        if ([self respondsToSelector:NSSelectorFromString(keyPath)]) {
            [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:QCloudHTTPRequestSerializerObserverContext];
        }
    }
    //
    _HTTPMethod = HTTPMethodGET;
    _allowCompressedResponse = YES;
    _serializerBlocks = @[
                          QCloudURLFuseWithParamters
                          ];
    _HTTPDNSPrefetch = YES;
    _useCookies = YES;
    _shouldAuthentication = YES;
}

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    [self __commonInit];
    return self;
}


- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (context == QCloudHTTPRequestSerializerObserverContext) {
        if ([change[NSKeyValueChangeNewKey] isEqual:[NSNull null]]) {
            [_mutableChangedPaths removeObject:keyPath];
        } else {
            [_mutableChangedPaths addObject:keyPath];
        }
    }
}


- (NSMutableURLRequest*) requestWithData:(QCloudRequestData*)data error:(NSError* __autoreleasing*)error
{
    NSMutableURLRequest* request = [NSMutableURLRequest new];
    request.cachePolicy = self.cachePolicy;
    request.timeoutInterval = self.timeoutInterval;
    
    NSAssert(self.serializerBlocks.count != 0, @"没有添加任何的序列化匿名函数，请检查配置！！！");
    NSError* localError;
    for (QCloudRequestSerializerBlock sBlock in self.serializerBlocks) {
        
        request = sBlock(request,data, &localError);
        
        if (localError != nil) {
            if (error != NULL) {
                *error = localError;
            }
            return nil;
        }
    }

    if (!request || *error) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"com.tencent.qcloud.error" code:-1112 userInfo:@{NSLocalizedDescriptionKey:@"对request进行配置的时候出错，请检查所有的配置Block"}];
        }
        return nil;
    }
    request.HTTPMethod = self.HTTPMethod;
    //
    for (NSString* keyPath in QCloudHTTPReqeustSerializerObservedKeyPath()) {
        if ([_mutableChangedPaths containsObject:keyPath]) {
            [request setValue:[self valueForKey:keyPath] forKey:keyPath];
        }
    }
    //
    if (data.queryParamters.count > 0) {
        NSURL* url = request.URL;
        NSString* urlString = url.absoluteString;
        urlString = QCloudURLAppendParamters(urlString, QCloudURLEncodeParamters(data.queryParamters, YES, data.stringEncoding));
        url = [NSURL URLWithString:urlString];
        [request setURL:url];
    }
    //
    //http headers
    if (self.allowCompressedResponse) {
          [data setValue:@"Content-Encoding" forHTTPHeaderField:@"gzip"];
    }
    //
    NSDictionary* headers = [data.httpHeaders copy];
    NSArray* allKeys = headers.allKeys;
    for (NSString* key in allKeys) {
        [request setValue:headers[key] forHTTPHeaderField:key];
    }
    
    if (_useCookies && request.URL) {
        //Cokies填充
        NSArray* cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[request.URL absoluteURL]];
        cookies = QCloudFuseAndUpdateCookiesArray(data.cookies, cookies);
        NSDictionary* cookiesInfos =  [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
        [request setAllHTTPHeaderFields:cookiesInfos];
    }
    return request;
}


@end
