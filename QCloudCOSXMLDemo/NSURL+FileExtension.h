//
//  NSURL+FileExtension.h
//  QCloudCOSXMLDemo
//
//  Created by erichmzhang(张恒铭) on 26/04/2018.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (FileExtension)

- (unsigned long long)fileSizeInContent;
- (NSString*)fileSizeWithUnit ;
- (NSString*)fileSizeCount;
- (double)fileSizeSmallerThan1024;
@end
