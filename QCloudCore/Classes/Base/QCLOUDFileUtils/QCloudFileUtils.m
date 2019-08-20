//
//  QCloudFileUtils.m
//  Pods
//
//  Created by stonedong on 16/3/6.
//
//

#import "QCloudFileUtils.h"
#import <Foundation/Foundation.h>
#import <commoncrypto/CommonDigest.h>
#import "QCloudSHAPart.h"

void QCloudEnsurePathExist(NSString* path)
{
    NSCParameterAssert(path);
    BOOL exist = [NSShareFileManager fileExistsAtPath:path];
    if (!exist) {
        NSError* error = nil;
        [NSShareFileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }
}


BOOL QCloudFileExist(NSString* path) {
    return  [NSShareFileManager fileExistsAtPath:path];
    
}

NSString * QCloudApplicationDocumentsPath() {
    static NSString* documentsPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray* urls =  [NSShareFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL* url = urls[0];
        documentsPath = [url path];
    });
    return documentsPath;
}

NSString * QCloudApplicationLibaryPath()
{
    static NSString* documentsPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray* urls =  [NSShareFileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask];
        NSURL* url = urls[0];
        documentsPath = [url path];
    });
    return documentsPath;
}

NSString * QCloudApplicationDirectory()
{
    static NSString* documentsPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray* urls =  [NSShareFileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask];
        NSURL* url = urls[0];
        documentsPath = [url path];
        documentsPath = [documentsPath stringByDeletingLastPathComponent];
    });
    return documentsPath;
}
NSString * QCloudApplicationTempPath()
{
    return NSTemporaryDirectory();
}

NSString* QCloudDocumentsPath()
{
    static NSString* documentsPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray* urls =  [NSShareFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL* url = urls[0];
        documentsPath = [url path];
        documentsPath = [documentsPath stringByAppendingPathComponent:@"MainData"];
        QCloudEnsurePathExist(documentsPath);
    });
    return documentsPath;
}


NSString* QCloudSettingsFilePath()
{
    return [QCloudDocumentsPath() stringByAppendingPathComponent:@"settings.plist"];
}

NSString* QCloudAppendPath(NSString* parentPath, NSString* sub) {
    NSString* str = [parentPath stringByAppendingPathComponent:sub];
    QCloudEnsurePathExist(str);
    return str;
}

NSString* QCloudTempDir(){
    return NSTemporaryDirectory();
}

NSString* QCloudMKTempDirectory(){
    NSString* path = [[NSUUID UUID] UUIDString];
    return QCloudAppendPath(QCloudTempDir(),path);
}

NSString* QCloudDocumentsSubPath(NSString* str) {
    return QCloudAppendPath(QCloudDocumentsPath(), str);
}


NSString* QCloudPathJoin(NSString* base, NSString* component) {
    NSCParameterAssert(component);
    if ([base hasSuffix:@"/"]) {
        if ([component hasPrefix:@"/"]) {
            return [[base substringToIndex:base.length-1] stringByAppendingString:component];
        } else {
            return [base stringByAppendingString:component];
            
        }
    } else {
        if (component.length) {
            if ([component hasPrefix:@"/"]) {
                return [base stringByAppendingFormat:@"%@",component];
            } else {
                return [base stringByAppendingFormat:@"/%@",component];
            }
        } else {
            return base;
        }
    }
}


NSString* QCloudTempFilePathWithExtension(NSString* extension){
    NSString* fileName = [NSUUID UUID].UUIDString;
    NSString* path = QCloudTempDir();
    path = [path stringByAppendingPathComponent:fileName];
    path = [path stringByAppendingPathExtension:extension];
    return path;
}

NSString* QCloudDocumentsTempPath() {
    NSString* path = QCloudPathJoin(QCloudDocumentsPath(), @"temp");
    QCloudEnsurePathExist(path);
    return path;
}

NSString* QCloudDocumentsTempFile(NSString* fileName, NSString* extension) {
    NSString* path = QCloudDocumentsPath();
    path = [path stringByAppendingPathComponent:fileName];
    if (extension) {
        path = [path stringByAppendingPathExtension:extension];
    }
    return path;
}

NSString* QCloudDocumentsTempFilePathWithExcentsion(NSString* extension) {
    NSString* fileName = [NSUUID UUID].UUIDString;
    NSString* path = QCloudDocumentsPath();
    path = [path stringByAppendingPathComponent:fileName];
    if (extension) {
        path = [path stringByAppendingPathExtension:extension];
    }
    return path;
}
void QCloudRemoveFileByPath(NSString* path) {
    NSError* error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
}


NSString* QCloudFileInSubPath(NSString* subPath, NSString* fileName){
    NSString* sp = QCloudDocumentsSubPath(subPath);
    QCloudEnsurePathExist(sp);
    return [sp stringByAppendingPathComponent:fileName];
}

BOOL QCloudMoveFile(NSString* originPath, NSString* aimPath, NSError* __autoreleasing* error) {
   return  [[NSFileManager defaultManager] moveItemAtPath:originPath toPath:aimPath error:error];
}

