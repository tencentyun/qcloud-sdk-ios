//
//  BeaconQimei.h
//  BeaconAPI_Base
//
//  Created by jackhuali on 2014/4/8.
//  Copyright © 2014 tencent.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BeaconQimei : NSObject

/// 旧Qimei，A3字段
@property (nonatomic, copy, nullable) NSString *qimeiOld;
/// 新Qimei,A153字段
@property (nonatomic, copy, nullable) NSString *qimeiNew;
/// qimei的json形式
@property (nonatomic, copy, nullable) NSString *qimeiJson;

- (instancetype)initWithQimeiJson:(NSString *)qimeiJson;

@end

NS_ASSUME_NONNULL_END
