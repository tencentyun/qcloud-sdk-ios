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
#import "QCloudGetFilePreviewHtmlRequest.h"
#import "QCloudPostObjectProcessRequest.h"

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
#import "QCloudCIImageRepairRequest.h"
#import "QCloudPostLiveVideoRecognitionRequest.h"
#import "QCloudCancelLiveVideoRecognitionRequest.h"
#import "QCloudGetLiveVideoRecognitionRequest.h"
#import "QCloudGetPrivateM3U8Request.h"
#import "QCloudGetMediaJobQueueRequest.h"
#import "QCloudUpdateMediaQueueRequest.h"
#import "QCloudGetDiscernMediaJobsRequest.h"
#import "QCloudGetWorkflowDetailRequest.h"
#import "QCloudGetListWorkflowRequest.h"
#import "QCloudPostTriggerWorkflowRequest.h"
#import "QCloudPostMediaJobsRequest.h"
#import "QCloudPostAudioTransferJobsRequest.h"
#import "QCloudPostVideoTagRequest.h"
#import "QCloudVideoMontageRequest.h"
#import "QCloudVideoSnapshotRequest.h"
#import "QCloudPostTranscodeRequest.h"
#import "QCloudPostAnimationRequest.h"
#import "QCloudPostConcatRequest.h"
#import "QCloudPostSmartCoverRequest.h"
#import "QCloudPostVoiceSeparateRequest.h"
#import "QCloudPostNumMarkRequest.h"
#import "QCloudExtractNumMarkRequest.h"
#import "QCloudPostImageProcessRequest.h"
#import "QCloudGetMediaJobRequest.h"
#import "QCloudGetMediaJobListRequest.h"
#import "QCloudCreateMediaJobRequest.h"
#import "QCloudPostImageAuditReportRequest.h"
#import "QCloudPostTextAuditReportRequest.h"
@implementation QCloudCOSXMLService (ImageHelper)

- (void)PutWatermarkObject:(QCloudPutObjectWatermarkRequest *)request {
    [super performRequest:request];
}

- (void)GetFilePreviewObject:(QCloudGetFilePreviewRequest *)request {
    [super performRequest:request];
}

- (void)GetFilePreviewHtmlObject:(QCloudGetFilePreviewHtmlRequest *)request{
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
    [super performRequest:(QCloudBizHTTPRequest *)request];
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
    [super performRequest:(QCloudBizHTTPRequest *)request];
}

- (void)SyncImageRecognition:(QCloudSyncImageRecognitionRequest *)request{
    [super performRequest:(QCloudBizHTTPRequest *)request];
}

- (void)GetImageRecognition:(QCloudGetImageRecognitionRequest *)request{
    [super performRequest:(QCloudBizHTTPRequest *)request];
}

- (void)GetVideoRecognition:(QCloudGetVideoRecognitionRequest *)request{
    [super performRequest:request];
}
- (void)PostVideoRecognition:(QCloudPostVideoRecognitionRequest *)request{
    [super performRequest:request];
}

