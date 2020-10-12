//
//  AppDelegate.h
//  QCloudCOSXMLDemo
//
//  Created by Dong Zhao on 2017/2/24.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completionHandler)();
@interface AppDelegate : UIResponder <UIApplicationDelegate>
/** 后台任务完成block */
@property (nonatomic, copy) completionHandler handler;
@property (strong, nonatomic) UIWindow *window;


@end

