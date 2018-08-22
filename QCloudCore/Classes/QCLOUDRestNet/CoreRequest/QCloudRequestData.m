//
//  QCloudRequestData.m
//  QCloudNetworking
//
//  Created by tencent on 15/9/24.
//  Copyright © 2015年 QCloudTernimalLab. All rights reserved.
//

#import "QCloudRequestData.h"
#import "NSError+QCloudNetworking.h"
#import "QCloudHTTPBodyPart.h"

#define ENSURE_NOT_NIL_PARAMTER(p) if(p==nil) return;
#define B_ENSURE_NOT_NIL_PARAMTER(p) if(p==nil) return NO;

NSDictionary* QCloudURLDecodePatamters(NSString* str)
{
    NSRange rangeOfQ = [str rangeOfString:@"?"];
    NSString* subStr = str;
    if (rangeOfQ.location != NSNotFound) {
        subStr = [str substringFromIndex:rangeOfQ.location + rangeOfQ.length];
    }
    NSArray* coms = [subStr componentsSeparatedByString:@"&"];
    if (coms.count == 0) {
        return nil;
    }
    
    NSMutableDictionary* paramters = [NSMutableDictionary new];
    for (NSString* s  in coms) {
        NSArray* kv = [s componentsSeparatedByString:@"="];
        if (kv.count != 2) {
            continue;
        }
        NSString* key = kv[0];
        NSString* value = kv[1];
        paramters[key] = value;
    }
    return paramters;
}

NSString* const HTTPHeaderUserAgent = @"User-Agent";

@interface QCloudRequestData ()
{
    NSMutableDictionary* _paramters;
    NSMutableDictionary* _httpHeaders;
    NSMutableDictionary* _queryParamters;
}
@end

@implementation QCloudRequestData
@synthesize multiDataStream = _multiDataStream;
- (void) loadDefaultHTTPHeaders
{
    static NSDictionary* httpHeaders;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#if TARGET_OS_IPHONE
        NSString*  userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
#elif TARGET_OS_MAC
        NSString*  userAgent = @"Test-Mac-Agent";
#endif
        httpHeaders = @{@"Connection":@"keep-alive",
                        HTTPHeaderUserAgent : userAgent};
    });
    _httpHeaders = [httpHeaders mutableCopy];
}
- (void) __dataCommonInit
{
    _paramters = [NSMutableDictionary new];
    _cookies = [NSMutableArray new];
    _stringEncoding = NSUTF8StringEncoding;
    _queryParamters = [NSMutableDictionary new];
    [self loadDefaultHTTPHeaders];
}
- (id)init {
    self = [super init];
    if (!self) {
        return self;
    }
    [self __dataCommonInit];
    return self;
}

- (NSDictionary*) queryParamters
{
    return [_queryParamters copy];
}

- (NSString*) URIMethod
{
    if (!_URIMethod) {
        return @"";
    } else {
        return _URIMethod;
    }
}
- (NSDictionary*) allParamters
{
    return [_paramters copy];
}

- (void) setParameter:(nonnull id)paramter withKey:(nonnull NSString*)key
{
#ifdef DEBUG
    NSParameterAssert(key);
#else
    ENSURE_NOT_NIL_PARAMTER(paramter);
#endif
    if (!paramter || [paramter isKindOfClass:[NSNull class]]) {
        return;
    }
    _paramters[key] = paramter;
}

- (void) setNumberParamter:(nonnull NSNumber*)paramter withKey:(nonnull NSString*)key
{
    [self setParameter:[paramter stringValue] withKey:key];
}

- (void)setQueryStringParamter:(nonnull NSString *)paramter withKey:(nonnull NSString*)key
{
    NSParameterAssert(key);
    if (!paramter || [paramter isKindOfClass:[NSNull class]]) {
        paramter = @"";
    }
    if (![paramter isKindOfClass:[NSString class]]) {
        paramter  = [NSString stringWithFormat:@"%@",paramter];
    }
    _queryParamters[key] = paramter;
    
}

- (void) setValue:(nonnull id)value forHTTPHeaderField:(nonnull NSString *)field
{
#ifdef DEBUG
    NSParameterAssert(field);
#else
    ENSURE_NOT_NIL_PARAMTER(field);
#endif
    [_httpHeaders setValue:value forKey:field];
}


