//
//  QCloudFileMultiPart.h
//  Pods
//
//  Created by Dong Zhao on 2017/3/7.
//
//

#import <Foundation/Foundation.h>

@interface QCloudFileMultiPart : NSObject
@property (nonatomic, strong) NSString*     bucket;
@property (nonatomic, strong) NSString*     filePath;
@property (nonatomic, assign) int64_t       offset;
@property (nonatomic, strong) NSString*     fileName;
@property (nonatomic, strong) NSString*     sign;
@end
