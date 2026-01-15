//
//  QCloudPhoneNetSDKHelper.h
//  PhoneNetSDK
//
//  Created by mediaios on 2019/2/27.
//  Copyright © 2019 mediaios. All rights reserved.
//

#ifndef QCloudPhoneNetSDKHelper_h
#define QCloudPhoneNetSDKHelper_h
#import "QCloudPNetModel.h"


#pragma mark -ping callback
typedef void(^NetPingResultHandler)(NSString *_Nullable pingres);

#pragma mark -tracert callback
typedef void(^NetTracerouteResultHandler)(NSString *_Nullable tracertRes ,NSString *_Nullable destIp);

#pragma mark -nslookup callback
typedef void (^NetLookupResultHandler)(NSMutableArray<DomainLookUpRes *>  *_Nullable lookupRes, PNError *_Nullable sdkError);

#pragma mark -portscan callback
typedef void (^NetPortScanHandler)(NSString * _Nullable port, BOOL isOpen, PNError * _Nullable sdkError);

#endif /* QCloudPhoneNetSDKHelper_h */