- (void) addCookieWithDomain:(NSString *)domain path:(NSString *)path name:(NSString *)name value:(id)value
{
#ifdef DEBUG
    NSParameterAssert(domain);
    NSParameterAssert(path);
    NSParameterAssert(name);
    NSParameterAssert(value);
#else
    ENSURE_NOT_NIL_PARAMTER(domain);
    ENSURE_NOT_NIL_PARAMTER(path);
    ENSURE_NOT_NIL_PARAMTER(name);
    ENSURE_NOT_NIL_PARAMTER(value);
#endif
    NSDictionary* info = @{
                           NSHTTPCookieValue : value,
                           NSHTTPCookieName : name,
                           NSHTTPCookieDomain : domain,
                           NSHTTPCookiePath : path
                           };
    
    NSHTTPCookie* cookie = [NSHTTPCookie cookieWithProperties:info];
    
    NSMutableArray* cookies = [self.cookies mutableCopy];
    NSInteger index = NSNotFound;
    
    for (int i = 0; i < cookies.count; i++) {
        NSHTTPCookie* c = cookies[i];
        if ([c.domain isEqualToString:cookie.domain]
            && [c.path isEqualToString:cookie.path]
            && [c.name isEqualToString:cookie.name]) {
            index = i;
        }
    }
    
    if (index != NSNotFound) {
        [cookies replaceObjectAtIndex:index withObject:cookie];
    } else {
        [cookies addObject:cookie];
    }
    _cookies = cookies;
}

- (void) setParamatersWithString:(NSString*)paramters
{
    NSDictionary* dic = QCloudURLDecodePatamters(paramters);
    NSAssert(dic, @"paramters 字符串解析出现问题，没有成功解析出字典");
        if (dic) {
            for (NSString* key  in dic.allKeys) {
                [self setParameter:dic[key] withKey:key];
         }
    }
}


- (void) setParametersInDictionary:(NSDictionary *)paramters
{
    if (paramters) {
        for (NSString* key  in paramters.allKeys) {
            [self setParameter:paramters[key] withKey:key];
        }
    }
}


- (QCloudHTTPMultiDataStream*) multiDataStream
{
    if (!_multiDataStream) {
        _multiDataStream = [[QCloudHTTPMultiDataStream alloc] initWithStringEncoding:_stringEncoding];
        _multiDataStream.stringEncoding = _stringEncoding;
    }
    return _multiDataStream;
}



- (BOOL) appendFormDataKey:(NSString*)key
                     value:(NSString*)value
{
#ifdef DEBUG
    NSParameterAssert(key);
    NSParameterAssert(value);
#else
    B_ENSURE_NOT_NIL_PARAMTER(key);
    B_ENSURE_NOT_NIL_PARAMTER(value);
#endif
    if (![value isKindOfClass:[NSString class]]) {
        value = [NSString stringWithFormat:@"%@",value];
    }
    QCloudHTTPBodyPart* part = [[QCloudHTTPBodyPart alloc] initWithData:[value dataUsingEncoding:NSUTF8StringEncoding]];
    [part setValue:[NSString stringWithFormat:@"form-data; name=\"%@\"", key]forHeaderKey:@"Content-Disposition"];
    [[self multiDataStream] appendBodyPart:part];
    return YES;
    
}
- (BOOL)appendPartWithFileURL:(nonnull NSURL *)fileURL
                         name:(nonnull NSString *)name
                     fileName:(nonnull NSString *)fileName
                     mimeType:(nonnull NSString *)mimeType
              headerParamters:(nullable NSDictionary*)paramerts
                        error:(  NSError * _Nullable   __autoreleasing   *)error;
{
#ifdef DEBUG
    NSParameterAssert(fileURL);
    NSParameterAssert(name);
    NSParameterAssert(fileName);
    NSParameterAssert(mimeType);
#else
    B_ENSURE_NOT_NIL_PARAMTER(fileURL);
    B_ENSURE_NOT_NIL_PARAMTER(name);
    B_ENSURE_NOT_NIL_PARAMTER(fileName);
    B_ENSURE_NOT_NIL_PARAMTER(mimeType);
#endif
    
    if (![fileURL isFileURL]) {
        if (error) {
            *error = [NSError qcloud_errorWithCode:NSURLErrorBadURL message:NSLocalizedStringFromTable(@"Expected URL to be a file URL", @"QCloudNetworking", nil)];
        }
        
        return NO;
    } else if ([fileURL checkResourceIsReachableAndReturnError:error] == NO) {
        if (error) {
            *error = [NSError qcloud_errorWithCode:NSURLErrorBadURL message:[NSString stringWithFormat:@"File URL not reachable. %@", fileURL]];
        }
        return NO;
    }
    
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[fileURL path] error:error];
    if (!fileAttributes) {
        return NO;
    }
    
    QCloudHTTPBodyPart* part = [[QCloudHTTPBodyPart alloc] initWithURL:fileURL withContentLength:[fileAttributes[NSFileSize] unsignedLongLongValue]];

    [part setValue:[NSString stringWithFormat:@"form-data; name=\"%@\"; filename=\"%@\"", name, fileName]forHeaderKey:@"Content-Disposition"];
    
    [part setHeaderValueWithMap:paramerts];
    [part setValue:mimeType forHeaderKey:@"Content-Type"];
    
    [[self multiDataStream] appendBodyPart:part];
    
    return YES;
}

