//
//  QCloudNetResponse.h
//  Pods
//
//  Created by Dong Zhao on 2017/3/9.
//
//


#import "QCloudModel.h"
@interface QCloudNetResponse : QCloudModel
@property (nonatomic, assign) int code;
@property (nonatomic, strong) NSString* request_id;
@property (nonatomic, strong) NSDictionary* data;
@property (nonatomic, strong) NSString* message;
@end
