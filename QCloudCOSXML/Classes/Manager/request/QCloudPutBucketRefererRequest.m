//
//  QCloudPutBucketRefererRequest.m
//  QCloudPutBucketRefererRequest
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
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

#import "QCloudPutBucketRefererRequest.h"
#import <QCloudCore/QCloudSignatureFields.h>
#import <QCloudCore/QCloudCore.h>
#import <QCloudCore/QCloudConfiguration_Private.h>
#import "QCloudBucketRefererInfo.h"

NS_ASSUME_NONNULL_BEGIN
@implementation QCloudPutBucketRefererRequest
- (void)dealloc {
}
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    return self;
}
- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseURIMethodASURLParamters,
        QCloudURLFuseWithXMLParamters,
        QCloudURLFuseContentMD5Base64StyleHeaders,
        
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"put";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    if (self.refererType == 0) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:@"paramter[refererType] is invalid (0), it must have some value. please check it"]];
            return NO;
        }
    }
    
    
    if (self.status == 0) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:@"paramter[status] is invalid (0), it must have some value. please check it"]];
            return NO;
        }
    }
    
    if (self.domainList.count == 0) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:@"paramter[domainList] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    
    NSDictionary * params = @{
        @"Status":QCloudBucketRefererStatusTransferToString(self.status),
        @"RefererType":QCloudBucketRefererTypeTransferToString(self.refererType),
        @"DomainList":@{
                @"Domain":self.domainList
        },
        @"EmptyReferConfiguration":QCloudBucketRefererConfigurationTransferToString(self.configuration)
        
                          };
    [self.requestData setParameter:params withKey:@"RefererConfiguration"];
    
    NSURL *__serverURL = [self.runOnService.configuration.endpoint serverURLWithBucket:self.bucket
                                                                                 appID:self.runOnService.configuration.appID
                                                                            regionName:self.regionName];
    self.requestData.serverURL = __serverURL.absoluteString;
    [self.requestData setValue:__serverURL.host forHTTPHeaderField:@"Host"];
    

    self.requestData.URIMethod = @"referer";
    return YES;
}

- (QCloudSignatureFields *)signatureFields {
    QCloudSignatureFields *fileds = [QCloudSignatureFields new];
    return fileds;
}


QCloudBucketRefererType QCloudBucketRefererTypeFromString(NSString *key) {
    if ([key isEqualToString:@"Black-List"]) {
        return QCloudBucketRefererTypeBlackList;
    } else if ([key isEqualToString:@"White-List"]) {
        return QCloudBucketRefererTypeWhiteList;
    }
    return 0;
}

NSString *QCloudBucketRefererTypeTransferToString(QCloudBucketRefererType type) {
    switch (type) {
        case QCloudBucketRefererTypeBlackList: {
            return @"Black-List";
        }
        case QCloudBucketRefererTypeWhiteList: {
            return @"White-List";
        }
        default:
            return nil;
    }
}

QCloudBucketRefererStatus QCloudBucketRefererStatusFromString(NSString *key) {
    if ([key isEqualToString:@"Enabled"]) {
        return QCloudBucketRefererStatusEnabled;
    } else if ([key isEqualToString:@"Disabled"]) {
        return QCloudBucketRefererStatusDisabled;
    }
    return 0;
}

NSString *QCloudBucketRefererStatusTransferToString(QCloudBucketRefererStatus type) {
    switch (type) {
        case QCloudBucketRefererStatusEnabled: {
            return @"Enabled";
        }
        case QCloudBucketRefererStatusDisabled: {
            return @"Disabled";
        }
        default:
            return nil;
    }
}

QCloudBucketRefererConfiguration QCloudBucketRefererConfigurationFromString(NSString *key) {
    if ([key isEqualToString:@"Allow"]) {
        return QCloudBucketRefererConfigurationAllow;
    } else if ([key isEqualToString:@"Deny"]) {
        return QCloudBucketRefererConfigurationDeny;
    }
    return 0;
}

NSString *QCloudBucketRefererConfigurationTransferToString(QCloudBucketRefererConfiguration type) {
    switch (type) {
        case QCloudBucketRefererConfigurationAllow: {
            return @"Allow";
        }
        case QCloudBucketRefererConfigurationDeny: {
            return @"Deny";
        }
        default:
            return nil;
    }
}


@end

NS_ASSUME_NONNULL_END

