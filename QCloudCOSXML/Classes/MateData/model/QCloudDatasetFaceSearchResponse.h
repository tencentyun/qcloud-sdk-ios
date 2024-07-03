//
//  QCloudDatasetFaceSearchResponse.h
//  QCloudDatasetFaceSearchResponse
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
#import "QCloudCommonModel.h"

NS_ASSUME_NONNULL_BEGIN

@class QCloudFaceResult;
@class QCloudFaceBoundary;
@class QCloudFaceInfos;
@interface QCloudDatasetFaceSearchResponse : NSObject 

/// 人脸检索识别结果信息列表。
@property (nonatomic,strong)NSArray <QCloudFaceResult * > * FaceResult;

/// 请求 ID。
@property (nonatomic,strong) NSString * RequestId;

@end

@interface QCloudFaceResult : NSObject 

/// 相关人脸信息列表。;是否必传：否
@property (nonatomic,strong)NSArray <QCloudFaceInfos * > * FaceInfos;

/// 输入图片的人脸框位置。;是否必传：否
@property (nonatomic,strong) QCloudFaceBoundary * InputFaceBoundary;

@end

@interface QCloudFaceBoundary : NSObject 

/// 人脸高度。;是否必传：否
@property (nonatomic,assign) NSInteger Height;

/// 人脸宽度。;是否必传：否
@property (nonatomic,assign) NSInteger Width;

/// 人脸框左上角横坐标。;是否必传：否
@property (nonatomic,assign) NSInteger Left;

/// 人脸框左上角纵坐标。;是否必传：否
@property (nonatomic,assign) NSInteger Top;

@end

@interface QCloudFaceInfos : NSObject 

/// 自定义人物ID。;是否必传：否
@property (nonatomic,strong) NSString * PersonId;

/// 相关人脸框位置。;是否必传：否
@property (nonatomic,strong) QCloudFaceBoundary * FaceBoundary;

/// 人脸ID。;是否必传：否
@property (nonatomic,strong) NSString * FaceId;

/// 相关人脸匹配得分。;是否必传：否
@property (nonatomic,assign) NSInteger Score;

/// 资源标识字段，表示需要建立索引的文件地址。;是否必传：否
@property (nonatomic,strong) NSString * URI;

@end

@interface QCloudDatasetFaceSearch : NSObject 

/// 数据集名称，同一个账户下唯一。;是否必传：是
@property (nonatomic,strong) NSString * DatasetName;

/// 资源标识字段，表示需要建立索引的文件地址。;是否必传：是
@property (nonatomic,strong) NSString * URI;

/// 输入图片中检索的人脸数量，默认值为1(传0或不传采用默认值)，最大值为10。;是否必传：否
@property (nonatomic,assign) NSInteger MaxFaceNum;

/// 检索的每张人脸返回相关人脸数量，默认值为10，最大值为100。;是否必传：否
@property (nonatomic,assign) NSInteger Limit;

/// 限制返回人脸的最低相关度分数，只有超过 MatchThreshold 值的人脸才会返回。默认值为0，推荐值为80。 例如：设置 MatchThreshold 的值为80，则检索结果中仅会返回相关度分数大于等于80分的人脸。;是否必传：否
@property (nonatomic,assign) NSInteger MatchThreshold;

@end



NS_ASSUME_NONNULL_END
