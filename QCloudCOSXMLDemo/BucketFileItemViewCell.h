//
//  BucketFileItemViewCell.h
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2020/5/18.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@interface BucketFileItemViewCell : UITableViewCell

@property (nonatomic,strong)QCloudBucketContents *cellContent;

@property (nonatomic,copy)BlockOneParams deleteFile;

@property (nonatomic,copy)BlockOneParams downLoadFile;

-(void)setFileTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
