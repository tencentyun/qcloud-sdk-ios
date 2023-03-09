//
//  QCloudSerializationCSV.m
//  QCloudSerializationCSV
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

#import "QCloudSerializationCSV.h"

NS_ASSUME_NONNULL_BEGIN
@implementation QCloudSerializationCSV

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"recordDelimiter" : @"RecordDelimiter",
        @"fieldDelimiter" : @"FieldDelimiter",
        @"quoteCharacter" : @"QuoteCharacter",
        @"quoteEscapeCharacter" : @"QuoteEscapeCharacter",
        @"inputAllowQuotedRecordDelimiter" : @"AllowQuotedRecordDelimiter",
        @"inputFileHeaderInfo" : @"FileHeaderInfo",
        @"inputComments" : @"Comments",
        @"quoteFields" : @"QuoteFields",
    };
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    NSNumber *fileHeaderInfo = dic[@"FileHeaderInfo"];
    if (fileHeaderInfo) {
        NSString *value = QCloudInputFileHeaderInfoTransferToString([fileHeaderInfo intValue]);
        if (value) {
            dic[@"FileHeaderInfo"] = value;
        }
    }
    NSNumber *quoteFields = dic[@"QuoteFields"];
    if (quoteFields) {
        NSString *value = QCloudOutputQuoteFieldsTransferToString([quoteFields intValue]);
        if (value) {
            dic[@"QuoteFields"] = value;
        }
    }

    return YES;
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];

    NSString *fileHeaderInfo = transfromDic[@"FileHeaderInfo"];
    if (fileHeaderInfo && [fileHeaderInfo isKindOfClass:[NSString class]] && fileHeaderInfo.length > 0) {
        NSInteger value = QCloudInputFileHeaderInfoDumpFromString(fileHeaderInfo);
        transfromDic[@"FileHeaderInfo"] = @(value);
    }
    NSString *quoteFields = transfromDic[@"QuoteFields"];
    if (quoteFields && [quoteFields isKindOfClass:[NSString class]] && quoteFields.length > 0) {
        NSInteger value = QCloudOutputQuoteFieldsDumpFromString(quoteFields);
        transfromDic[@"QuoteFields"] = @(value);
    }
    return transfromDic;
}

@end

NS_ASSUME_NONNULL_END