int64_t QCloudDirectorySize(NSString * path, NSFileManager * fileManager) {

    BOOL  isDirectory = NO;
    BOOL  exist =[fileManager fileExistsAtPath:path isDirectory:&isDirectory];
    if (!exist) {
        return 0;
    }

    if (!isDirectory){
        return 0;
    }

    int64_t  totalSize = 0;

    NSDirectoryEnumerator * itor = [fileManager enumeratorAtPath:path];
    NSString * file ;
    while (file = [itor nextObject]) {
        BOOL  isD;
        BOOL  isE;
        NSString * checkPath = [path stringByAppendingPathComponent:file];
        isE = [fileManager fileExistsAtPath:checkPath isDirectory:&isD];
        if (isE && !isD) {
            NSError * error;
            NSDictionary * attributes = [fileManager attributesOfItemAtPath:checkPath error:&error];
            if (!error && attributes ) {
                totalSize += [attributes fileSize];
            }
        }
    }
    return totalSize;
}


NSString * QCloudFilteLocalPath(NSString * originPath) {
    if (!originPath || originPath.length < QCloudApplicationDirectory().length) {
        return originPath;
    }
    NSRange range = [originPath rangeOfString:QCloudApplicationDirectory()];
    if (range.location != NSNotFound) {
        return [originPath substringFromIndex:range.location + range.length];
    }
    return originPath;
}

NSString * QCloudGenerateLocalPath(NSString * pathCompents) {
    return [QCloudApplicationDirectory() stringByAppendingPathComponent:pathCompents];
}


NSURL * QCloudMediaURL(NSString * path)
{
    if ([path hasPrefix:@"http"]) {
        return [NSURL URLWithString:path];
    } else {
        return [NSURL fileURLWithPath:QCloudGenerateLocalPath(path)];
    }
}


uint64_t QCloudFileSize(NSString* path){
    if (path.length==0) {
        return 0;
    }
    BOOL isDirectory = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory]) {
        if (isDirectory) {
            return 0;
        }
        NSDictionary* attribute = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        return [attribute fileSize];
    }
    return 0;
}


NSArray<QCloudSHAPart*>*  QCloudIncreaseFileSHAData(NSString *path, uint64_t sliceSize) {
    NSURL* fileURL = [NSURL fileURLWithPath:path];
    
    if( fileURL== nil ) {
        return nil;
    }
    sliceSize = MIN(QCloudFileSize(path), sliceSize);
    if (sliceSize == 0) {
        return nil;
    }
#ifdef DEBUG
    CFTimeInterval beginTime = CFAbsoluteTimeGetCurrent();
#endif
    NSInputStream* stream = [NSInputStream inputStreamWithURL:fileURL];
    [stream open];
    NSMutableArray *arr  = [NSMutableArray new];
    CC_SHA1_CTX sha;
    CC_SHA1_Init(&sha);
    BOOL done = NO;
    int64_t totalData = 0;
    int64_t offset = 0;
    while(!done) {
        @autoreleasepool {
            if (![stream hasBytesAvailable]) {
                [stream close];
                break;
            }
            uint64_t partNeedLoad = sliceSize;
            uint64_t partLength = 0;
            while (partNeedLoad > 0 && [stream hasBytesAvailable]) {
#define READ_SLICE_SIZE 1024*10
                uint8_t* buffer = malloc(READ_SLICE_SIZE*sizeof(uint8_t));
                memset(buffer, 0, READ_SLICE_SIZE);
                NSUInteger willReadMaxLength = (NSUInteger)MIN(READ_SLICE_SIZE, partNeedLoad);
                NSInteger readLength = [stream read:buffer maxLength:willReadMaxLength];
                if (readLength <= 0) {
                    free(buffer);
                    break;
                }
                CC_SHA1_Update(&sha, buffer, (unsigned int)readLength);
                partNeedLoad -= readLength;
                partLength += readLength;
                free(buffer);
            }
            if (partLength == 0) {
                done = YES;
                break;
            }
            QCloudSHAPart* part = [[QCloudSHAPart alloc] init];
            part.offset = offset;
            part.datalen = partLength;
            offset += partLength;
            totalData += partLength;
            unsigned char * digest =(unsigned char *) & sha.h0;
            NSString *result = [NSString stringWithFormat:
                                @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                                digest[ 0], digest[ 1], digest[ 2], digest[ 3],
                                digest[ 4], digest[ 5], digest[ 6], digest[ 7],
                                digest[ 8], digest[ 9], digest[10], digest[11],
                                digest[12], digest[13], digest[14], digest[15],
                                digest[16], digest[17], digest[18], digest[19]];
            part.datasha = result;
            [arr addObject:part];
        }
    }
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_Final(digest, &sha);
    
    NSString *result = [NSString stringWithFormat:
                        @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                        digest[ 0], digest[ 1], digest[ 2], digest[ 3],
                        digest[ 4], digest[ 5], digest[ 6], digest[ 7],
                        digest[ 8], digest[ 9], digest[10], digest[11],
                        digest[12], digest[13], digest[14], digest[15],
                        digest[16], digest[17], digest[18], digest[19]];
    QCloudSHAPart* part = [[QCloudSHAPart alloc] init];
    part.offset = 0;
    part.datalen = totalData;
    part.datasha = result;
    [arr addObject:part];
#ifdef DEBUG
    NSLog(@"sh1 time is %f", CFAbsoluteTimeGetCurrent() - beginTime);
#endif
    return arr;
}

