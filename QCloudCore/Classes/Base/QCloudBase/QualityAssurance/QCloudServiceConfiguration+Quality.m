//
//  QCloudServiceConfiguration+Quality.m
//  QCloudCore
//
//  Created by karisli(李雪) on 2022/1/18.
//

#import "QCloudServiceConfiguration+Quality.h"
#import <objc/runtime.h>
@implementation QCloudServiceConfiguration (Quality)
NSString *const disableSetupBeaconKey = @"disableBeaconKey";

-(void)setDisableSetupBeacon:(BOOL)disableSetupBeacon{
    objc_setAssociatedObject(self, &disableSetupBeaconKey, [NSNumber numberWithBool:disableSetupBeacon], OBJC_ASSOCIATION_ASSIGN);
}
-(BOOL)disableSetupBeacon{
    //因为在set方法中转成了number类型,所以这里需要转成Bool类型
    return [objc_getAssociatedObject(self, &disableSetupBeaconKey) boolValue];
}
@end
