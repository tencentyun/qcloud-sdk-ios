//
//  NSMutableURLRequest+COS.h
//  QCloudCore
//
//  Created by garenwang on 2025/4/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLRequest (COS)
@property (nonatomic, strong) NSArray *shouldSignedList;
@end

NS_ASSUME_NONNULL_END
