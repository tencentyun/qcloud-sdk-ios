//
//  QCCouldMyBucketCell.m
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2020/5/15.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "QCCouldMyBucketCell.h"
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <NSDate+QCloudInternetDateTime.h>

@implementation QCCouldMyBucketCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier ];
    
    self.textLabel.font = [UIFont systemFontOfSize:18];
    self.detailTextLabel.font = [UIFont systemFontOfSize:13];
    self.textLabel.textColor = DEF_HEXCOLOR(0x333333);
    self.detailTextLabel.textColor = DEF_HEXCOLOR(0x999999);
    
    self.textLabel.text = @"";
    self.detailTextLabel.text = @"";
    self.textLabel.numberOfLines = 0;
    self.detailTextLabel.numberOfLines = 0;
    
    return self;
}

- (void)setCellContent:(QCloudBucket *)cellContent{
    
    self.textLabel.text = [NSString stringWithFormat:@"名称：%@",cellContent.name];
    NSDate * date = [NSDate qcloud_dateFromRFC3339String:cellContent.createDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *nowDateString = [dateFormatter stringFromDate:date];

    self.detailTextLabel.text = [NSString stringWithFormat:@"创建时间：%@\n地区：%@",nowDateString,cellContent.location];
}

@end
