//
//  QCloudFileZipper.m
//  Pods
//
//  Created by Dong Zhao on 2017/3/15.
//
//

#import "QCloudFileZipper.h"

@interface QCloudFileZipper ()
@property (nonatomic, strong) NSString* inputPath;
@end

@implementation QCloudFileZipper
- (instancetype) initWithInputFilePath:(NSString *)path
{
    self = [super init];
    if (!self) {
        return self;
    }
    _inputPath = path;
    return self;
}

- (BOOL) outputToPath:(NSString *)path
{
    
    
    return YES;
}
@end
