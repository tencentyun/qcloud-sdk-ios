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
    NSNumber *InputFileHeaderInfoenumValue = dic[@"FileHeaderInfo"];
    if (InputFileHeaderInfoenumValue) {
        NSString *value = QCloudInputFileHeaderInfoTransferToString([InputFileHeaderInfoenumValue intValue]);
        if (value) {
            dic[@"FileHeaderInfo"] = value;
        }
    }
    NSNumber *OutputQuoteFieldsenumValue = dic[@"QuoteFields"];
    if (OutputQuoteFieldsenumValue) {
        NSString *value = QCloudOutputQuoteFieldsTransferToString([OutputQuoteFieldsenumValue intValue]);
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

    NSString *InputFileHeaderInfoenumValue = transfromDic[@"FileHeaderInfo"];
    if (InputFileHeaderInfoenumValue && [InputFileHeaderInfoenumValue isKindOfClass:[NSString class]] && InputFileHeaderInfoenumValue.length > 0) {
        NSInteger value = QCloudInputFileHeaderInfoDumpFromString(InputFileHeaderInfoenumValue);
        transfromDic[@"FileHeaderInfo"] = @(value);
    }
    NSString *OutputQuoteFieldsenumValue = transfromDic[@"QuoteFields"];
    if (OutputQuoteFieldsenumValue && [OutputQuoteFieldsenumValue isKindOfClass:[NSString class]] && OutputQuoteFieldsenumValue.length > 0) {
        NSInteger value = QCloudOutputQuoteFieldsDumpFromString(OutputQuoteFieldsenumValue);
        transfromDic[@"QuoteFields"] = @(value);
    }
    return transfromDic;
}

@end

NS_ASSUME_NONNULL_END
