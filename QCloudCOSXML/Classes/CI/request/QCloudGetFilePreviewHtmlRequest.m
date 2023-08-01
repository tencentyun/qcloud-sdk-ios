//
//  QCloudGetFilePreviewHtmlRequest.m
//  QCloudGetFilePreviewHtmlRequest
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.
//
//   ██████╗  ██████╗██╗      ██████╗ ██╗   ██╗██████╗     ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗         ██╗      █████╗
//   ██████╗
//  ██╔═══██╗██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║         ██║ ██╔══██╗██╔══██╗
//  ██║   ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║         ██║ ███████║██████╔╝
//  ██║▄▄ ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║         ██║ ██╔══██║██╔══██╗
//  ╚██████╔╝╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝       ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗    ███████╗██║
//  ██║██████╔╝
//   ╚══▀▀═╝  ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝        ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝    ╚══════╝╚═╝ ╚═╝╚═════╝
//
//
//                                                                              _             __                 _                _
//                                                                             (_)           / _|               | |              | |
//                                                          ___  ___ _ ____   ___  ___ ___  | |_ ___  _ __    __| | _____   _____| | ___  _ __   ___ _
//                                                          __ ___
//                                                         / __|/ _ \ '__\ \ / / |/ __/ _ \ |  _/ _ \| '__|  / _` |/ _ \ \ / / _ \ |/ _ \| '_ \ / _ \
//                                                         '__/ __|
//                                                         \__ \  __/ |   \ V /| | (_|  __/ | || (_) | |    | (_| |  __/\ V /  __/ | (_) | |_) |  __/
//                                                         |  \__
//                                                         |___/\___|_|    \_/ |_|\___\___| |_| \___/|_|     \__,_|\___| \_/ \___|_|\___/| .__/
//                                                         \___|_|  |___/
//    ______ ______ ______ ______ ______ ______ ______ ______                                                                            | |
//   |______|______|______|______|______|______|______|______|                                                                           |_|
//

#import "QCloudGetFilePreviewHtmlRequest.h"
#import <QCloudCore/QCloudSignatureFields.h>
#import <QCloudCore/QCloudCore.h>
#import <QCloudCore/QCloudServiceConfiguration_Private.h>
#import "QCloudGetFilePreviewHtmlResult.h"

NS_ASSUME_NONNULL_BEGIN
@implementation QCloudGetFilePreviewHtmlRequest
- (void)dealloc {
}
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.htmlrotate = 315;
    self.htmlhorizontal = 50;
    self.htmlvertical = 100;
    return self;
}
- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseURIMethodASURLParamters,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseDataAppendHeadersSerializerBlock, QCloudResponseObjectSerilizerBlock([QCloudGetFilePreviewHtmlResult class])

    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    [self.requestData setParameter:self.versionID withKey:@"versionId"];

    if (!self.object || ([self.object isKindOfClass:NSString.class] && ((NSString *)self.object).length == 0)) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[object] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }

    [self.requestData setQueryStringParamter:@"doc-preview" withKey:@"ci-process"];


    if (self.dstType != nil) {
        [self.requestData setQueryStringParamter:self.dstType withKey:@"dstType"];
    }else{
        [self.requestData setQueryStringParamter:@"html" withKey:@"dstType"];
    }
    
    if (self.weboffice_url == YES) {
        [self.requestData setQueryStringParamter:@"1" withKey:@"weboffice_url"];
    }
    
    if (self.disCopyable == YES) {
        [self.requestData setQueryStringParamter:@"0" withKey:@"copyable"];
    }else{
        [self.requestData setQueryStringParamter:@"1" withKey:@"copyable"];
    }
    
    if (self.htmlwaterword.length > 0) {
        [self.requestData setQueryStringParamter:[self base64EncodeString:self.htmlwaterword] withKey:@"htmlwaterword"];
        
        if (self.htmlfillstyle != nil) {
            [self.requestData setQueryStringParamter:self.htmlfillstyle withKey:@"htmlfillstyle"];
        }
        
        if (self.htmlfront != nil) {
        
            [self.requestData setQueryStringParamter:[self base64EncodeString:self.htmlfront] withKey:@"htmlfront"];
        }
    
        [self.requestData setQueryStringParamter:[NSString stringWithFormat:@"%ld",self.htmlrotate] withKey:@"htmlrotate"];
        [self.requestData setQueryStringParamter:[NSString stringWithFormat:@"%ld",self.htmlhorizontal] withKey:@"htmlhorizontal"];
        [self.requestData setQueryStringParamter:[NSString stringWithFormat:@"%ld",self.htmlvertical] withKey:@"htmlvertical"];
    
    }
    
    NSURL *__serverURL = [self.runOnService.configuration.endpoint serverURLWithBucket:self.bucket
                                                                                 appID:self.runOnService.configuration.appID
                                                                            regionName:self.regionName];
    self.requestData.serverURL = __serverURL.absoluteString;
    [self.requestData setValue:__serverURL.host forHTTPHeaderField:@"Host"];

    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    if (self.object)
        [__pathComponents addObject:self.object];
    self.requestData.URIComponents = __pathComponents;
    if (![self customBuildRequestData:error])
        return NO;
    for (NSString *key in self.customHeaders.allKeys.copy) {
        [self.requestData setValue:self.customHeaders[key] forHTTPHeaderField:key];
    }
    return YES;
}

