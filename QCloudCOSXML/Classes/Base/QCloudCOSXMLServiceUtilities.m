//
//  QCloudCOSXMLServiceUtilities.m
//  Pods
//
//  Created by Dong Zhao on 2017/5/26.
//
//

#import "QCloudCOSXMLServiceUtilities.h"
#import <QCloudCore/QCloudCore.h>

NSString* QCloudCOSXMLObjectLocation(QCloudEndPoint* endpoint, NSString* appID,NSString* bucket, NSString* object,NSString *regionName) {
    NSURL* url =  [endpoint serverURLWithBucket:bucket appID:appID regionName:regionName];
    return  [url URLByAppendingPathComponent:object].absoluteString;
}

