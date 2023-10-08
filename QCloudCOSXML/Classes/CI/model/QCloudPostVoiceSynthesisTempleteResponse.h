//
//  QCloudPostVoiceSynthesisTempleteResponse.h
//  QCloudPostVoiceSynthesisTempleteResponse
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

@interface QCloudPostVoiceSynthesisTempleteResponse : NSObject 

/// 保存模板详情的容器
@property (nonatomic,strong) QCloudVoiceSynthesisTempleteResponseTemplate * Template;

/// 请求的唯一 ID
@property (nonatomic,strong) NSString * RequestId;

@end

@interface QCloudPostVoiceSynthesisTemplete : NSObject 

/// 模板类型：Tts;是否必传：是
@property (nonatomic,strong) NSString * Tag;

/// 模板名称，仅支持中文、英文、数字、_、-和*，长度不超过 64;是否必传：是
@property (nonatomic,strong) NSString * Name;

/// 处理模式Asyc（异步合成）Sync（同步合成）;是否必传：否
@property (nonatomic,strong) NSString * Mode;

/// 音频格式，支持 wav、mp3、pcm ;是否必传：否
@property (nonatomic,strong) NSString * Codec;

/// 音色，取值和限制介绍请见下表;是否必传：否
@property (nonatomic,strong) NSString * VoiceType;

/// 音量，取值范围 [-10,10];是否必传：否
@property (nonatomic,strong) NSString * Volume;

/// 语速，取值范围 [50,200];是否必传：否
@property (nonatomic,strong) NSString * Speed;

/// 情绪，不同音色支持的情绪不同，详见下表;是否必传：否
@property (nonatomic,strong) NSString * Emotion;

@end



NS_ASSUME_NONNULL_END
