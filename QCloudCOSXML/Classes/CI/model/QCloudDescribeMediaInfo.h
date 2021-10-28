//
//  QCloudDescribeMediaInfo.h
//  QCloudCOSXML
//
//  Created by garenwang on 2021/10/28.
//

#import <Foundation/Foundation.h>
@class QCloudDescribeMediaBucketItem;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudDescribeMediaInfo : NSObject

/// 媒体 Bucket 总数
@property (nonatomic,strong)NSString * TotalCount;
@property (nonatomic,strong)NSString * PageNumber;
@property (nonatomic,strong)NSString * PageSize;

/// 媒体 Bucket 列表
@property (nonatomic,strong)NSArray <QCloudDescribeMediaBucketItem *> * MediaBucketList;
@end

@interface QCloudDescribeMediaBucketItem : NSObject

/// 存储桶 ID
@property (nonatomic,strong)NSString * BucketId;

/// 存储桶名称，同BucketId
@property (nonatomic,strong)NSString * Name;

/// 所在的地域
@property (nonatomic,strong)NSString * Region;

/// 创建时间
@property (nonatomic,strong)NSString * CreateTime;
@end
NS_ASSUME_NONNULL_END

    
    
    
    
