//
//  QCloudCredential.h
//  Pods
//
//  Created by Dong Zhao on 2017/5/2.
//
//

#import <Foundation/Foundation.h>

@interface QCloudCredential : NSObject
@property (nonatomic, strong) NSString* secretID;
@property (nonatomic, strong) NSString* secretKey;
@property (nonatomic, strong) NSDate* validBeginDate;
@property (nonatomic, strong) NSDate* experationDate;
@property (nonatomic, assign, readonly) BOOL valid;
@end
