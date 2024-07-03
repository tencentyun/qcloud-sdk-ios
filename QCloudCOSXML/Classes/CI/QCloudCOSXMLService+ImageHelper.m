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
#import "QCloudCIPicRecognitionRequest.h"
#import "QCloudGetDescribeMediaBucketsRequest.h"
#import "QCloudGetMediaInfoRequest.h"
#import "QCloudGetVideoRecognitionRequest.h"
#import "QCloudPostVideoRecognitionRequest.h"
#import "QCloudGetFilePreviewHtmlRequest.h"

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

#import "QCloudGetAIBucketRequest.h"
#import "QCloudCloseAIBucketRequest.h"
#import "QCloudUpdateAIQueueRequest.h"
#import "QCloudAIImageColoringRequest.h"
#import "QCloudAISuperResolutionRequest.h"
#import "QCloudAIEnhanceImageRequest.h"
#import "QCloudAIImageCropRequest.h"
#import "QCloudCreateQRcodeRequest.h"
#import "QCloudAIGameRecRequest.h"
#import "QCloudAssessQualityRequest.h"
#import "QCloudAIDetectPetRequest.h"
#import "QCloudAIIDCardOCRRequest.h"
#import "QCloudLivenessRecognitionRequest.h"
#import "QCloudGetLiveCodeRequest.h"
#import "QCloudGetActionSequenceRequest.h"
#import "QCloudAILicenseRecRequest.h"
#import "QCloudImageSearchBucketRequest.h"
#import "QCloudAddImageSearchRequest.h"
#import "QCloudGetSearchImageRequest.h"
#import "QCloudDeleteImageSearchRequest.h"
#import "QCloudPostTranslationRequest.h"
#import "QCloudPostWordsGeneralizeRequest.h"
#import "QCloudPostVideoTargetRecRequest.h"
#import "QCloudPostVideoTargetTempleteRequest.h"
#import "QCloudUpdateVideoTargetTempleteRequest.h"
#import "QCloudPostSegmentVideoBodyRequest.h"
#import "QCloudOpenAsrBucketRequest.h"
#import "QCloudCloseAsrBucketRequest.h"
#import "QCloudPostVoiceSeparateTempleteRequest.h"
#import "QCloudUpdateVoiceSeparateTempleteRequest.h"
#import "QCloudPostNoiseReductionRequest.h"
#import "QCloudPostNoiseReductionTempleteRequest.h"
#import "QCloudUpdateNoiseReductionTempleteRequest.h"
#import "QCloudPostVoiceSynthesisRequest.h"
#import "QCloudPostVoiceSynthesisTempleteRequest.h"
#import "QCloudUpdateVoiceSynthesisTempleteRequest.h"
#import "QCloudPostSpeechRecognitionRequest.h"
#import "QCloudPostSpeechRecognitionTempleteRequest.h"
#import "QCloudUpdateSpeechRecognitionTempleteRequest.h"
#import "QCloudPostSoundHoundRequest.h"
#import "QCloudVocalScoreRequest.h"
#import "QCloudCIUploadOperationsRequest.h"
#import "QCloudDescribeFileProcessQueuesRequest.h"
#import "QCloudDescribeFileUnzipJobsRequest.h"
#import "QCloudDescribeFileZipProcessJobsRequest.h"
#import "QCloudCreateFileZipProcessJobsRequest.h"
#import "QCloudCreateHashProcessJobsRequest.h"
#import "QCloudDescribeHashProcessJobsRequest.h"
#import "QCloudPostFileUnzipProcessJobRequest.h"
#import "QCloudPostHashProcessJobsRequest.h"
#import "QCloudUpdateFileProcessQueueRequest.h"
#import "QCloudZipFilePreviewRequest.h"


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

- (void)PostObjectProcess:(QCloudPostObjectProcessRequest *)request {
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
    
    if (request.credential) {
        QCloudAuthentationV5Creator *creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:request.credential];
        QCloudSignature *signature = [creator signatureForData:(NSMutableURLRequest *)urlRequest];
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
        return;
    }
    
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

-(void)GetAIBucket:(QCloudGetAIBucketRequest *)request{
     [super performRequest:(QCloudGetAIBucketRequest *)request];
}

-(void)CloseAIBucket:(QCloudCloseAIBucketRequest *)request{
     [super performRequest:(QCloudCloseAIBucketRequest *)request];
}

-(void)UpdateAIQueue:(QCloudUpdateAIQueueRequest *)request{
     [super performRequest:(QCloudUpdateAIQueueRequest *)request];
}

