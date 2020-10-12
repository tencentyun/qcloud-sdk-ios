//
//  NSString+UINCategory.h
//  QCloudCOSXMLDemo
//
//  Created by erichmzhang(张恒铭) on 2017/7/20.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(UINCategory)
+ (NSString*)identifierStringWithID:(NSString*)ID :(NSString*)subAccountID ;
+ (NSString*)oldIdentifierStringWithID:(NSString*)ID :(NSString*)subAccountID ;
@end
