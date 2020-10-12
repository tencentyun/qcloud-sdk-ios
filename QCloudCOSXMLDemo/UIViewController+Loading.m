//
//  UIViewController+Loadding.m
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2020/5/18.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "UIViewController+Loading.h"
#import <objc/runtime.h>

static NSString * indicatorViewKey = @"indicatorViewKey";

@implementation UIViewController (Loading)


-(void)setIndicatorView:(UIActivityIndicatorView *)indicatorView{
    objc_setAssociatedObject(self , &indicatorViewKey, indicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIActivityIndicatorView *)indicatorView{
    

    UIActivityIndicatorView * temp = objc_getAssociatedObject(self, &indicatorViewKey);
    if (temp == nil) {
        temp = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        temp.hidesWhenStopped = YES;
        temp.color = [UIColor blackColor];
        CGPoint centerPoint = CGPointMake(UIScreen.mainScreen.bounds.size.width / 2 , UIScreen.mainScreen.bounds.size.height / 2);
        temp.center = centerPoint;
        objc_setAssociatedObject(self , &indicatorViewKey, temp, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return temp;
}

@end
