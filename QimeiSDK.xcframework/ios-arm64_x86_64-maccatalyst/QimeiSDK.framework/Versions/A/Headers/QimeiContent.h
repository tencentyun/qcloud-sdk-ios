//
//  QimeiContent.h
//  QimeiSDK
//
//  Created by pariszhao on 2020/9/27.
//  Copyright © 2020 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//Qimei的具体内容载体
@interface QimeiContent : NSObject

/// 旧Qimei，A3字段, q16
@property (nonatomic, copy, readonly, nullable) NSString *qimeiOld;
/// 新Qimei,A153字段, q36
@property (nonatomic, copy, readonly, nullable) NSString *qimeiNew;

@end

NS_ASSUME_NONNULL_END