- (BOOL)prepareInvokeURLRequest:(NSMutableURLRequest *)urlRequest error:(NSError * _Nullable __autoreleasing *)error{
    if (![super prepareInvokeURLRequest:urlRequest error:error]) {
        return NO;
    }
    
    NSString * sign = [NSString stringWithFormat:@"%@&x-cos-security-token=%@",urlRequest.allHTTPHeaderFields[@"Authorization"],urlRequest.allHTTPHeaderFields[@"x-cos-security-token"]];
    
    urlRequest.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@&sign=%@",urlRequest.URL.absoluteString,QCloudURLEncodeUTF8(sign)]];
    
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(QCloudGetFilePreviewHtmlResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

- (QCloudSignatureFields *)signatureFields {
    QCloudSignatureFields *fileds = [QCloudSignatureFields new];

    return fileds;
}
- (NSArray<NSMutableDictionary *> *)scopesArray {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *separatetmpArray = [self.requestData.serverURL componentsSeparatedByString:@"://"];
    NSString *str = separatetmpArray[1];
    NSArray *separateArray = [str componentsSeparatedByString:@"."];
    dic[@"bucket"] = separateArray[0];
    dic[@"region"] = self.runOnService.configuration.endpoint.regionName;
    dic[@"prefix"] = self.object;
    dic[@"action"] = @"name/cos:GetObject";
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:dic];
    return [array copy];
}

//- (NSString *)colorToString:(UIColor *)color {
//
//    CGFloat red, green, blue, alpha;
//#if SD_UIKIT
//    if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) {
//        [color getWhite:&red alpha:&alpha];
//        green = red;
//        blue = red;
//        alpha = 1;
//    }
//#else
//    @try {
//        [color getRed:&red green:&green blue:&blue alpha:&alpha];
//    }
//    @catch (NSException *exception) {
//        [color getWhite:&red alpha:&alpha];
//        green = red;
//        blue = red;
//        alpha = 1;
//    }
//#endif
//
//    red = roundf(red * 255.f);
//    green = roundf(green * 255.f);
//    blue = roundf(blue * 255.f);
//    alpha = round(alpha * 255.f);
//    uint hex = (((uint)red << 16) | ((uint)green << 8) | ((uint)blue));
//
//    return [self base64EncodeString:[NSString stringWithFormat:@"%06x", hex]];
//}

- (NSString *)base64EncodeString:(NSString *)string{
    NSData *data =[string dataUsingEncoding:NSUTF8StringEncoding];
    //2、对二进制数据进行base64编码，完成后返回字符串
    NSString * base64Str = [data base64EncodedStringWithOptions:0];
    
    base64Str = [base64Str stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    base64Str = [base64Str stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return base64Str;
}

@end
NS_ASSUME_NONNULL_END
