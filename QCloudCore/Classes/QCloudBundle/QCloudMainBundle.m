//
//  QCloudMainBundle.m
//  Pods
//
//  Created by Dong Zhao on 2017/3/20.
//
//

#import "QCloudMainBundle.h"


NSBundle* QCloudMainBundle() {
    static NSBundle* bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString* path = [[NSBundle mainBundle] pathForResource:@"QCloudBundle" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:path];
    });
    return bundle;
}

