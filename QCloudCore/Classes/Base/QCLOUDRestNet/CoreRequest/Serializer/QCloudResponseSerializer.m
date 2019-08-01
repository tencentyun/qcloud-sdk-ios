//
//  QCloudResponseSerializer.m
//  QCloudNetworking
//
//  Created by tencent on 15/9/25.
//  Copyright © 2015年 QCloudTernimalLab. All rights reserved.
//

#import "QCloudResponseSerializer.h"
#import "QCloudLogger.h"
#import "NSError+QCloudNetworking.h"
#import "QCloudObjectModel.h"
#import "QCloudXMLDictionary.h"

typedef id (^QCloudResponseSerializerBlock)(NSHTTPURLResponse* response,  id inputData, NSError* __autoreleasing* error);

QCloudResponseSerializerBlock QCloudResponseXMLSerializerBlock = ^(NSHTTPURLResponse* response,  id inputData, NSError* __autoreleasing* error)
{
    QCloudLogDebug(@"response  %@",response);
    if(![inputData isKindOfClass:[NSData class]]) {
        if (NULL != error) {
            *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeResponseDataTypeInvalid message:[NSString stringWithFormat:@"ServerError:XML解析器读入的数据不是NSData"]];
        }
        return (id)nil;
    }
    if ([(NSData*)inputData length] == 0) {
        NSDictionary* emptyDictionary = [[NSDictionary alloc] init];
        return  (id)emptyDictionary;
    }
   
#ifdef DEBUG
    NSString* xmlString = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
    QCloudLogDebug(@"XML RESPONSE:%@",xmlString);
#endif
    QCloudXMLDictionaryParser* parser = [QCloudXMLDictionaryParser new];
    
    NSDictionary* output = [parser dictionaryWithData:inputData];
    
    if(!output) {
        if (NULL != error) {
            *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeResponseDataTypeInvalid message:[NSString stringWithFormat:@"ServerError:尝试解析XML类型数据出错:\n%@", [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding]]];
        }
        return (id)nil;
    }
    return (id)output;
};


QCloudResponseSerializerBlock QCloudResponseAppendHeadersSerializerBlock = ^(NSHTTPURLResponse* response,  id inputData, NSError* __autoreleasing* error)
{
    NSMutableDictionary* allDatas = [NSMutableDictionary new];
    if ([inputData isKindOfClass:[NSDictionary class]]) {
        [allDatas addEntriesFromDictionary:(NSDictionary*)inputData];
    }
    [allDatas addEntriesFromDictionary:response.allHeaderFields];

    return (id)allDatas;
};


QCloudResponseSerializerBlock QCloudAcceptRespnseCodeBlock(NSSet* acceptCode, Class errorModel) {
    return ^(NSHTTPURLResponse* response,  id inputData, NSError* __autoreleasing* error) {

        void(^LoadDefaultError)(void) = ^() {
            NSString* errorMessage = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
            errorMessage = errorMessage?:[NSString stringWithFormat:@"不接受该HTTP StatusCode %ld", (long)response.statusCode];
            if (error != NULL) {
                *error = [NSError qcloud_errorWithCode:(int) response.statusCode message:errorMessage];
            }
        };
        if ([acceptCode containsObject:@(response.statusCode)]) {
            return inputData;
        } else {
            NSString* contentType = [response.allHeaderFields objectForKey:@"Content-Type"];
            NSDictionary* userInfo = nil;
            if (contentType) {
                if ([contentType.lowercaseString containsString:@"application/json"]) {
                    NSError* localError = nil;
                    NSDictionary* map = [NSJSONSerialization JSONObjectWithData:inputData options:0 error:&localError];
                    if (localError) {
                        LoadDefaultError();
                    } else {
                        userInfo = map;
                    }
                } else if ([contentType.lowercaseString containsString:@"application/xml"]) {
                    QCloudXMLDictionaryParser* parser = [QCloudXMLDictionaryParser new];
                    NSDictionary* output = [parser dictionaryWithData:inputData];
                    if (output) {
                        userInfo = output;
                    }
                }
            }
            
            if (userInfo) {
                if (!errorModel) {
                    if (error != NULL) {
                        *error = [NSError errorWithDomain:kQCloudNetworkDomain code:response.statusCode userInfo:userInfo];
                    }
                    return (id)nil;
                }
                if ([errorModel respondsToSelector:@selector(toError:)]) {
                    if (error != NULL) {
                        *error = [errorModel toError:userInfo];
                    }
                } else {
                    LoadDefaultError();
                }
            }
            if ((error != NULL) && !(*error)) {
                LoadDefaultError();
            }
            return (id)nil;
        }
    };
}



QCloudResponseSerializerBlock QCloudResponseJSONSerilizerBlock = ^(NSHTTPURLResponse* response,  id inputData, NSError* __autoreleasing* error) {
    if (![inputData isKindOfClass:[NSData class]]) {
        if(error != NULL) {
            *error = [NSError errorWithDomain:@"com.tencent.networking" code:-1404 userInfo:@{NSLocalizedDescriptionKey:@"数据非法，请传入合法数据"}];
        }
        return (id)nil;
    }
    NSDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:inputData options:0 error:error];
    if(*error || !jsonObject) {
        NSString* str = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
        QCloudLogError(@"response data is %@", str);
        return (id)nil;
    }
    QCloudLogDebug(@"GET JSON : \n %@", jsonObject);
    return (id)(jsonObject);
};
            
            


@interface QCloudResponseSerializer ()
{
    NSMutableArray* _serializerBlocks;
}
@end


@implementation QCloudResponseSerializer

- (void) __responseCommonInit
{
    _serializerBlocks = [NSMutableArray new];
    [_serializerBlocks addObject:QCloudAcceptRespnseCodeBlock([NSSet setWithArray:@[@(200)]], nil)];
    [_serializerBlocks addObject:QCloudResponseJSONSerilizerBlock];
    _waitForBodyData = YES;
}
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    [self __responseCommonInit];
    return self;
}

- (id) decodeWithWithResponse:(NSHTTPURLResponse*)response data:(NSData*)data error:(NSError*__autoreleasing*)error
{
    NSError* localError;
    id output = data;
    for (QCloudResponseSerializerBlock block in _serializerBlocks) {
        output = block(response, output, &localError);
        if (localError) {
            if (error != NULL) {
                *error = localError;
            }
            return nil;
        }
    }
    return output;
}

@end
