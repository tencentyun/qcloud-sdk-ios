//
//  QCloudEncryt.m
//  Pods
//
//  Created by Dong Zhao on 2017/6/6.
//
//

#import "QCloudEncryt.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>
#import "QCloudFileUtils.h"
#import <stdio.h>
#include <string.h>
#include <string>

NSString* QCloudEncrytNSDataMD5Base64(NSData* data)
{
    if (!data) {
        return nil;
    }
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( data.bytes, (CC_LONG)data.length, result ); // This is the md5 call
    NSData* md5data = [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
    return [md5data base64EncodedStringWithOptions:0];
}

NSString* QCloudEncrytFileMD5Base64(NSString* filePath) {
    if (!QCloudFileExist(filePath)) {
        return nil;
    }
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if(!handle)
    {
        return nil;
    }
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    static NSUInteger MD5_CHUNK = 1024*16;
    while (!done)
    {
        NSData *fileData = [handle readDataOfLength:MD5_CHUNK];
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
        if([fileData length] == 0)
            done = YES;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    [handle closeFile];
    NSData* md5data = [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    return [md5data base64EncodedStringWithOptions:0];
}



NSString* QCloudEncrytFileOffsetMD5Base64(NSString* filePath, int64_t offset , int64_t siliceLength) {
    if (!QCloudFileExist(filePath)) {
        return nil;
    }
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if(!handle)
    {
        return nil;
    }
    if (QCloudFileSize(filePath) < offset+siliceLength) {
        return nil;
    }
    [handle seekToFileOffset:offset];
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    
    NSUInteger totalReadCount = 0;
    static NSUInteger MD5_CHUNK = 1024*16;
    while (!done)
    {
        if (totalReadCount >= siliceLength) {
            break;
        }
        NSUInteger willReadLength = MIN(MD5_CHUNK, siliceLength-totalReadCount);
        if (willReadLength == 0) {
            break;
        }
        NSData *fileData = [handle readDataOfLength:willReadLength];
        if (fileData.length == 0) {
            break;
        }
        totalReadCount += fileData.length;
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    [handle closeFile];
    NSData* md5data = [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    return [md5data base64EncodedStringWithOptions:0];
}


NSString* QCloudEncrytMD5String(NSString* originString) {
    const char *cStr = [originString UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}


NSString* QCloudHmacSha1Encrypt(NSString *data , NSString* key)
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [[NSData alloc] initWithBytes:cHMAC
                                          length:sizeof(cHMAC)];
    NSString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i)
        HMAC = [HMAC stringByAppendingFormat:@"%02lx", (unsigned long)cHMAC[i]];

    return HMAC;
}
