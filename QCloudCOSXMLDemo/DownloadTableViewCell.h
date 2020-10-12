//
//  DownloadTableViewCell.h
//  QCloudCOSXMLDemo
//
//  Created by erichmzhang(张恒铭) on 2017/7/24.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QCloudCOSXML/QCloudCOSXML.h>
#import "QCloudCOSXMLContants.h"
@interface DownloadTableViewCell : UITableViewCell
@property (nonatomic, strong) QCloudBucketContents* cellContent;
@end
