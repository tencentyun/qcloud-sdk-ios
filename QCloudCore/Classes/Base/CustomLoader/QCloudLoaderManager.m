//
//  QCloudLoaderManager.m
//  Pods-QCloudCOSXMLDemo
//
//  Created by garenwang on 2024/12/27.
//

#import "QCloudLoaderManager.h"
#import "QCloudHTTPRequest.h"

@interface  QCloudLoaderManager()
@property (nonatomic,strong)NSMutableArray <id <QCloudCustomLoader>> * loaders;
@end

@implementation QCloudLoaderManager

+ (QCloudLoaderManager *)manager {
    static QCloudLoaderManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[QCloudLoaderManager alloc] init];
    
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.loaders = [NSMutableArray new];
    }
    return self;
}

-(id <QCloudCustomLoader>)getAvailableLoader:(QCloudHTTPRequest *)httpRequest{
    for (int i = 0; i < self.loaders.count; i ++) {
        if ([self.loaders[i] enable:httpRequest]) {
            return self.loaders[i];
        }
    }
    return nil;
}

-(void)addLoader:(id <QCloudCustomLoader>)loader{
    [self.loaders addObject:loader];
}

@end
