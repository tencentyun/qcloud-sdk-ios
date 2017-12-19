//
//  QCloudV4EndPoint.h
//  Pods-QCloudNewCOSV4Demo
//
//  Created by erichmzhang(张恒铭) on 31/10/2017.
//

#import <QCloudCore/QCloudCore.h>

@interface QCloudV4EndPoint : QCloudEndPoint
/**
  default is "file.myqcloud.com", if you use the dynamic speed function, you can set this property to changed the service host.
 */
@property (nonatomic, copy) NSString* serviceHostSubfix;

@end
