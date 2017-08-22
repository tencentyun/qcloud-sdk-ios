//
//  QCloudEndPoint.h
//  Pods
//
//  Created by Dong Zhao on 2017/3/31.
//
//

#import <Foundation/Foundation.h>
typedef NSString* QCloudRegion;
typedef NSString* QCloudServiceName;


/**
 QCloud 云服务的服务器地址，如果您继承该类，并且添加了自定义的参数，请一定要实现NSCopying协议
 */
@interface QCloudEndPoint : NSObject <NSCopying>
{
    @protected
    QCloudRegion _regionName;
    QCloudServiceName   _serviceName;
}
/**
 是否启动HTTPS安全连接
 @default NO
 */
@property (nonatomic, assign) BOOL useHTTPS;
/**
 服务园区名称
 */
@property (nonatomic, copy) QCloudRegion        regionName;
/**
 服务的基础名称
 */
@property (nonatomic, copy) QCloudServiceName   serviceName;

- (NSURL*) serverURLWithBucket:(NSString*)bucket appID:(NSString*)appID;
@end
