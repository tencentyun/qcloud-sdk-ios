//
//  QCloudLoaderManager.h
//  Pods-QCloudCOSXMLDemo
//
//  Created by garenwang on 2024/12/27.
//

#import <Foundation/Foundation.h>
#import "QCloudCustomSession.h"
#import "QCloudCustomLoader.h"
NS_ASSUME_NONNULL_BEGIN


@interface QCloudLoaderManager :NSObject

@property (nonatomic,assign)BOOL enable;

@property (atomic,strong,readonly)NSMutableArray <id <QCloudCustomLoader>> * loaders;

- (void)addLoader:(id <QCloudCustomLoader>)loader;

+ (QCloudLoaderManager *)manager;

-(id <QCloudCustomLoader>)getAvailableLoader:(QCloudHTTPRequest *)httpRequest;
@end

NS_ASSUME_NONNULL_END
