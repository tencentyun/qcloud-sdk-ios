//
//  DownloadTableViewCell.m
//  QCloudCOSXMLDemo
//
//  Created by erichmzhang(张恒铭) on 2017/7/24.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "DownloadTableViewCell.h"

@implementation DownloadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier ];
    self.cellContent = nil;
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellContent:(QCloudBucketContents *)cellContent {
    if (!cellContent) {
        return ;
    }
    [self.textLabel setText:cellContent.key];
    
    int count = 0;
    long size = cellContent.size;
    while (size>=1024 && count <6) {
        size = size / 1024;
        count++;
    }
    NSString *countDescription;
    switch (count) {
        case 0:
            countDescription = @"bytes";
            break;
        case 1:
            countDescription = @"KB";
            break;
        case 2:
            countDescription = @"MB";
            break;
        case 3:
            countDescription = @"GB";
            break;
        case 4:
            countDescription = @"TB";
            break;
        case 5:
            countDescription = @"PB";
        default:
            break;
    }
    [self.detailTextLabel setText:[NSString stringWithFormat:@"时间：%@ 大小:%ld%@",cellContent.lastModified,size,countDescription]];
}


@end
