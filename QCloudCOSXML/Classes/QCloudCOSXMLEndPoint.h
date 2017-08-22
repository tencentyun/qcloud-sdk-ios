//
//  QCloudCOSXMLEndPoint.h
//  Pods
//
//  Created by Dong Zhao on 2017/8/22.
//
//

#import <QCloudCore/QCloudCore.h>
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"

@interface QCloudCOSXMLEndPoint : QCloudEndPoint
/**
 服务地域名称, 目前可用的服务地域名称有：
 
 *. cn-south        华南
 *. cn-north        华北
 *. cn-east         华东
 *. cn-southwest    西南
 *. sg              新加坡
 
 */
@property (nonatomic, copy) QCloudRegion        regionName;

/**
 服务的基础名称, 默认值为: myqcloud.com
 */
@property (nonatomic, copy) QCloudServiceName   serviceName;
@end

#pragma clang diagnostic pop
