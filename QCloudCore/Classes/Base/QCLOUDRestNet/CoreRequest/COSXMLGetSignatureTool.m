//
//  COSXMLCSPGetSignatureHelper.m
//  QCloudCSPDemo
//
//  Created by karisli(李雪) on 2018/9/20.
//  Copyright © 2018年 karisli(李雪). All rights reserved.
//

#import "COSXMLGetSignatureTool.h"

#import "QCloudRequestSerializer.h"
#import "QCloudLogger.h"
#import "QCloudURLHelper.h"
#import <QCloudCore/QCloudError.h>
@implementation NSDictionary(HeaderFilter)
- (NSDictionary*)filterHeaders; {
    NSMutableDictionary* signedHeaders = [[NSMutableDictionary alloc] init];
    __block  const NSArray* shouldSignedHeaderList = @[ @"Content-Length", @"Content-MD5"];
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
@implementation NSURL(QCloudCSPExtension)

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

- (NSString*)qcloud_csp_path {
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
@implementation COSXMLGetSignatureTool
+(instancetype)sharedNewtWorkTool
{
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

-(void)PutRequestWithUrl:(NSString *)urlString request:(NSMutableURLRequest* )urlRequest successBlock:(SuccessBlock)success;
{
    //取出参数
    NSDictionary* headers = [[urlRequest allHTTPHeaderFields] filterHeaders];
    NSDictionary* paramas = QCloudURLReadQuery(urlRequest.URL);
    NSMutableDictionary *paramaters = [NSMutableDictionary dictionary];
    paramaters[@"path"] = urlRequest.URL.qcloud_csp_path;
    paramaters[@"method"] = urlRequest.HTTPMethod;
    paramaters[@"host"] = urlRequest.URL.host;
    paramaters[@"headers"] = headers;
    paramaters[@"params"] = paramas;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    request.HTTPMethod = @"PUT";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:paramaters options:NSJSONWritingPrettyPrinted error:nil]];
    
    NSLog(@"request Body:  %@",[[NSString alloc]initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        QCloudLogDebug(@"response data:%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        if (data && !error) {
            id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (!obj) {
                 @throw [NSException exceptionWithName:QCloudErrorDomain reason:@"返回的不是json数据" userInfo:nil];
            }
            NSDictionary *dic = (NSDictionary *)obj;
            QCloudLogDebug(@"%@ 的签名%@",urlRequest.URL,dic[@"sign"]);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    success(obj[@"sign"]);
                }
            });
        }else
        {
            @throw [NSException exceptionWithName:QCloudErrorDomain reason:@"获取签名错误" userInfo:nil];
        }
        
    }] resume];
    
}
@end
