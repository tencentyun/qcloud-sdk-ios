//
//  QCloudBizHTTPRequest.m
//  Pods
//
//  Created by Dong Zhao on 2017/3/13.
//
//

#import "QCloudBizHTTPRequest.h"
#import "QCloudServiceConfiguration.h"

#import "NSError+QCloudNetworking.h"
#import "QCloudNetResponse.h"
#import "QCloudObjectModel.h"
#import "QCloudSignatureFields.h"
#import "QCloudHTTPSessionManager.h"
#import "QCloudService.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>
#import "NSObject+QCloudModelTool.h"
#import "QCloudLogger.h"
NS_ASSUME_NONNULL_BEGIN

QCloudResponseSerializerBlock QCloudResponseObjectSerilizerBlock(Class modelClass) {
    return ^(NSHTTPURLResponse *response, id inputData, NSError *__autoreleasing *error) {
        if([inputData isKindOfClass:[NSDictionary class]]){
            return [modelClass qcloud_modelWithDictionary:inputData];
        }
        if([inputData isKindOfClass:[NSArray class]]){
            id array = [modelClass jsonsToModelsWithJsons:inputData];
            return array;
            
        }
        
        if (error != NULL) {
                *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeResponseDataTypeInvalid
                                                       message:[NSString stringWithFormat:@"ServerError:希望获得字典类型数据,但是得到%@", [inputData class]]];
        
        }
        return (id)nil;
        
        
    };
}


QCloudResponseSerializerBlock QCloudResponseCOSNormalRSPSerilizerBlock
    = ^(NSHTTPURLResponse *response, id inputData, NSError *__autoreleasing *error) {
          NSError *localError;
          QCloudNetResponse *transformData = QCloudResponseObjectSerilizerBlock([QCloudNetResponse class])(response, inputData, &localError);
          if (localError) {
              if (error != NULL) {
                  *error = localError;
              }
              return (id)nil;
          }
          if (![transformData isKindOfClass:[QCloudNetResponse class]]) {
              if (error != NULL) {
                  *error = [NSError
                      qcloud_errorWithCode:QCloudNetworkErrorCodeResponseDataTypeInvalid
                                   message:[NSString stringWithFormat:@"ServerError:希望获得QCloudNetResponse类型数据,但是得到%@", inputData]];
              }
              return (id)nil;
          }
          if (transformData.code != 0) {
              if (error != NULL) {
                  *error = [NSError qcloud_errorWithCode:transformData.code message:transformData.message];
              }
              return (id)nil;
          }
          return (id)(transformData.data);
      };

@interface QCloudBizHTTPRequest ()
@property (nonatomic,assign)NSInteger semp_flag;
@property (nonatomic,strong,nullable)dispatch_semaphore_t semaphore;
@end


@implementation QCloudBizHTTPRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        _customHeaders = [NSMutableDictionary dictionary];
    }
    return self;
}
- (void)loadConfigureBlock {
    __weak typeof(self) weakSelf = self;
    [self setConfigureBlock:^(QCloudRequestSerializer *requestSerializer, QCloudResponseSerializer *responseSerializer) {
        [weakSelf configureReuqestSerializer:requestSerializer responseSerializer:responseSerializer];
    }];
}

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    _customHeaders = [NSMutableDictionary dictionary];
    [requestSerializer setSerializerBlocks:[self customRequestSerizliers]];
    [responseSerializer setSerializerBlocks:[self customResponseSerializers]];
}
- (NSArray *)customResponseSerializers {
    return @[];
}

- (NSArray *)customRequestSerizliers {
    return @[];
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    BOOL ret = [super buildRequestData:error];
    if (!ret) {
        return ret;
    }

    return YES;
}
- (BOOL)customBuildRequestData:(NSError *__autoreleasing *)error {
    return YES;
}

- (QCloudSignatureFields *)signatureFields {
    return [QCloudSignatureFields new];
}

- (BOOL)prepareInvokeURLRequest:(NSMutableURLRequest *)urlRequest error:(NSError *__autoreleasing *)error {
    
    if(!self.signatureProvider){
        return YES;
    }
    
    //    NSAssert(self.runOnService, @"RUN ON SERVICE is nil%@", self.runOnService);
    self.semaphore = dispatch_semaphore_create(0);
    self.semp_flag = 1;
    __block NSError *localError;
    __block BOOL isSigned;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.signatureProvider
            signatureWithFields:self.signatureFields
                        request:self
                     urlRequest:urlRequest
                      compelete:^(QCloudSignature *signature, NSError *error) {
                          if (error) {
                              localError = error;
                          } else {
                              if (signature.signature) {
                                  if (!self.isSignedInURL) {
                                      [urlRequest setValue:signature.signature forHTTPHeaderField:@"Authorization"];
                                  } else {
                                      NSString *urlStr;
                                      NSRange rangeOfQ = [urlStr rangeOfString:@"?"];
                                      if (rangeOfQ.location == NSNotFound) {
                                          urlStr = [NSString stringWithFormat:@"%@?%@", urlRequest.URL.absoluteString, signature.signature];
                                      } else {
                                          urlStr = [NSString stringWithFormat:@"%@&%@", urlRequest.URL.absoluteString, signature.signature];
                                      }
                                      if (signature.token) {
                                          urlStr = [NSString stringWithFormat:@"%@&x-cos-security-token=%@", urlStr, signature.token];
                                      }
                                      urlRequest.URL = [[NSURL URLWithString:urlStr] copy];
                                  }
                                  isSigned = YES;
                              } else {
                                  // null authorization
                              }
                          }
                          dispatch_semaphore_signal(self.semaphore);
                          self.semp_flag = 2;
                      }];
    });

    if (self.semp_flag == 1) {
        dispatch_semaphore_wait(self.semaphore, dispatch_time(DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC));
    }
    
    
    if (localError) {
        if (NULL != error) {
            *error = localError;
        }
        return NO;
    } else if (!isSigned) {
        if (NULL != error) {
            *error = [NSError
                      qcloud_errorWithCode:QCloudNetworkErrorCodeCredentialNotReady
                      message:nil
                      infos:@{
                           @"Description" :
                               @"InvalidCredentials：获取签名超时，请检查是否实现签名回调，签名回调是否有调用,并且在最后是否有调用 ContinueBlock 传入签名"
                       }];
        }
        return NO;
    } else {
        return YES;
    }
}
- (void)loadQCloudSignature {
}
NSString *EncrytNSDataMD5Base64(NSData *data) {
    if (!data) {
        return nil;
    }

    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result); // This is the md5 call
    NSData *md5data = [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
    return [md5data base64EncodedStringWithOptions:0];
}

- (void)dealloc{
    if (self.semp_flag == 1) {
        dispatch_semaphore_signal(self.semaphore);
    }
}

- (void)setCOSServerSideEncyption {
    self.customHeaders[@"x-cos-server-side-encryption"] = @"AES256";
}

- (void)setCOSServerSideEncyptionWithCustomerKey:(NSString *)customerKey {
    NSData *data = [customerKey dataUsingEncoding:NSUTF8StringEncoding];
    NSString *excryptAES256Key = [data base64EncodedStringWithOptions:0]; // base64格式的字符串
    NSString *base64md5key = EncrytNSDataMD5Base64(data);
    self.customHeaders[@"x-cos-server-side-encryption-customer-algorithm"] = @"AES256";
    self.customHeaders[@"x-cos-server-side-encryption-customer-key"] = excryptAES256Key;
    self.customHeaders[@"x-cos-server-side-encryption-customer-key-MD5"] = base64md5key;
}

@end

NS_ASSUME_NONNULL_END
