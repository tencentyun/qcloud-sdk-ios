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
 *.ap-beijing-1    北京一区（华北）
 *.ap-beijing	   北京
 *.ap-shanghai     上海（华东）
 *.ap-guangzhou    广州（华南）
 *.ap-guangzhou-2  广州（视频云）
 *.ap-chengdu      成都（西南）
 *.ap-singapore    新加坡
 *.ap-hongkong     香港
 *.na-toronto      多伦多
 *.eu-frankfurt    法兰克福
 *.cn-north        华北
 */
@property (nonatomic, copy) QCloudRegion        regionName;

/**
 服务的基础名称, 默认值为: myqcloud.com
 */
@property (nonatomic, copy) QCloudServiceName   serviceName;
@end

#pragma clang diagnostic pop
