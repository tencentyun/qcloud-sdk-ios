//
//  QCloudSHAPart.h
//  Pods
//
//  Created by Dong Zhao on 2017/3/8.
//
//

#import <UIKit/UIKit.h>
#import "QCloudModel.h"
@interface QCloudSHAPart : QCloudModel
@property (nonatomic, strong) NSString* sha;
@property (nonatomic, assign) uint64_t offset;
@property (nonatomic, assign) uint64_t length;
@end
