//
//  QCloudAuthentationV5Creator.h
//  Pods
//
//  Created by Dong Zhao on 2017/8/31.
//
//

#import <QCloudCore/QCloudCore.h>


/**
 COS V5 （XML）版本签名创建器。
 */
@class QCloudHTTPRequest;
@interface QCloudAuthentationV5Creator : QCloudAuthentationCreator
- (QCloudSignature*) signatureForData:(NSMutableURLRequest*)signData;
@end