-(void)AIImageColoring:(QCloudAIImageColoringRequest *)request{
     [super performRequest:(QCloudAIImageColoringRequest *)request];
}

-(void)AISuperResolution:(QCloudAISuperResolutionRequest *)request{
     [super performRequest:(QCloudAISuperResolutionRequest *)request];
}

-(void)AIEnhanceImage:(QCloudAIEnhanceImageRequest *)request{
     [super performRequest:(QCloudAIEnhanceImageRequest *)request];
}

-(void)AIImageCrop:(QCloudAIImageCropRequest *)request{
     [super performRequest:(QCloudAIImageCropRequest *)request];
}

-(void)CreateQRcode:(QCloudCreateQRcodeRequest *)request{
     [super performRequest:(QCloudCreateQRcodeRequest *)request];
}

-(void)AIGameRec:(QCloudAIGameRecRequest *)request{
     [super performRequest:(QCloudAIGameRecRequest *)request];
}

-(void)AssessQuality:(QCloudAssessQualityRequest *)request{
     [super performRequest:(QCloudAssessQualityRequest *)request];
}

-(void)AIDetectPet:(QCloudAIDetectPetRequest *)request{
     [super performRequest:(QCloudAIDetectPetRequest *)request];
}

-(void)AIIDCardOCR:(QCloudAIIDCardOCRRequest *)request{
     [super performRequest:(QCloudAIIDCardOCRRequest *)request];
}

-(void)LivenessRecognition:(QCloudLivenessRecognitionRequest *)request{
     [super performRequest:(QCloudLivenessRecognitionRequest *)request];
}

-(void)GetLiveCode:(QCloudGetLiveCodeRequest *)request{
     [super performRequest:(QCloudGetLiveCodeRequest *)request];
}

-(void)GetActionSequence:(QCloudGetActionSequenceRequest *)request{
     [super performRequest:(QCloudGetActionSequenceRequest *)request];
}

-(void)AILicenseRec:(QCloudAILicenseRecRequest *)request{
     [super performRequest:(QCloudAILicenseRecRequest *)request];
}

-(void)ImageSearchBucket:(QCloudImageSearchBucketRequest *)request{
     [super performRequest:(QCloudImageSearchBucketRequest *)request];
}

-(void)AddImageSearch:(QCloudAddImageSearchRequest *)request{
     [super performRequest:(QCloudAddImageSearchRequest *)request];
}

-(void)GetSearchImage:(QCloudGetSearchImageRequest *)request{
     [super performRequest:(QCloudGetSearchImageRequest *)request];
}

-(void)DeleteImageSearch:(QCloudDeleteImageSearchRequest *)request{
     [super performRequest:(QCloudDeleteImageSearchRequest *)request];
}

-(void)PostTranslation:(QCloudPostTranslationRequest *)request{
     [super performRequest:(QCloudPostTranslationRequest *)request];
}

-(void)PostWordsGeneralize:(QCloudPostWordsGeneralizeRequest *)request{
     [super performRequest:(QCloudPostWordsGeneralizeRequest *)request];
}

-(void)PostVideoTargetRec:(QCloudPostVideoTargetRecRequest *)request{
     [super performRequest:(QCloudPostVideoTargetRecRequest *)request];
}

-(void)PostVideoTargetTemplete:(QCloudPostVideoTargetTempleteRequest *)request{
     [super performRequest:(QCloudPostVideoTargetTempleteRequest *)request];
}

-(void)UpdateVideoTargetTemplete:(QCloudUpdateVideoTargetTempleteRequest *)request{
     [super performRequest:(QCloudUpdateVideoTargetTempleteRequest *)request];
}

-(void)PostSegmentVideoBody:(QCloudPostSegmentVideoBodyRequest *)request{
     [super performRequest:(QCloudPostSegmentVideoBodyRequest *)request];
}

-(void)OpenAsrBucket:(QCloudOpenAsrBucketRequest *)request{
     [super performRequest:(QCloudOpenAsrBucketRequest *)request];
}

-(void)CloseAsrBucket:(QCloudCloseAsrBucketRequest *)request{
     [super performRequest:(QCloudCloseAsrBucketRequest *)request];
}

-(void)PostVoiceSeparateTemplete:(QCloudPostVoiceSeparateTempleteRequest *)request{
     [super performRequest:(QCloudPostVoiceSeparateTempleteRequest *)request];
}

