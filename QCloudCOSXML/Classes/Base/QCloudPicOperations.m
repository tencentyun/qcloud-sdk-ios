//
//  QCloudPutObjectWatermarkInfo.m
//  Pods-QCloudCOSXMLDemo
//
//  Created by garenwang on 2020/6/4.
//

#import "QCloudPicOperations.h"
#import <QCloudCore/QCloudLogger.h>
#import <QCloudCore/QCloudCore.h>
#import "NSString+RegularExpressionCategory.h"

@implementation QCloudPicOperations

- (NSString *)getPicOperationsJson {
    if ([self getRules] == nil) {
        return nil;
    }

    NSDictionary *dicOperations = @{ @"is_pic_info" : _is_pic_info ? @(1) : @(0), @"rules" : [self getRules] };
    QCloudLogInfo(@"水印生成成功————%@", [dicOperations qcloud_modelToJSONString]);
    return [dicOperations qcloud_modelToJSONString];
}

- (NSArray *)getRules {
    NSMutableArray *rules = [NSMutableArray arrayWithCapacity:0];
    for (QCloudPicOperationRule *item in _rule) {
        if (item.rule == nil) {
            return nil;
        }

        if (item.fileid == nil) {
            QCloudLogError(@"[%@]QCloudPicOperationRule的fileid不能为空", self.class);
            return nil;
        }

        [rules addObject:@{ @"fileid" : item.fileid, @"rule" : item.rule }];
    }
    if (rules.count > 5) {
        return [rules subarrayWithRange:NSMakeRange(0, 5)];
    }
    return rules.copy;
}

@end

@implementation QCloudPicOperationRule

- (NSString *)rule {
    //    直接指定rule；若无指定，则按照用户输入生成rule;
    if (_rule != nil) {
        return _rule;
    }

    if (_type == 0 || _type > 3) {
        QCloudLogError(@"水印类型错误");
        return nil;
    }
    
    NSMutableString *strRule = [NSMutableString stringWithFormat:@"%@", [NSString stringWithFormat:@"watermark/%lu/type",(unsigned long)self.actionType]];

    [strRule appendFormat:@"/%ld", _type];

    if (_type == QCloudPicOperationRuleFull || _type == QCloudPicOperationRuleHalf) {
        if (_imageURL == nil) {
            QCloudLogError(@"[%@]生成水印错误————半盲和全盲水印必须指定图片链接", self.class);
            return nil;
        }
        NSData *data = [_imageURL dataUsingEncoding:NSUTF8StringEncoding];
        NSString *base64ImageUrl = [data base64EncodedStringWithOptions:0];
        [strRule appendFormat:@"/image/%@", base64ImageUrl];
        if (_type == QCloudPicOperationRuleFull) {
            if (_level < 1) {
                [strRule appendString:@"/level/1"];
            } else if (_level > 3) {
                [strRule appendString:@"/level/3"];
            } else {
                [strRule appendFormat:@"/level/%ld", _level];
            }
        }
    } else {
        if (_text == nil) {
            QCloudLogError(@"[%@]文本型水印请传入水印文字", self.class);
            return nil;
        }

        if (![_text matchesRegularExpression:@"[a-zA-Z0-9]+"]) {
            QCloudLogError(@"[%@]文本型水印的文本仅支持[a-zA-Z0-9]", self.class);
            return nil;
        }

        [strRule appendFormat:@"/text/%@", _text];
    }

    return strRule;
}

@end
