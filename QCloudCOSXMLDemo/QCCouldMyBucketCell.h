//
//  QCCouldMyBucketCell.h
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2020/5/15.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QCloudBucket;

NS_ASSUME_NONNULL_BEGIN

@interface QCCouldMyBucketCell : UITableViewCell
@property (nonatomic, strong) QCloudBucket* cellContent;
@end

NS_ASSUME_NONNULL_END
