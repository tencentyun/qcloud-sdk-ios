//
//  QCloudBeaconTrackService.m
//  QCloudTrack
//
//  Created by garenwang on 2023/12/18.
//

#import "QCloudBeaconTrackService.h"
#import "QCloudTrackConstants.h"
#import <COSBeaconAPI_Base/COSBeaconReport.h>
#import "QCloudTrackConstants.h"

void QCloudTrackEnsurePathExist(NSString *path) {
    NSCParameterAssert(path);
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!exist) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }
}

static BOOL isStartedBeacon;

@interface QCloudBeaconTrackService ()

@property (nonatomic, strong) NSString * beaconKey;

@end

@implementation QCloudBeaconTrackService

- (instancetype)initWithBeaconKey:(NSString *)key
{
    self = [super init];
    if (self) {
        self.beaconKey = key;
        if (self.beaconKey) {
            @try {
                @synchronized ([QCloudBeaconTrackService class]) {
                    if (!isStartedBeacon) {
                        [[COSBeaconReport sharedInstance] startWithAppkey:self.beaconKey config:nil];
                        isStartedBeacon = YES;
                    }
                }
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
            
        }
    }
    return self;
}

- (void)updateBeaconKey:(NSString *)key{
    self.beaconKey = key;
    if(self.beaconKey){
        @try {
            @synchronized ([QCloudBeaconTrackService class]) {
                if (!isStartedBeacon) {
                    [[COSBeaconReport sharedInstance] startWithAppkey:self.beaconKey config:nil];
                    isStartedBeacon = YES;
                }
            }
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
    }
}

-(NSString *)getCachePath{
    static NSString *documentsPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL *url = urls[0];
        documentsPath = [url path];
        documentsPath = [documentsPath stringByAppendingPathComponent:@"MainData"];
        QCloudTrackEnsurePathExist(documentsPath);
    });
    return [documentsPath stringByAppendingString:@"qcloud_trach_cache.json"];
}

-(void)reportWithEventCode:(NSString *)eventCode params:(NSDictionary *)params{
    if (!eventCode || !params) return;
    
    if (self.isCloseReport || self.isDebug ) return;
    
    if (!self.beaconKey) {
        BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:[self getCachePath]];
        NSMutableDictionary *dic;
        if (!exist) {
            [[NSFileManager defaultManager] createFileAtPath:[self getCachePath] contents:[NSData data] attributes:nil];
            dic = [NSMutableDictionary dictionary];
            
        }else{
            NSData *jsonData = [[NSData alloc] initWithContentsOfFile:[self getCachePath]];
            if(jsonData){
                dic = [[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil] mutableCopy];
            }
        }
        [dic setObject:params forKey:eventCode];
        NSData *info =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:nil];
        [info writeToFile:[self getCachePath] options:0 error:nil];
        return;
    }
    
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:[self getCachePath]];
    if (exist) {
        NSData *jsonData = [[NSData alloc] initWithContentsOfFile:[self getCachePath]];
        if(jsonData){
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
            for (NSString * key in dic.allKeys) {
                [self _reportWithEventCode:key params:dic[key]];
            }
        }
        [[NSFileManager defaultManager] removeItemAtPath:[self getCachePath] error:nil];
    }
    [self _reportWithEventCode:eventCode params:params];

}

-(void)_reportWithEventCode:(NSString *)eventCode params:(NSDictionary *)params{
    if (!eventCode || !params) {
        return;
    }
    if (self.isDebug) {
        return;
    }
    
    COSBeaconEvent * eventObj = [COSBeaconEvent new];
    [eventObj setCode:eventCode];
    [eventObj setParams:params?:@{}];
    if (self.beaconKey) {
        [eventObj setAppKey:self.beaconKey];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        COSBeaconReport * beaconInstance = [COSBeaconReport sharedInstance];
        COSBeaconReportResult * result = [beaconInstance reportEvent:eventObj];
    });
}

-(BOOL)isSimpleDataTrackService{
    return [kSimpleDataBeaconAppKey isEqualToString:self.beaconKey];
}
@end
