//
//  NSMutableData+Qcloud_CRC.m
//  AOPKit
//
//  Created by karisli(李雪) on 2020/7/1.
//

#import "NSMutableData+QCloud_CRC.h"
#include "QCloudCRC64.h"
@implementation NSMutableData (QCloud_CRC)
- (uint64_t)qcloud_crc64 {
    return qcloud_aos_crc64(0, self.mutableBytes, self.length);
}

- (uint64_t)qcloud_crc64ForCombineCRC1:(uint64_t)crc1 CRC2:(uint64_t)crc2 length:(size_t)len2 {
    return qcloud_aos_crc64_combine(crc1, crc2, len2);
}
@end
