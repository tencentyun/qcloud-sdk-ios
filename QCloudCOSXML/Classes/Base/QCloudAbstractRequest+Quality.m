//
//  QCloudAbstractRequest+Quality.m
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 2018/8/24.
//

#import "QCloudAbstractRequest+Quality.h"
#import <objc/runtime.h>
#import <QCloudCore/QualityDataUploader.h>
#import "QCloudCOSXMLVersion.h"
#import "QCloudCOSXMLService+Quality.h"
#import "QCloudPhoneNetSDK.h"
#import "QCloudPNDomainLookup.h"

@interface QCloudAbstractRequest ()
@property (nonatomic,strong)QCloudPNUdpTraceroute * traceroute;
@property (nonatomic,strong)QCloudPNTcpPing * tcpPing;
@end

@implementation QCloudAbstractRequest (Quality)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeImplementation];
    });
}

+ (void)exchangeImplementation {
    Class class = [self class];
    Method originNotifyErrorMethod = class_getInstanceMethod(class, @selector(__notifyError:));
    Method swizzedNotifyErrorMethod = class_getInstanceMethod(class, @selector(__quality__notifyError:));
    Method originNotifySuccessMethod = class_getInstanceMethod(class, @selector(__notifySuccess:));
    Method swizzedNotifySuccessMethod = class_getInstanceMethod(class, @selector(__quality__notifySuccess:));

    method_exchangeImplementations(originNotifyErrorMethod, swizzedNotifyErrorMethod);
    method_exchangeImplementations(originNotifySuccessMethod, swizzedNotifySuccessMethod);
}

- (void)__quality__notifyError:(NSError *)error {
    [self __quality__notifyError:error];
    BOOL is4XX = error.code >= 400 && error.code <500;
    if (!is4XX && [self isKindOfClass:[QCloudHTTPRequest class]] && ((QCloudHTTPRequest *)self).runOnService.configuration.disableNetworkDetect == NO) {
        NSURL * errorURL = error.userInfo[@"NSErrorFailingURLKey"];
        if (errorURL && errorURL.host) {
            __block NSMutableString * networkDetect = [NSMutableString new];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[QCloudPNDomainLookup shareInstance] lookupDomain:errorURL.host completeHandler:^(NSMutableArray<DomainLookUpRes *> * _Nullable lookupRes, PNError * _Nullable sdkError) {
                    if (sdkError) {
                        [networkDetect appendFormat:@"QCloudPNDomainLookup URL:%@;Error:%@;\n",errorURL,sdkError.error];
                        QCloudLogDebugPB(@"HTTP",@"QCloudPNDomainLookup URL:%@;Error:%@;",errorURL,sdkError.error);
                        NSMutableDictionary * mparams = [[QCloudCOSXMLService commonParams:kQCloudDataAppReleaseKey] mutableCopy];
                        [mparams setObject:networkDetect forKey:@"networkDetect"];
                        [QualityDataUploader trackSDKRequestFailWithRequest:self error:error params:mparams];
                    }else{
                        NSMutableArray * mArray = NSMutableArray.new;
                        [lookupRes enumerateObjectsUsingBlock:^(DomainLookUpRes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            [mArray addObject:[NSString stringWithFormat:@"%@_%@",obj.name,obj.ip]];
                        }];
                        [networkDetect appendFormat:@"[PROBE]QCloudPNDomainLookup URL:%@;Result:%@;\n",errorURL,[mArray componentsJoinedByString:@";"]];
                        QCloudLogDebugPB(@"HTTP",@"QCloudPNDomainLookup URL:%@;Result:%@;",errorURL,[mArray componentsJoinedByString:@";"]);
                        [lookupRes enumerateObjectsUsingBlock:^(DomainLookUpRes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            self.tcpPing = [QCloudPNTcpPing start:obj.ip port:443 count:2 complete:^(NSMutableString *pingres) {
                                [networkDetect appendFormat:@"QCloudPNTcpPing URL:%@;Result:%@;\n",errorURL,pingres];
                                QCloudLogDebugPB(@"HTTP",@"QCloudPNTcpPing URL:%@;Result:%@;",errorURL,pingres);
                            }];
                            self.traceroute = [QCloudPNUdpTraceroute start:obj.ip complete:^(NSMutableString *res) {
                                [networkDetect appendFormat:@"QCloudPNUdpTraceroute URL:%@;Result:%@;",errorURL,res];
                                QCloudLogDebugPB(@"HTTP",@"QCloudPNUdpTraceroute URL:%@;Result:%@;",errorURL,res);
                            }];
                        }];
                    }
                }];
            });
        }else{
            [QualityDataUploader trackSDKRequestFailWithRequest:self error:error params:[QCloudCOSXMLService commonParams:kQCloudDataAppReleaseKey]];
        }
    }else{
        [QualityDataUploader trackSDKRequestFailWithRequest:self error:error params:[QCloudCOSXMLService commonParams:kQCloudDataAppReleaseKey]];
    }
}

- (void)__quality__notifySuccess:(id)object {
    [self __quality__notifySuccess:object];
    [QualityDataUploader trackSDKRequestSuccessWithRequest:self params:[QCloudCOSXMLService commonParams:kQCloudDataAppReleaseKey]];
}

- (QCloudPNUdpTraceroute *)traceroute{
    return objc_getAssociatedObject(self, @"traceroute");
}

- (QCloudPNTcpPing *)tcpPing{
    return objc_getAssociatedObject(self, @"tcpPing");
}

- (void)setTraceroute:(QCloudPNUdpTraceroute *)traceroute{
    objc_setAssociatedObject(self, @"traceroute", traceroute, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTcpPing:(QCloudPNTcpPing *)tcpPing{
    objc_setAssociatedObject(self, @"tcpPing", tcpPing, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
