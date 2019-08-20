//
//  QCloudThreadSafeMutableDictionary.m
//  Pods
//
//  Created by Dong Zhao on 2017/3/31.
//
//

#import "QCloudThreadSafeMutableDictionary.h"

@interface QCloudThreadSafeMutableDictionary()

@property (nonatomic, strong) NSMutableDictionary *dictionary;
@property (nonatomic, strong) dispatch_queue_t dispatchQueue;

@end

@implementation QCloudThreadSafeMutableDictionary

- (instancetype)init {
    if (self = [super init]) {
        _dictionary = [NSMutableDictionary new];
        _dispatchQueue = dispatch_queue_create("com.tencent.qcloud.safedicationary", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

- (id)objectForKey:(id)aKey {
    __block id returnObject = nil;
    
    dispatch_sync(self.dispatchQueue, ^{
        returnObject = [self.dictionary objectForKey:aKey];
    });
    
    return returnObject;
}

- (void)removeObjectForKey:(id)aKey {
    dispatch_sync(self.dispatchQueue, ^{
        [self.dictionary removeObjectForKey:aKey];
    });
}

- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey {
    dispatch_sync(self.dispatchQueue, ^{
        [self.dictionary setObject:anObject forKey:aKey];
    });
}

- (NSArray *)allKeys {
    __block NSArray *allKeys = nil;
    dispatch_sync(self.dispatchQueue, ^{
        allKeys = [self.dictionary allKeys];
    });
    return allKeys;
}

- (void)removeObject:(id)object {
    dispatch_sync(self.dispatchQueue, ^{
        for (NSString *key in self.dictionary) {
            if (object == self.dictionary[key]) {
                [self.dictionary removeObjectForKey:key];
                break;
            }
        }
    });
}

@end
