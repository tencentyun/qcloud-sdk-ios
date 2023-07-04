//
//  QCloudRecognitionBadCaseRequest.h
//  QCloudRecognitionBadCaseRequest
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//
//   ██████╗  ██████╗██╗      ██████╗ ██╗   ██╗██████╗     ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗         ██╗      █████╗ ██████╗
//  ██╔═══██╗██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║         ██║     ██╔══██╗██╔══██╗
//  ██║   ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║         ██║     ███████║██████╔╝
//  ██║▄▄ ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║         ██║     ██╔══██║██╔══██╗
//  ╚██████╔╝╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝       ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗    ███████╗██║  ██║██████╔╝
//   ╚══▀▀═╝  ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝        ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝    ╚══════╝╚═╝  ╚═╝╚═════╝
//
//
//                                                                              _             __                 _                _
//                                                                             (_)           / _|               | |              | |
//                                                          ___  ___ _ ____   ___  ___ ___  | |_ ___  _ __    __| | _____   _____| | ___  _ __   ___ _ __ ___
//                                                         / __|/ _ \ '__\ \ / / |/ __/ _ \ |  _/ _ \| '__|  / _` |/ _ \ \ / / _ \ |/ _ \| '_ \ / _ \ '__/ __|
//                                                         \__ \  __/ |   \ V /| | (_|  __/ | || (_) | |    | (_| |  __/\ V /  __/ | (_) | |_) |  __/ |  \__
//                                                         |___/\___|_|    \_/ |_|\___\___| |_| \___/|_|     \__,_|\___| \_/ \___|_|\___/| .__/ \___|_|  |___/
//    ______ ______ ______ ______ ______ ______ ______ ______                                                                            | |
//   |______|______|______|______|______|______|______|______|                                                                           |_|
//



#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>
#import "QCloudRecognitionBadCaseRequest.h"
NS_ASSUME_NONNULL_BEGIN
/**
 本接口用于提交一个内容审核的Bad Case，例如被判定为正常的涉黄图片或者被判定为涉黄的正常图片。
 
 ### 示例

   @code
 
    
 
*/
@interface QCloudRecognitionBadCaseRequest: QCloudBizHTTPRequest

/// 存储桶名称
@property (strong, nonatomic) NSString * bucket;

/// 需要反馈的数据类型，取值为：1-文本，2-图片  必传：是
@property (assign, nonatomic) NSInteger contentType;

/// 文本的Badcase，需要填写base64的文本内容，ContentType为1时必填
@property (strong, nonatomic) NSString * text;

/// 图片的Badcase，需要填写图片的url链接，ContentType为2时必填
@property (strong, nonatomic) NSString * url;

/// 审核给出的有问题的结果标签  必传：是
@property (strong, nonatomic) NSString * label;

/// 期望的正确处置标签，正常则填Normal  必传：是
@property (strong, nonatomic) NSString * suggestedLabel;

/// 该Case对应的审核任务ID，有助于定位审核记录
@property (strong, nonatomic) NSString * jobId;

/// 该Case的审核时间，有助于定位审核记录。格式为 2021-08-07T12:12:12+08:0
@property (strong, nonatomic) NSString * moderationTime;

@end

NS_ASSUME_NONNULL_END
