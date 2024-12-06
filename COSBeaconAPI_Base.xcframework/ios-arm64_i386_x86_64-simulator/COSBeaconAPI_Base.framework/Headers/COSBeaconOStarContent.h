//
//  COSBeaconOStarContent.h
//  COSBeaconAPI_Base
//
//  Created by 吴小二哥 on 2021/7/8.
//  Copyright © 2021 tencent.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface COSBeaconOStarContent : NSObject
/// o16，A3字段
@property (nonatomic, copy, nullable) NSString *o16;
/// o36,A153字段
@property (nonatomic, copy, nullable) NSString *o36;

- (instancetype)initWithO36:(NSString *)o36 withO16:(NSString *)o16;

@end

NS_ASSUME_NONNULL_END
