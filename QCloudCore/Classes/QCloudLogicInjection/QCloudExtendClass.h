//
//  QCloudExtendClass.h
//  MagicRemind
//
//  Created by QCloudTernimalLab on 15/12/7.
//  Copyright © 2015年 dzpqzb. All rights reserved.
//

#import <Foundation/Foundation.h>

Class QCloudExtendClass(Class baseClass, NSArray* logicClasses, NSString* key);
id QCloudExtendInstanceLogic(id object, NSArray* logicClasses);
id  QCloudExtendInstanceLogicWithKey(id object,NSString* logicKey,  NSArray* logicClasses);
id QCloudRemoveExtendLogic(id object);
id QCloudRemoveExtendSpecialLogic(id object, NSString* logicKey);
