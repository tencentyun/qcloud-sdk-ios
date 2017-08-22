//
//  DZProgrameDefines.h
//  TimeUI
//
//  Created by Stone Dong on 14-1-21.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFINE_PROPERTY_KEY(key)  static void const   kPK##key = &kPK##key

/**
    * 定义字符串
 */
#define DEFINE_NSString(str)  static NSString* const kDZ##str = @""#str;

#define DEFINE_NSStringValue(str, value) static NSString* const kDZ##str = @""#value;

#define DEFINE_NOTIFICATION_MESSAGE(str) static NSString* const kDZNotification_##str = @""#str;

#define DEFINE_PROPERTY_READONLY(mnmKind, type , name) @property (nonatomic, mnmKind, readonly )  type  name

#define DEFINE_PROPERTY(mnmKind, type , name) @property (nonatomic, mnmKind)  type  name
#define DEFINE_PROPERTY_ASSIGN(type, name) DEFINE_PROPERTY(assign, type, name)
#define DEFINE_PROPERTY_ASSIGN_Float(name) DEFINE_PROPERTY_ASSIGN(float, name)
#define DEFINE_PROPERTY_ASSIGN_INT64(name) DEFINE_PROPERTY_ASSIGN(int64_t, name)
#define DEFINE_PROPERTY_ASSIGN_INT32(name) DEFINE_PROPERTY_ASSIGN(int32_t, name)
#define DEFINE_PROPERTY_ASSIGN_INT16(name) DEFINE_PROPERTY_ASSIGN(int16_t, name)
#define DEFINE_PROPERTY_ASSIGN_INT8(name) DEFINE_PROPERTY_ASSIGN(int8_t, name)
#define DEFINE_PROPERTY_ASSIGN_Double(name) DEFINE_PROPERTY_ASSIGN(double, name)
#define DEFINE_PROPERTY_ASSIGN_BOOL(name) DEFINE_PROPERTY_ASSIGN(BOOL, name)

#define DEFINE_PROPERTY_STRONG_READONLY(type, name) DEFINE_PROPERTY_READONLY(strong, type, name)

#define DEFINE_PROPERTY_STRONG(type, name) DEFINE_PROPERTY(strong, type, name)
#define DEFINE_PROPERTY_STRONG_UILabel(name) DEFINE_PROPERTY_STRONG(UILabel*, name)
#define DEFINE_PROPERTY_STRONG_NSString(name) DEFINE_PROPERTY_STRONG(NSString*, name)

#define DEFINE_PROPERTY_STRONG_NSDate(name) DEFINE_PROPERTY_STRONG(NSDate*, name)
#define DEFINE_PROPERTY_STRONG_NSArray(name) DEFINE_PROPERTY_STRONG(NSArray*, name)
#define DEFINE_PROPERTY_STRONG_UIImageView(name) DEFINE_PROPERTY_STRONG(UIImageView*, name)
#define DEFINE_PROPERTY_STRONG_UIButton(name) DEFINE_PROPERTY_STRONG(UIButton*, name)


#define INIT_SUBVIEW(sView, class, name) name = [[class alloc] init]; [sView addSubview:name];
#define INIT_SUBVIEW_UIImageView(sView, name) INIT_SUBVIEW(sView, UIImageView, name)
#define INIT_SUBVIEW_UILabel(sView, name) INIT_SUBVIEW(sView, UILabel, name)

#define INIT_SUBVIEW_UIButton(sView, name) name =[UIButton buttonWithType:UIButtonTypeCustom]; [sView addSubview:name];

#define INIT_SELF_SUBVIEW(class, name) INIT_SUBVIEW(self, class , name)
#define INIT_SELF_SUBVIEW_UIImageView(name) INIT_SUBVIEW_UIImageView(self, name)
#define INIT_SELF_SUBVIEW_UILabel(name) INIT_SUBVIEW_UILabel(self, name)


#define DEFINE_PROPERTY_WEAK(type, name) DEFINE_PROPERTY(weak, type, name)

/**
   初始化一个点击的手势
      @param name   点击手势的名称
   @param view   要添加手势的视图的名称
   @param taps   需要的点击次数
   @param touchs 需要的手指数量
    */
#define INIT_GESTRUE_TAP_IN_VIEW(name, view, taps, touchs)  name=[[UITapGestureRecognizer alloc] init];\
name.numberOfTapsRequired = 1;\
name.numberOfTouchesRequired = 1;\
[view addGestureRecognizer:name];

/**
   在当前视图上初始化一个点击手势
 */
#define INIT_GESTRUE_TAP_IN_SELF(name, taps, touchs) INIT_GESTRUE_TAP_IN_VIEW(name, self, taps, touchs)


#define DEFINE_DZ_EXTERN_STRING(key) extern NSString* const  key;
#define INIT_DZ_EXTERN_STRING(key , value) NSString* const key = @""#value;



#define DZ_CheckObjcetClass(object, cla) [object isKindOfClass:[cla class]]

/**
   数据类型的转化
 */

#define DZ_STR_2_URL(str)   ( ([str hasPrefix:@"http"] || !str )? [NSURL URLWithString:str] : [NSURL fileURLWithPath:str])
#define DZ_NUM_2_STR(num) [@(num) stringValue]


//Notification defaults


FOUNDATION_EXTERN Class DZGetCurrentClassInvocationSEL(NSString*  functionString);

FOUNDATION_EXTERN BOOL DZCheckSuperResponseToSelector(Class cla, SEL selector);

#define __SEL_CLASS__  DZGetCurrentClassInvocationSEL([NSString stringWithFormat:@"%s",__FUNCTION__])
#define __DZSuperResponseCMD__ DZCheckSuperResponseToSelector(__SEL_CLASS__, _cmd) 


#define DZExternObserverMessage(msg) \
void DZAddObserverFor##msg (NSObject* ob, SEL selector);\
void DZRemoveObserverFor##msg (NSObject* ob);\
void DZPost##msg (NSDictionary* dic);\


#define DZObserverMessage(message) \
void DZAddObserverFor##message (NSObject* ob, SEL selector) { \
[[NSNotificationCenter defaultCenter] addObserver:ob selector:selector name:@""#message object:nil]; \
}\
\
void DZRemoveObserverFor##message (NSObject* ob) {\
[[NSNotificationCenter defaultCenter] removeObserver:ob name:@""#message object:nil];\
}\
\
void DZPost##message (NSDictionary* dic) {\
[[NSNotificationCenter defaultCenter] postNotificationName:@""#message object:nil userInfo:dic];\
}


FOUNDATION_EXTERN void  DZEnsureMainThread(void(^mainSafeBlock)());


#define  DZEnsureMainThreadBegin  DZEnsureMainThread(^{

#define  DZEnsureMainThreadEnd  });



#pragma mark ----

#define bQCloudSystemVersion(min, max) ([UIDevice currentDevice].systemVersion.doubleValue >= min) && ([UIDevice currentDevice].systemVersion.doubleValue <=max)
#define bQCloudSystemVersion8 bQCloudSystemVersion(8.0, 8.999)