-(void)UpdateVoiceSeparateTemplete:(QCloudUpdateVoiceSeparateTempleteRequest *)request{
     [super performRequest:(QCloudUpdateVoiceSeparateTempleteRequest *)request];
}

-(void)PostNoiseReduction:(QCloudPostNoiseReductionRequest *)request{
     [super performRequest:(QCloudPostNoiseReductionRequest *)request];
}

-(void)PostNoiseReductionTemplete:(QCloudPostNoiseReductionTempleteRequest *)request{
     [super performRequest:(QCloudPostNoiseReductionTempleteRequest *)request];
}

-(void)UpdateNoiseReductionTemplete:(QCloudUpdateNoiseReductionTempleteRequest *)request{
     [super performRequest:(QCloudUpdateNoiseReductionTempleteRequest *)request];
}

-(void)PostVoiceSynthesis:(QCloudPostVoiceSynthesisRequest *)request{
     [super performRequest:(QCloudPostVoiceSynthesisRequest *)request];
}

-(void)PostVoiceSynthesisTemplete:(QCloudPostVoiceSynthesisTempleteRequest *)request{
     [super performRequest:(QCloudPostVoiceSynthesisTempleteRequest *)request];
}

-(void)UpdateVoiceSynthesisTemplete:(QCloudUpdateVoiceSynthesisTempleteRequest *)request{
     [super performRequest:(QCloudUpdateVoiceSynthesisTempleteRequest *)request];
}

-(void)PostSpeechRecognition:(QCloudPostSpeechRecognitionRequest *)request{
     [super performRequest:(QCloudPostSpeechRecognitionRequest *)request];
}

-(void)PostSpeechRecognitionTemplete:(QCloudPostSpeechRecognitionTempleteRequest *)request{
     [super performRequest:(QCloudPostSpeechRecognitionTempleteRequest *)request];
}

-(void)UpdateSpeechRecognitionTemplete:(QCloudUpdateSpeechRecognitionTempleteRequest *)request{
     [super performRequest:(QCloudUpdateSpeechRecognitionTempleteRequest *)request];
}

-(void)PostSoundHound:(QCloudPostSoundHoundRequest *)request{
     [super performRequest:(QCloudPostSoundHoundRequest *)request];
}

-(void)VocalScore:(QCloudVocalScoreRequest *)request{
     [super performRequest:(QCloudVocalScoreRequest *)request];
}
- (void)UploadOperations:(QCloudCIUploadOperationsRequest *)request{
    [super performRequest:(QCloudCIUploadOperationsRequest *)request];
    
}

-(void)DescribeFileProcessQueues:(QCloudDescribeFileProcessQueuesRequest *)request{
     [super performRequest:(QCloudDescribeFileProcessQueuesRequest *)request];
}

-(void)DescribeFileUnzipJobs:(QCloudDescribeFileUnzipJobsRequest *)request{
     [super performRequest:(QCloudDescribeFileUnzipJobsRequest *)request];
}

-(void)DescribeFileZipProcessJobs:(QCloudDescribeFileZipProcessJobsRequest *)request{
     [super performRequest:(QCloudDescribeFileZipProcessJobsRequest *)request];
}

-(void)CreateFileZipProcessJobs:(QCloudCreateFileZipProcessJobsRequest *)request{
     [super performRequest:(QCloudCreateFileZipProcessJobsRequest *)request];
}

-(void)CreateHashProcessJobs:(QCloudCreateHashProcessJobsRequest *)request{
     [super performRequest:(QCloudCreateHashProcessJobsRequest *)request];
}

-(void)DescribeHashProcessJobs:(QCloudDescribeHashProcessJobsRequest *)request{
     [super performRequest:(QCloudDescribeHashProcessJobsRequest *)request];
}

-(void)PostFileUnzipProcessJob:(QCloudPostFileUnzipProcessJobRequest *)request{
     [super performRequest:(QCloudPostFileUnzipProcessJobRequest *)request];
}

-(void)PosthashProcessJobs:(QCloudPostHashProcessJobsRequest *)request{
     [super performRequest:(QCloudPostHashProcessJobsRequest *)request];
}

-(void)UpdateFileProcessQueue:(QCloudUpdateFileProcessQueueRequest *)request{
     [super performRequest:(QCloudUpdateFileProcessQueueRequest *)request];
}

-(void)ZipFilePreview:(QCloudZipFilePreviewRequest *)request{
     [super performRequest:(QCloudZipFilePreviewRequest *)request];
}


@end
