//
//  QCloudOpenAIBucketResult.h
//  QCloudCOSXML
//
//  Created by garenwang on 2022/8/23.
//

#import <Foundation/Foundation.h>
@class QCloudOpenAIBucketAiBucket;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudOpenAIBucketResult : NSObject

@property (nonatomic,strong)QCloudOpenAIBucketAiBucket * AiBucket;
@property (nonatomic,strong)NSString * RequestId;

@end


@interface QCloudOpenAIBucketAiBucket : NSObject
@property (nonatomic,strong)NSString * BucketId;
@property (nonatomic,strong)NSString * CreateTime;
@property (nonatomic,strong)NSString * Name;
@property (nonatomic,strong)NSString * Region;
@end

NS_ASSUME_NONNULL_END
