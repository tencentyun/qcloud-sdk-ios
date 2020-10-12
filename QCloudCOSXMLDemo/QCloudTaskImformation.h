//
//  QCloudTaskImformation.h
//  QCloudCOSXMLDemo
//
//  Created by erichmzhang(张恒铭) on 26/04/2018.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCloudTaskImformation : NSObject

@property (nonatomic, assign) NSTimeInterval timeSpent;
@property (nonatomic, strong) NSString* fileName;
@property (nonatomic, strong) NSURL* fileURL;
@property (nonatomic, strong) NSData* fileData;

@end
