//
//  QCloudAuthentationV4Creator.h
//  Pods
//
//  Created by Dong Zhao on 2017/5/17.
//
//

#import "QCloudAuthentationCreator.h"

@interface QCloudAuthentationV4Creator : QCloudAuthentationCreator
- (QCloudSignature*) signatureForFields:(QCloudSignatureFields*)fields;

@end