- (void)PostObjectProcess:(QCloudPostObjectProcessRequest *)request{
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

-(void)GetDiscernMediaJobs:(QCloudGetDiscernMediaJobsRequest *)request{
    [super performRequest:request];
}

-(void)UpdateMediaJobQueue:(QCloudUpdateMediaQueueRequest *)request{
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

-(void)GetMediaJobQueue:(QCloudGetMediaJobQueueRequest *)request{
    [super performRequest:request];
}

-(void)PostWordsGeneralizeTask:(QCloudPostWordsGeneralizeTaskRequest *)request{
    [super performRequest:(QCloudBizHTTPRequest *)request];
}
-(void)GetWordsGeneralizeTask:(QCloudGetWordsGeneralizeTaskRequest *)request{
    [super performRequest:(QCloudBizHTTPRequest *)request];
}
-(void)ImageRepair:(QCloudCIImageRepairRequest *)request{
    [self buildRequestUrl:request];
}


-(void)DetectCar:(QCloudCIDetectCarRequest *)request{
    [super performRequest:(QCloudBizHTTPRequest *)request];
}
-(void)OCR:(QCloudCIOCRRequest *)request{
    [super performRequest:(QCloudBizHTTPRequest *)request];
}
-(void)BodyRecognition:(QCloudCIBodyRecognitionRequest *)request{
    [super performRequest:(QCloudBizHTTPRequest *)request];
}
-(void)AutoTranslation:(QCloudCIAutoTranslationRequest *)request{
    [super performRequest:(QCloudBizHTTPRequest *)request];
}
-(void)FaceEffect:(QCloudCIFaceEffectRequest *)request{
    [super performRequest:(QCloudBizHTTPRequest *)request];
}
-(void)DetectFace:(QCloudCIDetectFaceRequest *)request{
    [super performRequest:(QCloudBizHTTPRequest *)request];
}
-(void)RecognizeLogo:(QCloudCIRecognizeLogoRequest *)request{
    [super performRequest:(QCloudBizHTTPRequest *)request];
}
-(void)PostGoodsMatting:(QCloudCIPostGoodsMattingRequest *)request{
    [super performRequest:(QCloudBizHTTPRequest *)request];
}
-(void)GetGoodsMatting:(QCloudCIGetGoodsMattingRequest *)request{
    [self buildRequestUrl:(QCloudBizHTTPRequest *)request];
}


-(void)buildRequestUrl:(QCloudBizHTTPRequest *)request{
    request.runOnService = self;
    request.signatureProvider = self.configuration.signatureProvider;
    NSError *error;
    NSURLRequest *urlRequest = [request buildURLRequest:&error];
    if (nil != error) {
        [request onError:error];
        return;
    }
    __block NSString *requestURLString = urlRequest.URL.absoluteString;
    [request.signatureProvider signatureWithFields:request.signatureFields
                                           request:request
                                        urlRequest:(NSMutableURLRequest *)urlRequest
                                         compelete:^(QCloudSignature *signature, NSError *error) {
                                             NSString *authorizatioinString = signature.signature;
                                             if ([requestURLString hasSuffix:@"&"] || [requestURLString hasSuffix:@"?"]) {
                                                 requestURLString = [requestURLString stringByAppendingString:authorizatioinString];
                                             } else if([requestURLString containsString:@"?"] && ![requestURLString hasSuffix:@"&"]){
                                                 requestURLString = [requestURLString stringByAppendingFormat:@"&%@", authorizatioinString];
                                             }else {
                                                 requestURLString = [requestURLString stringByAppendingFormat:@"?%@", authorizatioinString];
                                             }
                                             if (signature.token) {
                                                 requestURLString =
                                                     [requestURLString stringByAppendingFormat:@"&x-cos-security-token=%@", signature.token];
                                             }
    
                                             if (request.finishBlock) {
                                                 request.finishBlock(requestURLString, nil);
                                             }
                                         }];

}

-(void)PostLiveVideoRecognition:(QCloudPostLiveVideoRecognitionRequest *)request{
    [super performRequest:(QCloudBizHTTPRequest *)request];
}
-(void)CancelLiveVideoRecognition:(QCloudCancelLiveVideoRecognitionRequest *)request{
    [super performRequest:(QCloudBizHTTPRequest *)request];
}
-(void)GetLiveVideoRecognition:(QCloudGetLiveVideoRecognitionRequest *)request{
    [super performRequest:(QCloudBizHTTPRequest *)request];
}

-(void)RecognitionBadCase:(QCloudRecognitionBadCaseRequest *)request{
    [super performRequest:(QCloudBizHTTPRequest *)request];
}

-(void)GetPrivateM3U8:(QCloudGetPrivateM3U8Request *)request{
    [self buildRequestUrl:(QCloudBizHTTPRequest *)request];
}

-(void)GetWorkflowDetail:(QCloudGetWorkflowDetailRequest *)request{
    [super performRequest:(QCloudGetWorkflowDetailRequest *)request];
}

-(void)GetListWorkflow:(QCloudGetListWorkflowRequest *)request{
    [super performRequest:(QCloudGetListWorkflowRequest *)request];
}

-(void)PostTriggerWorkflow:(QCloudPostTriggerWorkflowRequest *)request{
    [super performRequest:(QCloudPostTriggerWorkflowRequest *)request];
}

-(void)PostMediaJobs:(QCloudPostMediaJobsRequest *)request{
    [super performRequest:(QCloudPostMediaJobsRequest *)request];
}

-(void)PostAudioTransferJobs:(QCloudPostAudioTransferJobsRequest *)request{
    [super performRequest:(QCloudPostAudioTransferJobsRequest *)request];
}

-(void)PostVideoTag:(QCloudPostVideoTagRequest *)request{
    [super performRequest:(QCloudPostVideoTagRequest *)request];
}

-(void)PostVideoMontage:(QCloudVideoMontageRequest *)request{
    [super performRequest:(QCloudVideoMontageRequest *)request];
}

-(void)PostVideoSnapshot:(QCloudVideoSnapshotRequest *)request{
    [super performRequest:(QCloudVideoSnapshotRequest *)request];
}

-(void)PostTranscode:(QCloudPostTranscodeRequest *)request{
    [super performRequest:(QCloudPostTranscodeRequest *)request];
}

-(void)PostAnimation:(QCloudPostAnimationRequest *)request{
    [super performRequest:(QCloudPostAnimationRequest *)request];
}

-(void)PostConcat:(QCloudPostConcatRequest *)request{
    [super performRequest:(QCloudPostConcatRequest *)request];
}

-(void)PostSmartCover:(QCloudPostSmartCoverRequest *)request{
    [super performRequest:(QCloudPostSmartCoverRequest *)request];
}

-(void)PostVoiceSeparate:(QCloudPostVoiceSeparateRequest *)request{
    [super performRequest:(QCloudPostVoiceSeparateRequest *)request];
}

-(void)PostNumMark:(QCloudPostNumMarkRequest *)request{
    [super performRequest:(QCloudPostNumMarkRequest *)request];
}

-(void)ExtractNumMark:(QCloudExtractNumMarkRequest *)request{
    [super performRequest:(QCloudExtractNumMarkRequest *)request];
}

-(void)PostImageProcess:(QCloudPostImageProcessRequest *)request{
    [super performRequest:(QCloudPostImageProcessRequest *)request];
}

-(void)GetMediaJob:(QCloudGetMediaJobRequest *)request{
    [super performRequest:(QCloudGetMediaJobRequest *)request];
}

-(void)CreateMediaJob:(QCloudCreateMediaJobRequest *)request{
    [super performRequest:(QCloudCreateMediaJobRequest *)request];
}

-(void)GetMediaJobList:(QCloudGetMediaJobListRequest *)request{
    [super performRequest:(QCloudGetMediaJobListRequest *)request];
}

-(void)PostTextAuditReport:(QCloudPostTextAuditReportRequest *)request{
    [super performRequest:(QCloudPostTextAuditReportRequest *)request];
}

-(void)PostImageAuditReport:(QCloudPostImageAuditReportRequest *)request{
    [super performRequest:(QCloudPostImageAuditReportRequest *)request];
}
@end
