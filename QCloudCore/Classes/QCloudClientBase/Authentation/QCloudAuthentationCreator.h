//
//  QCloudAuthentationCreator.h
//  Pods
//
//  Created by Dong Zhao on 2017/5/2.
//
//

#import <Foundation/Foundation.h>
@class QCloudCredential;
@class QCloudSignature;
@class QCloudHTTPRequest;
@class QCloudSignatureFields;
@interface QCloudAuthentationCreator : NSObject
@property (nonatomic ,strong, readonly) QCloudCredential* credential;
- (instancetype) initWithCredential:(QCloudCredential*)credential;

- (QCloudSignature*) signatureForFields:(QCloudSignatureFields*)fields;
- (QCloudSignature*) signatureForCOSXMLRequest:(QCloudHTTPRequest*)reuqest;
@end
