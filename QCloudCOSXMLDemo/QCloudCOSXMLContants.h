//
//  QCloudCOSXMLContants.h
//  QCloudCOSXMLDemo
//
//  Created by Dong Zhao on 2017/6/11.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef QCloudCOSXMLContants_h
#define QCloudCOSXMLContants_h

#define QCloudUploadBukcet @"bucketcanbedelete120"

#define kRegion @"ap-guangzhou"

//设置RGB颜色/设置RGBA颜色
#define DEF_RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define DEF_RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define DEF_HEXCOLOR(rgbValue)      [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define DEF_HEXCOLORA(rgbValue, a)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

//屏幕尺寸
#define SCREEN_SIZE                 [UIScreen mainScreen].bounds.size
#define SCREEN_HEIGHT               ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH                ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_FRAME                (CGRectMake(0, 0 ,SCREEN_WIDTH,SCREEN_HEIGHT))
#define SCREEN_WIDTH_RATIO(width)   (SCREEN_WIDTH / 375) * (width)

//弱引用/强引用
#define DEF_WeakSelf(type)          __weak typeof(type) weak##type = type;
#define DEF_StrongSelf(type)        __strong typeof(type) type = weak##type;


#define CURRENT_BUCKET   [QCloudCOSXMLConfiguration sharedInstance].currentBucket
#define CURRENT_SERVICE  [QCloudCOSXMLConfiguration sharedInstance].currentService
#define CURRENT_REGION   [QCloudCOSXMLConfiguration sharedInstance].currentRegion
#define CURRENT_TRANSFER_MANAGER  [QCloudCOSXMLConfiguration sharedInstance].currentTransferManager

typedef void(^BlockNoParams)();

typedef void(^BlockOneParams)(NSObject * obj);

typedef void(^BlockTwoParams)(NSObject * obj1,NSObject * obj2);

#define LAYOUT_HEIGHT 30

#define LAYOUT_MARGIN 12

#endif /* QCloudCOSXMLContants_h */
