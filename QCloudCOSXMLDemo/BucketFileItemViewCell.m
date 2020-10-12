//
//  BucketFileItemViewCell.m
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2020/5/18.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "BucketFileItemViewCell.h"
#import <NSDate+QCloudInternetDateTime.h>

@interface BucketFileItemViewCell ()
@property (strong, nonatomic) UILabel *labFileName;
@property (strong, nonatomic) UILabel *labFileCreateTime;
@property (strong, nonatomic) UILabel *labFileSize;
@property (strong, nonatomic) UIButton *btnDownload;
@property (strong, nonatomic) UIButton *btnDelete;

@end

@implementation BucketFileItemViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
      
      CGFloat margin = 16;
      CGFloat height = 30;
      
      _labFileName = [[UILabel alloc]initWithFrame:CGRectMake(margin, margin, SCREEN_WIDTH - margin * 2, height)];
      _labFileName.textColor = DEF_HEXCOLOR(0x333333);
      _labFileName.font = [UIFont systemFontOfSize:17];
      [self.contentView addSubview:_labFileName];
      
      _labFileCreateTime = [[UILabel alloc]initWithFrame:CGRectMake(margin, _labFileName.frame.origin.y + _labFileName.frame.size.height, SCREEN_WIDTH - margin * 3 - 120, 30)];
        _labFileCreateTime.textColor = DEF_HEXCOLOR(0x999999);
        _labFileCreateTime.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_labFileCreateTime];
      
      _labFileSize = [[UILabel alloc]initWithFrame:CGRectMake(_labFileCreateTime.frame.size.width + _labFileCreateTime.frame.origin.x + margin * 2, _labFileName.frame.origin.y + _labFileName.frame.size.height, 120, 30)];
           _labFileSize.textColor = DEF_HEXCOLOR(0x999999);
           _labFileSize.font = [UIFont systemFontOfSize:13];
           [self.contentView addSubview:_labFileSize];
      
      _btnDownload = [UIButton buttonWithType:UIButtonTypeCustom];
      _btnDownload.frame = CGRectMake(0, _labFileSize.frame.origin.y + _labFileSize.frame.size.height, SCREEN_WIDTH / 2, height);
      [_btnDownload setTitle:@"下载" forState:UIControlStateNormal];
      [_btnDownload setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
      [_btnDownload addTarget:self action:@selector(actionDownLoad:) forControlEvents:UIControlEventTouchUpInside];
      [self.contentView addSubview:_btnDownload];
      
      _btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
      _btnDelete.frame = CGRectMake(SCREEN_WIDTH / 2, _labFileSize.frame.origin.y + _labFileSize.frame.size.height, SCREEN_WIDTH / 2, height);
      [_btnDelete setTitle:@"删除" forState:UIControlStateNormal];
      [_btnDelete setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
      [_btnDelete addTarget:self action:@selector(actionDelete:) forControlEvents:UIControlEventTouchUpInside];
      [self.contentView addSubview:_btnDelete];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setCellContent:(QCloudBucketContents *)cellContent{
    _cellContent = cellContent;
    self.labFileName.text = cellContent.key;
    self.labFileSize.text = [NSString stringWithFormat:@"大小:%@",cellContent.fileSize];
    
    NSDate * date = [NSDate qcloud_dateFromRFC3339String:cellContent.lastModified];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *nowDateString = [dateFormatter stringFromDate:date];
    
    self.labFileCreateTime.text = [NSString stringWithFormat:@"创建时间：%@",nowDateString];
}

-(void)setFileTitle:(NSString *)title{
    self.labFileName.text = title;
}

- (void)actionDownLoad:(UIButton *)sender {
    self.downLoadFile(self.cellContent);
}

- (void)actionDelete:(UIButton *)sender {
    self.deleteFile(self.cellContent);
}

@end
