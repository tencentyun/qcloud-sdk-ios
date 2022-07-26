//
//  QCloudGetAudioOpenBucketListResult.h
//  QCloudCOSXML
//
//  Created by garenwang on 2022/7/25.
//

#import <Foundation/Foundation.h>
@class QCloudGetAudioOpenAsrBucketList;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudGetAudioOpenBucketListResult : NSObject

///  请求的唯一 ID
@property (nonatomic,strong)NSString * RequestId;

///  媒体 Bucket 总数
@property (nonatomic,assign)NSInteger TotalCount;

///  当前页数，同请求中的 pageNumber
@property (nonatomic,assign)NSInteger PageNumber;

///  每页个数，同请求中的 pageSize
@property (nonatomic,assign)NSInteger PageSize;

///  语音 Bucket 列表
@property (nonatomic,strong)NSArray <QCloudGetAudioOpenAsrBucketList *> * AsrBucketList;

@end

@interface QCloudGetAudioOpenAsrBucketList : NSObject


/// 存储桶 ID
@property (nonatomic,strong)NSString * BucketId;

/// 存储桶名称，同 BucketId
@property (nonatomic,strong)NSString * Name;

/// 所在的地域
@property (nonatomic,strong)NSString * Region;

/// 创建时间
@property (nonatomic,strong)NSString * CreateTime;

@end

NS_ASSUME_NONNULL_END
