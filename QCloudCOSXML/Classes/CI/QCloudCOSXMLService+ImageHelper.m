//
//  QCloudCOSXMLService+ImageHelper.m
//  Pods-QCloudCOSXMLDemo
//
//  Created by garenwang on 2020/6/8.
//

#import "QCloudCOSXMLService+ImageHelper.h"
#import "QCloudPutObjectWatermarkRequest.h"
#import "QCloudGetRecognitionObjectRequest.h"

#import "QCloudGetFilePreviewRequest.h"
#import "QCloudGetGenerateSnapshotRequest.h"
#import "QCloudCICloudDataOperationsRequest.h"
#import "QCloudCIPutObjectQRCodeRecognitionRequest.h"
#import "QCloudCIPicRecognitionRequest.h"
#import "QCloudGetDescribeMediaBucketsRequest.h"
#import "QCloudGetMediaInfoRequest.h"
#import "QCloudGetVideoRecognitionRequest.h"
#import "QCloudPostVideoRecognitionRequest.h"
@implementation QCloudCOSXMLService (ImageHelper)

- (void)PutWatermarkObject:(QCloudPutObjectWatermarkRequest *)request {
    [super performRequest:request];
}

- (void)GetRecognitionObject:(QCloudGetRecognitionObjectRequest *)request {
    [super performRequest:request];
}

- (void)GetFilePreviewObject:(QCloudGetFilePreviewRequest *)request {
    [super performRequest:request];
}

- (void)GetGenerateSnapshot:(QCloudGetGenerateSnapshotRequest *)request {
    [super performRequest:request];
}

- (void)CloudDataOperations:(QCloudCICloudDataOperationsRequest *)request {
    [super performRequest:request];
}

- (void)PutObjectQRCodeRecognition:(QCloudCIPutObjectQRCodeRecognitionRequest *)request {
    [super performRequest:request];
}

- (void)CIQRCodeRecognition:(QCloudQRCodeRecognitionRequest *)request{
    [super performRequest:request];
}

- (void)CIPicRecognition:(QCloudCIPicRecognitionRequest *)request{
    [super performRequest:request];
}

- (void)CIGetDescribeMediaBuckets:(QCloudGetDescribeMediaBucketsRequest *)request{
    [super performRequest:request];
}

- (void)CIGetMediaInfo:(QCloudGetMediaInfoRequest *)request{
    [super performRequest:request];
}

- (void)GetVideoRecognition:(QCloudGetVideoRecognitionRequest *)request{
    [super performRequest:request];
}
- (void)PostVideoRecognition:(QCloudPostVideoRecognitionRequest *)request{
    [super performRequest:request];
}
@end
