//
//  QCloudAuthentationV4Creator.m
//  Pods
//
//  Created by Dong Zhao on 2017/5/17.
//
//

#import "QCloudAuthentationV4Creator.h"
#import "QCloudSignatureFields.h"
#import "QCloudCredential.h"
#import "QCloudSignature.h"
#import "QCloudCredential.h"
#import "QCloudSignatureFields.h"
#import "QCloudHTTPRequest.h"
#import "QCloudRequestSerializer.h"
#import "NSString+QCloudSHA.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonDigest.h>
#import  <CommonCrypto/CommonHMAC.h>
#import <stdio.h>
#include <string.h>
#include <string>

@implementation QCloudAuthentationV4Creator


- (std::string)qcloudHmacSha1Data:(NSString *)data secret:(NSString *)key
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    std::string hmac((char*)cHMAC, CC_SHA1_DIGEST_LENGTH);
    return hmac;
}

- (std::string) base64:(std::string)plainText
{
    static const char b64_table[65] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    const std::size_t plainTextLen = plainText.size();
    std::string retval((((plainTextLen + 2) / 3) * 4), '=');
    std::size_t outpos = 0;
    int bits_collected = 0;
    unsigned int accumulator = 0;
    const std::string::const_iterator plainTextEnd = plainText.end();
    
    for (std::string::const_iterator i = plainText.begin(); i != plainTextEnd; ++i) {
        accumulator = (accumulator << 8) | (*i & 0xffu);
        bits_collected += 8;
        while (bits_collected >= 6) {
            bits_collected -= 6;
            retval[outpos++] = b64_table[(accumulator >> bits_collected) & 0x3fu];
        }
    }
    
    if (bits_collected > 0) {
        assert(bits_collected < 6);
        accumulator <<= 6 - bits_collected;
        retval[outpos++] = b64_table[accumulator & 0x3fu];
    }
    assert(outpos >= (retval.size() - 2));
    assert(outpos <= retval.size());
    return retval;
}

- (QCloudSignature*) signatureForData:(QCloudSignatureFields*)fields
{
    NSMutableString* origin = [NSMutableString new];
    void(^Append)(NSString* key, NSString* value) = ^(NSString* key, NSString* value) {
        if (origin.length > 0) {
            [origin appendString:@"&"];
        }
        if (value.length > 0) {
            [origin appendFormat:@"%@=%@",key,value];
        } else {
            [origin appendFormat:@"%@=", key];
        }
    };
    Append(@"a",fields.appID);
    Append(@"k", self.credential.secretID);

    int64_t current= (int)[[NSDate date] timeIntervalSince1970];
    int64_t expiredTime = current+60*60*24;

    Append(@"e",  [@(expiredTime) stringValue]);
    Append(@"t", [@(current) stringValue]);
    
    uint32_t random = rand();
    Append(@"r", [@(random) stringValue]);
    if (fields.once) {
        Append(@"f", fields.filed);
    } else {
        Append(@"f",@"");
    }
    Append(@"b", fields.bucket);
    std::string signeddata = [self qcloudHmacSha1Data:origin secret:self.credential.secretKey];
    std::string originString((char*)(origin.UTF8String), origin.length);
    signeddata = signeddata + originString;
    std::string base64 = [self base64:signeddata];
    NSString* sign = [NSString stringWithUTF8String:base64.c_str()];
    return [QCloudSignature signatureWith1Day:sign];
}

@end
