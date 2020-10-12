//
//  NSString+UINCategory.m
//  QCloudCOSXMLDemo
//
//  Created by erichmzhang(张恒铭) on 2017/7/20.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "NSString+UINCategory.h"

@implementation NSString(UINCategory)
/**
 新接口ACL identifier格式
 
 @param ID 根账号
 @param subAccountID 子账号
 @return 拼接成的String
 */
+ (NSString*)identifierStringWithID:(NSString*)ID :(NSString*)subAccountID {
    return [NSString stringWithFormat:@"qcs::cam::uin/%@:uin/%@",ID,subAccountID];
}

/**
 旧接口的 ACL identifier格式
 
 @param ID 根账号ID
 @param subAccountID 子账号ID
 @return 拼接成的String
 */
+ (NSString*)oldIdentifierStringWithID:(NSString*)ID :(NSString*)subAccountID {
    return [NSString stringWithFormat:@"%@/%@",ID,subAccountID];
}

@end

