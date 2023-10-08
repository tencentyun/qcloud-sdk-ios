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

/// 存储桶 ID
@property (nonatomic,strong) NSString * BucketId;

/// 存储桶名称，同 BucketId
@property (nonatomic,strong) NSString * Name;

/// 所在的地域
@property (nonatomic,strong) NSString * Region;

/// 创建时间
@property (nonatomic,strong) NSString * CreateTime;
@end

NS_ASSUME_NONNULL_END
