//
//  QCloudAIIDCardOCRResponse.h
//  QCloudAIIDCardOCRResponse
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

#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>
#import "QCloudCICommonModel.h"

NS_ASSUME_NONNULL_BEGIN

@class QCloudAIIDCardOCRResponseAdvancedInfo;
@class QCloudAIIDCardOCRResponseIdInfo;
@interface QCloudAIIDCardOCRResponse : NSObject 

/// 身份证识别信息
@property (nonatomic,strong) QCloudAIIDCardOCRResponseIdInfo * IdInfo;

/// 扩展信息，不请求则不返回
@property (nonatomic,strong) QCloudAIIDCardOCRResponseAdvancedInfo * AdvancedInfo;

@end

@interface QCloudAIIDCardOCRResponseAdvancedInfo : NSObject 

/// 裁剪后身份证照片的 Base64 编码，设置 Config.CropIdCard 为 true 时返回
@property (nonatomic,strong) NSString * IdCard;

/// 身份证头像照片的 Base64 编码，设置 Config.CropPortrait 为 true 时返回
@property (nonatomic,strong) NSString * Portrait;

/// 图片质量分数，设置  Config.Quality 为 true 时返回（取值范围：0~100，分数越低越模糊，建议阈值≥50）
@property (nonatomic,strong) NSString * Quality;

/// 身份证边框不完整告警阈值分数，设置 Config.BorderCheckWarn 为 true 时返回（取值范围：0~100，分数越低边框遮挡可能性越低，建议阈值≥50）
@property (nonatomic,strong) NSString * BorderCodeValue;

/// 告警信息，Code 告警码列表和释义：9100 身份证有效日期不合法告警9101 身份证边框不完整告警9102 身份证复印件告警9103 身份证翻拍告警9104 临时身份证告警9105 身份证框内遮挡告警9106 身份证 PS 告警可能存在多个 WarnInfos
@property (nonatomic,strong) NSString * WarnInfos;

@end

@interface QCloudAIIDCardOCRResponseIdInfo : NSObject 

/// 姓名（人像面）
@property (nonatomic,strong) NSString * Name;

/// 性别（人像面）
@property (nonatomic,strong) NSString * Sex;

/// 民族（人像面）
@property (nonatomic,strong) NSString * Nation;

/// 出生日期（人像面）
@property (nonatomic,strong) NSString * Birth;

/// 地址（人像面）
@property (nonatomic,strong) NSString * Address;

/// 身份证号（人像面）
@property (nonatomic,strong) NSString * IdNum;

/// 发证机关（国徽面）
@property (nonatomic,strong) NSString * Authority;

/// 证件有效期（国徽面）
@property (nonatomic,strong) NSString * ValidDate;

@end



NS_ASSUME_NONNULL_END
