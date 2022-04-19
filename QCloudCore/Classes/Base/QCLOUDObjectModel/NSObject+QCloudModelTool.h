//
//  NSObject+QCloudModelTool.h
//  QCloudCore
//
//  Created by karisli(李雪) on 2021/8/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (QCloudModelTool)
+ (NSArray *)jsonsToModelsWithJsons:(NSArray *)jsons;
@end

NS_ASSUME_NONNULL_END
