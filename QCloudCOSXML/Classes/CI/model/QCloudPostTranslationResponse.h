//
//  QCloudPostTranslationResponse.h
//  QCloudPostTranslationResponse
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

@class QCloudPostTranslationResponseJobsDetail;
@class QCloudPostTranslationInput;
@class QCloudPostTranslationResponseOperation;
@class QCloudPostTranslationOutput;
@class QCloudPostTranslationResponseAITranslateResult;
@class QCloudPostTranslationTranslation;
@class QCloudPostTranslationOperation;
@interface QCloudPostTranslationResponse : NSObject 

/// 任务的详细信息
@property (nonatomic,strong)NSArray <QCloudPostTranslationResponseJobsDetail * > * JobsDetail;

@end

@interface QCloudPostTranslationResponseJobsDetail : NSObject 

/// 错误码，只有 State 为 Failed 时有意义
@property (nonatomic,strong) NSString * Code;

/// 错误描述，只有 State 为 Failed 时有意义
@property (nonatomic,strong) NSString * Message;

/// 创建任务的 ID
@property (nonatomic,strong) NSString * JobId;

/// 创建任务的 Tag：Translation
@property (nonatomic,strong) NSString * Tag;

/// 任务状态Submitted：已提交，待执行Running：执行中Success：执行成功Failed：执行失败Pause：任务暂停，当暂停队列时，待执行的任务会变为暂停状态Cancel：任务被取消执行
@property (nonatomic,strong) NSString * State;

/// 任务的创建时间
@property (nonatomic,strong) NSString * CreationTime;

/// 任务的开始时间
@property (nonatomic,strong) NSString * StartTime;

/// 任务的结束时间
@property (nonatomic,strong) NSString * EndTime;

/// 任务所属的 队列 ID﻿
@property (nonatomic,strong) NSString * QueueId;

/// 同请求中的 Request.Input 节点
@property (nonatomic,strong) QCloudPostTranslationInput * Input;

/// 该任务的规则
@property (nonatomic,strong) QCloudPostTranslationResponseOperation * Operation;

@end

@interface QCloudPostTranslationInput : NSObject 

/// 源文档文件名单文件（docx/xlsx/html/markdown/txt）：不超过800万字符有页数的（pdf/pptx）：不超过300页文本文件（txt）：不超过10MB二进制文件（pdf/docx/pptx/xlsx）：不超过60MB图片文件（jpg/jpeg/png/webp）：不超过10MB;是否必传：是
@property (nonatomic,strong) NSString * Object;

/// 文档语言类型zh：简体中文zh-hk：繁体中文zh-tw：繁体中文zh-tr：繁体中文en：英语ar：阿拉伯语de：德语es：西班牙语fr：法语id：印尼语it：意大利语ja：日语pt：葡萄牙语ru：俄语ko：韩语km：高棉语lo：老挝语;是否必传：是
@property (nonatomic,strong) NSString * Lang;

/// 文档类型pdfdocxpptxxlsxtxtxmlhtml：只能翻译 HTML 里的文本节点，需要通过 JS 动态加载的不进行翻译markdownjpgjpegpngwebp;是否必传：是
@property (nonatomic,strong) NSString * Type;

/// 原始文档类型仅在 Type=pdf/jpg/jpeg/png/webp 时使用，当值为pdf时，仅支持 docx、pptx当值为jpg/jpeg/png/webp时，仅支持txt;是否必传：否
@property (nonatomic,strong) NSString * BasicType;

@end

@interface QCloudPostTranslationResponseOperation : NSObject 

/// 同请求中的 Request.Operation.Translation
@property (nonatomic,strong) QCloudPostTranslationTranslation * Translation;

/// 同请求中的 Request.Operation.Output
@property (nonatomic,strong) QCloudPostTranslationOutput * Output;

/// 透传用户信息
@property (nonatomic,strong) NSString * UserData;

/// 任务优先级
@property (nonatomic,strong) NSString * JobLevel;

/// 翻译结果详情
@property (nonatomic,strong) QCloudPostTranslationResponseAITranslateResult * AITranslateResult;

@end

@interface QCloudPostTranslationOutput : NSObject 

/// 存储桶的地域;是否必传：是
@property (nonatomic,strong) NSString * Region;

/// 存储结果的存储桶;是否必传：是
@property (nonatomic,strong) NSString * Bucket;

/// 输出结果的文件名;是否必传：是
@property (nonatomic,strong) NSString * Object;

@end

@interface QCloudPostTranslationResponseAITranslateResult : NSObject 

/// 翻译结果内容
@property (nonatomic,strong) NSString * Result;

@end

@interface QCloudPostTranslationTranslation : NSObject 

/// 目标语言类型源语言类型为 zh/zh-hk/zh-tw/zh-tr 时支持：en、ar、de、es、fr、id、it、ja、it、ru、ko、km、lo、pt源语言类型为 en 时支持：zh、zh-hk、zh-tw、zh-tr、ar、de、es、fr、id、it、ja、it、ru、ko、km、lo、pt其他类型时支持：zh、zh-hk、zh-tw、zh-tr、en;是否必传：是
@property (nonatomic,strong) NSString * Lang;

/// 文档类型，源文件类型与目标文件类型映射关系如下：docx：docxpptx：pptxxlsx：xlsxtxt：txtxml：xmlhtml：htmlmarkdown：markdownpdf：pdf、docxpng：txtjpg：txtjpeg：txtwebp：txt;是否必传：是
@property (nonatomic,strong) NSString * Type;

@end

@interface QCloudPostTranslation : NSObject 

/// 创建任务的 Tag：Translation;是否必传：是
@property (nonatomic,strong) NSString * Tag;

/// 待操作的对象信息;是否必传：是
@property (nonatomic,strong) QCloudPostTranslationInput * Input;

/// 操作规则;是否必传：是
@property (nonatomic,strong) QCloudPostTranslationOperation * Operation;

/// 任务回调格式，JSON 或 XML，默认 XML，优先级高于队列的回调格式;是否必传：否
@property (nonatomic,strong) NSString * CallBackFormat;

/// 任务回调类型，Url 或 TDMQ，默认 Url，优先级高于队列的回调类型;是否必传：否
@property (nonatomic,strong) NSString * CallBackType;

/// 任务回调地址，优先级高于队列的回调地址。设置为 no 时，表示队列的回调地址不产生回调;是否必传：否
@property (nonatomic,strong) NSString * CallBack;

/// 任务回调TDMQ配置，当 CallBackType 为 TDMQ 时必填。详情见 CallBackMqConfig;是否必传：否
@property (nonatomic,strong) QCloudCallBackMqConfig * CallBackMqConfig;

@end

@interface QCloudPostTranslationOperation : NSObject 

/// 翻译参数;是否必传：是
@property (nonatomic,strong) QCloudPostTranslationTranslation * Translation;

/// 结果输出地址，当NoNeedOutput为true时非必选;是否必传：否
@property (nonatomic,strong) QCloudPostTranslationOutput * Output;

/// 透传用户信息，可打印的 ASCII 码，长度不超过1024;是否必传：否
@property (nonatomic,strong) NSString * UserData;

/// 任务优先级，级别限制：0 、1 、2 。级别越大任务优先级越高，默认为0;是否必传：否
@property (nonatomic,strong) NSString * JobLevel;

/// 仅输出结果，不生成结果文件。取值：true/false。该参数原文档类型为图片时有效。默认值 false;是否必传：否
@property (nonatomic,strong) NSString * NoNeedOutput;

@end



NS_ASSUME_NONNULL_END
