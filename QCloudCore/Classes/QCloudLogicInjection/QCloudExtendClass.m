//
//  QCloudExtendClass.m
//  MagicRemind
//
//  Created by QCloudTernimalLab on 15/12/7.
//  Copyright © 2015年 dzpqzb. All rights reserved.
//

#import "QCloudExtendClass.h"
#import <objc/runtime.h>

@interface QCloudInjectionClassMapItem : NSObject
@property (nonatomic, strong) NSString* key;
@property (nonatomic, strong) Class originClass;
@end

@implementation QCloudInjectionClassMapItem
@end

@interface NSObject (QCloudInjectionLogicKey)
@property (nonatomic, strong) NSString* mr_injection_logic_key;
@end

@implementation NSObject(QCloudInjectionLogicKey)

static void * kQCloudInjectionClassMap = &kQCloudInjectionClassMap;

- (NSString*) mr_injection_logic_key
{
    return objc_getAssociatedObject(self, kQCloudInjectionClassMap);
}

- (void) setMr_injection_logic_key:(NSString *)mr_injection_logic_key
{
    objc_setAssociatedObject(self, kQCloudInjectionClassMap, mr_injection_logic_key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

NSString* const KQCloudExtendClassKey = @"__QCloud_EXTEND_";

Class QCloudExtendLogicCLass(Class baseClass, Class logicClass, NSString* key) {

    if (key.length == 0) {
        key = KQCloudExtendClassKey;
    }
    NSString* name = [key stringByAppendingString:NSStringFromClass(baseClass)];
    Class cla = NSClassFromString(name);
    if (!cla) {
        //alloc class pair
        cla = objc_allocateClassPair(baseClass, name.UTF8String, 0);
        //never try to add ivar to the new class, or you will find place using a wrong map.

        //register the class
        //
        objc_registerClassPair(cla);
    }
    [(id)cla setMr_injection_logic_key:key];
    unsigned int methodCount = 0;
    Method* logicMethodList= class_copyMethodList(logicClass, &methodCount);
    for (int i = 0; i < methodCount; i++) {
        Method m = logicMethodList[i];
        class_addMethod(cla, method_getName(m), method_getImplementation(m), method_copyReturnType(m));
    }
    return cla;
}

Class QCloudExtendClass(Class baseClass, NSArray* logicClasses, NSString* key) {
    Class aimCla ;
    for (Class cla  in logicClasses) {
        aimCla = QCloudExtendLogicCLass(baseClass, cla, key);
    }
    return aimCla;
}

id  QCloudExtendInstanceLogicWithKey(id object,NSString* logicKey,  NSArray* logicClasses) {
    if (!object) {
        return nil;
    }
    if (logicKey.length == 0) {
        return nil;
    }
    Class originClass = [object class];
    while ([(id)originClass mr_injection_logic_key]) {
        NSString* key = [(id)originClass mr_injection_logic_key];
        if ([key isEqualToString:logicKey]) {
            return object;
        }
        originClass = class_getSuperclass(originClass);
    }

    Class cla = QCloudExtendClass([object class], logicClasses, logicKey);
    object_setClass(object, cla);

    return object;
}

id  QCloudExtendInstanceLogic(id object, NSArray* logicClasses) {
    return QCloudExtendInstanceLogicWithKey(object, KQCloudExtendClassKey, logicClasses);
}

//wrong API, the method cached will cause crash, if you want to do this please remove the cached method
id QCloudRemoveExtendLogic(id object)
{
    if (!object) {
        return object;
    }
    Class cla = [object class];
    while ([(id)cla mr_injection_logic_key]) {
        cla = class_getSuperclass(cla);
    }
    if (cla) {
        Class originClass = cla;
        if (originClass) {
            object_setClass(object, originClass);
        }
    }
    return object;
}
//wrong API, the method cached will cause crash
id QCloudRemoveExtendSpecialLogic(id object, NSString* logicKey)
{
    if (!object) {
        return object;
    }
    Class startClass = nil;
    Class endClass = nil;

    Class claItor = [object class];
    Class claPrevious = nil;
    while ([(id)claItor mr_injection_logic_key]) {
        NSString* key = [(id)claItor mr_injection_logic_key];
        if ([key isEqualToString:logicKey]) {
            if (claPrevious) {
                startClass = claPrevious;
            }
        } else {
            if (startClass) {
                endClass = claItor;
                break;
            }
        }
        claPrevious = claItor;
        claItor = class_getSuperclass(claPrevious);
    }
    if (!endClass) {
        endClass = claItor;
    }
    object_setClass(object, endClass);
    return object;
}
