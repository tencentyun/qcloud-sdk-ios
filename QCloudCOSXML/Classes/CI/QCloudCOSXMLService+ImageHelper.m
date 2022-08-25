//
//  QCloudCOSXMLService+ImageHelper.m
//  Pods-QCloudCOSXMLDemo
//
//  Created by garenwang on 2020/6/8.
//

#import "QCloudCOSXMLService+ImageHelper.h"
#import "QCloudPutObjectWatermarkRequest.h"

#import "QCloudGetFilePreviewRequest.h"
#import "QCloudGetGenerateSnapshotRequest.h"
#import "QCloudCICloudDataOperationsRequest.h"
#import "QCloudCIPutObjectQRCodeRecognitionRequest.h"
#import "QCloudCIPicRecognitionRequest.h"
#import "QCloudGetDescribeMediaBucketsRequest.h"
#import "QCloudGetMediaInfoRequest.h"
#import "QCloudGetVideoRecognitionRequest.h"
#import "QCloudPostVideoRecognitionRequest.h"
#import "QCloudGetAudioRecognitionRequest.h"
#import "QCloudPostAudioRecognitionRequest.h"
#import "QCloudGetTextRecognitionRequest.h"
#import "QCloudPostTextRecognitionRequest.h"
#import "QCloudGetDocRecognitionRequest.h"
#import "QCloudPostDocRecognitionRequest.h"
#import "QCloudGetWebRecognitionRequest.h"
#import "QCloudPostWebRecognitionRequest.h"

#import "QCloudUpdateAudioDiscernTaskQueueRequest.h"
#import "QCloudGetAudioDiscernTaskQueueRequest.h"
#import "QCloudBatchGetAudioDiscernTaskRequest.h"
#import "QCloudGetAudioDiscernTaskRequest.h"
#import "QCloudPostAudioDiscernTaskRequest.h"
#import "QCloudGetAudioDiscernOpenBucketListRequest.h"
#import "QCloudOpenAIBucketRequest.h"
#import "QCloudGetAIJobQueueRequest.h"

@implementation QCloudCOSXMLService (ImageHelper)

- (void)PutWatermarkObject:(QCloudPutObjectWatermarkRequest *)request {
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

- (void)BatchImageRecognition:(QCloudBatchimageRecognitionRequest *)request{
    [super performRequest:request];
}

- (void)SyncImageRecognition:(QCloudSyncImageRecognitionRequest *)request{
    [super performRequest:request];
}

- (void)GetImageRecognition:(QCloudGetImageRecognitionRequest *)request{
    [super performRequest:request];
}

- (void)GetVideoRecognition:(QCloudGetVideoRecognitionRequest *)request{
    [super performRequest:request];
}
- (void)PostVideoRecognition:(QCloudPostVideoRecognitionRequest *)request{
    [super performRequest:request];
}

- (void)GetAudioRecognition:(QCloudGetAudioRecognitionRequest *)request{
    [super performRequest:request];
}
- (void)PostAudioRecognition:(QCloudPostAudioRecognitionRequest *)request{
    [super performRequest:request];
}

- (void)GetDocRecognition:(QCloudGetDocRecognitionRequest *)request{
    [super performRequest:request];
}
- (void)PostDocRecognition:(QCloudPostDocRecognitionRequest *)request{
    [super performRequest:request];
}

- (void)GetTextRecognition:(QCloudGetTextRecognitionRequest *)request{
    [super performRequest:request];
}
- (void)PostTextRecognition:(QCloudPostTextRecognitionRequest *)request{
    [super performRequest:request];
}
- (void)GetWebRecognition:(QCloudGetWebRecognitionRequest *)request{
    [super performRequest:request];
}
- (void)PostWebRecognition:(QCloudPostWebRecognitionRequest *)request{
    [super performRequest:request];
}

-(void)UpdateAudioDiscernTaskQueue:(QCloudUpdateAudioDiscernTaskQueueRequest *)request{
    [super performRequest:request];
}

-(void)GetAudioDiscernTaskQueue:(QCloudGetAudioDiscernTaskQueueRequest *)request{
    [super performRequest:request];
}

-(void)BatchGetAudioDiscernTask:(QCloudBatchGetAudioDiscernTaskRequest *)request{
    [super performRequest:request];
}

-(void)GetAudioDiscernTask:(QCloudGetAudioDiscernTaskRequest *)request{
    [super performRequest:request];
}

-(void)PostAudioDiscernTask:(QCloudPostAudioDiscernTaskRequest *)request{
    [super performRequest:request];
}

-(void)GetAudioDiscernOpenBucketList:(QCloudGetAudioDiscernOpenBucketListRequest *)request{
    [super performRequest:request];
}

-(void)OpenAIBucket:(QCloudOpenAIBucketRequest *)request{
    [super performRequest:request];
}

-(void)GetAIJobQueue:(QCloudGetAIJobQueueRequest *)request{
    [super performRequest:request];
}

-(void)PostWordsGeneralizeTask:(QCloudPostWordsGeneralizeTaskRequest *)request{
    [super performRequest:request];
}
-(void)GetWordsGeneralizeTask:(QCloudGetWordsGeneralizeTaskRequest *)request{
    [super performRequest:request];
}


@end