- (BOOL)appendPartWithFileURL:(nonnull NSURL *)fileURL
                         name:(nonnull NSString *)name
                     fileName:(nonnull NSString *)fileName
                       offset:(int64_t)offset
                  sliceLength:(int)sliceLength
                     mimeType:(nonnull NSString *)mimeType
              headerParamters:(nullable NSDictionary*)paramerts
                        error:(  NSError * _Nullable   __autoreleasing   *)error
{
#ifdef DEBUG
    NSParameterAssert(fileURL);
    NSParameterAssert(name);
    NSParameterAssert(fileName);
    NSParameterAssert(mimeType);
#else
    B_ENSURE_NOT_NIL_PARAMTER(fileURL);
    B_ENSURE_NOT_NIL_PARAMTER(name);
    B_ENSURE_NOT_NIL_PARAMTER(fileName);
    B_ENSURE_NOT_NIL_PARAMTER(mimeType);
#endif
    
    if (![fileURL isFileURL]) {
        if (error) {
            *error = [NSError qcloud_errorWithCode:NSURLErrorBadURL message:NSLocalizedStringFromTable(@"Expected URL to be a file URL", @"QCloudNetworking", nil)];
        }
        
        return NO;
    } else if ([fileURL checkResourceIsReachableAndReturnError:error] == NO) {
        if (error) {
            *error = [NSError qcloud_errorWithCode:NSURLErrorBadURL message:[NSString stringWithFormat:@"File URL not reachable. %@", fileURL]];
        }
        return NO;
    }
    
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[fileURL path] error:error];
    if (!fileAttributes) {
        return NO;
    }
    
    QCloudHTTPBodyPart* part = [[QCloudHTTPBodyPart alloc] initWithURL:fileURL offetSet:offset withContentLength:sliceLength ];
    [part setValue:[NSString stringWithFormat:@"form-data; name=\"%@\"; filename=\"%@\"", name, fileName]forHeaderKey:@"Content-Disposition"];
    
    [part setHeaderValueWithMap:paramerts];
    [part setValue:mimeType forHeaderKey:@"Content-Type"];
    
    [[self multiDataStream] appendBodyPart:part];
    
    return YES;
}


- (void) setStringEncoding:(NSStringEncoding)stringEncoding
{
    _stringEncoding = stringEncoding;
    _multiDataStream.stringEncoding = stringEncoding;
}

- (id) paramterForKey:(NSString *)key
{
    return [_paramters objectForKey:key];
}

- (void) removeHTTPHeaderForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    [_httpHeaders removeObjectForKey:key];
}


- (void)clean {
    _queryParamters = nil;
    self.stringEncoding = NSUTF8StringEncoding;
    _serverURL = nil;
    _URIMethod = nil;
    _URIComponents = nil;
    _httpHeaders = nil;
    _paramters = nil;
    _multiDataStream = nil;
    _boundary = nil;
    _cookies = nil;
    _directBody = nil;
    [self __dataCommonInit];
}

- (NSString*) description
{
    NSMutableString* str = [NSMutableString new];
    if (self.httpHeaders.count) {
        [str appendFormat:@"[HEADERS] \n%@\n" , self.httpHeaders];
    }
    if (self.allParamters.count) {
        [str appendFormat:@"[PARAMTERS] \n%@\n", self.allParamters];
    }
    if (self.multiDataStream.hasData) {
        [str appendFormat:@"[MULTIDATA] \n%@\n", self.multiDataStream];
    }
    return str;
}


@end
