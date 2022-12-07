//
//  QCloudBodyRecognitionResult.h
//  QCloudCOSXML
//
//  Created by garenwang on 2022/8/23.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN


@interface QCloudBodyRecognitionLocation : NSObject

/// 人体坐标点（X坐标,Y坐标）
@property (nonatomic,strong)NSArray * Point;

@end


@interface QCloudBodyRecognitionPedestrianInfo : NSObject

/// 识别类型，人体识别默认：person
@property (nonatomic,strong)NSString * Name;

/// 人体的置信度，取值范围为[0-100]。值越高概率越大。
@property (nonatomic,strong)NSString * Score;

/// 图中识别到人体的坐标
@property (nonatomic,strong)QCloudBodyRecognitionLocation * Location;

@end

@interface QCloudBodyRecognitionResult : NSObject

/// 人体识别结果。0表示未识别到，1表示识别到
@property (nonatomic,assign)NSInteger  Status;

/// 人体识别结果，可能有多个
@property (nonatomic,strong)QCloudBodyRecognitionPedestrianInfo * PedestrianInfo;

@end


NS_ASSUME_NONNULL_END
