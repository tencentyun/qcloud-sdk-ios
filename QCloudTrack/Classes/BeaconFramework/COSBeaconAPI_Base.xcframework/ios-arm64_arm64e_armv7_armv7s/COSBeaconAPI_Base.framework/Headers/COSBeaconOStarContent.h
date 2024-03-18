//
//  COSBeaconOStarContent.h
//  COSBeaconAPI_Base
//
//  Created by 吴小二哥 on 2021/7/8.
//  Copyright © 2021 tencent.com. All rights reserved.
//
/**
 * BEACON_DEPEND_QIMEI:是否依赖Qimei.
 * 由于在外网集成直连版QimeiSDK,存在风险问题.进而开发了 OStar 非直连版本 SDK. 灯塔SDK为了支持外网也需要做同步修改,
 * 具体的修改逻辑是通过 BEACON_DEPEND_QIMEI 预编译条件编译方式,如果需要依赖 QIMEI,则和原有逻辑不变; 如果不依赖 和Qimei相关方法屏蔽掉.
 * 通用内网版本存在一个 QimeiContent 的类,是属于Qimei具体内容载体. 这里COSBeaconOStarContent类作用是替代QimeiContent.
 * 替代后只需在COSBeaconOStarContent内进行条件判断, 减少在其他使用地方预条件的设置.
 * 因为QIMEI是敏感字段,外网版打包时会将所有头文件中 BEACON_DEPEND_QIMEI=1 范围内的代码删掉,包括(#if BEACON_DEPEND_QIMEI)
 */

#import <Foundation/Foundation.h>
#import <QimeiSDK/QimeiSDK.h> 

NS_ASSUME_NONNULL_BEGIN
@interface COSBeaconOStarContent : QimeiContent

@end

NS_ASSUME_NONNULL_END
