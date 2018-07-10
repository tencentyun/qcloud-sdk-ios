//
//  NSString+RegularExpressionCategory.m
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 29/06/2018.
//

#import "NSString+RegularExpressionCategory.h"

@implementation NSString (RegularExpressionCategory)
- (BOOL) matchesRegularExpression:(NSString *)regularExpression {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regularExpression];
    return [predicate evaluateWithObject:self];
}
@end
