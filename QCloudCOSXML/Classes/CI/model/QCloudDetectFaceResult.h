//
//  QCloudOpenAIBucketResult.h
//  QCloudCOSXML
//
//  Created by garenwang on 2022/8/23.
//

#import <Foundation/Foundation.h>
@class QCloudDetectFaceInfoResult;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudDetectFaceResult : NSObject

@property (nonatomic,assign)NSInteger ImageWidth;
@property (nonatomic,assign)NSInteger ImageHeight;
@property (nonatomic,strong)NSString * FaceModelVersion;
@property (nonatomic,strong)NSString * RequestId;
@property (nonatomic,strong)QCloudDetectFaceInfoResult * FaceInfos;

@end


@interface QCloudDetectFaceInfoResult : NSObject
@property (nonatomic,assign)NSInteger X;
@property (nonatomic,assign)NSInteger Y;
@property (nonatomic,assign)NSInteger Width;
@property (nonatomic,assign)NSInteger Height;
@end

NS_ASSUME_NONNULL_END
