//
//  QCloudCOSXMLService+ImageHelper.h
//  Pods-QCloudCOSXMLDemo
//
//  Created by garenwang on 2020/6/8.
//

#import "QCloudCOSXMLService.h"
@class QCloudPutObjectWatermarkRequest;
@class QCloudPostObjectProcessRequest;
@class QCloudGetRecognitionObjectRequest;
@class QCloudGetFilePreviewRequest;
@class QCloudGetFilePreviewHtmlRequest;
@class QCloudGetGenerateSnapshotRequest;
@class QCloudCICloudDataOperationsRequest;
@class QCloudCIPutObjectQRCodeRecognitionRequest;
@class QCloudQRCodeRecognitionRequest;
@class QCloudCIPicRecognitionRequest;
@class QCloudGetDescribeMediaBucketsRequest;
@class QCloudGetMediaInfoRequest;
@class QCloudGetVideoRecognitionRequest;
@class QCloudPostVideoRecognitionRequest;
@class QCloudGetAudioRecognitionRequest;
@class QCloudPostAudioRecognitionRequest;
@class QCloudGetTextRecognitionRequest;
@class QCloudPostTextRecognitionRequest;
@class QCloudGetDocRecognitionRequest;
@class QCloudPostDocRecognitionRequest;
@class QCloudGetWebRecognitionRequest;
@class QCloudPostWebRecognitionRequest;
@class QCloudBatchimageRecognitionRequest;
@class QCloudSyncImageRecognitionRequest;
@class QCloudGetImageRecognitionRequest;
@class QCloudUpdateAudioDiscernTaskQueueRequest;
@class QCloudGetAudioDiscernTaskQueueRequest;
@class QCloudBatchGetAudioDiscernTaskRequest;
@class QCloudGetDiscernMediaJobsRequest;
@class QCloudGetAudioDiscernTaskRequest;
@class QCloudPostAudioDiscernTaskRequest;
@class QCloudGetAudioDiscernOpenBucketListRequest;
@class QCloudOpenAIBucketRequest;
@class QCloudGetAIJobQueueRequest;
@class QCloudGetMediaJobQueueRequest;
@class QCloudPostWordsGeneralizeTaskRequest;
@class QCloudGetWordsGeneralizeTaskRequest;
@class QCloudCIImageRepairRequest;
@class QCloudCIDetectCarRequest;
@class QCloudCIOCRRequest;
@class QCloudCIBodyRecognitionRequest;
@class QCloudCIAutoTranslationRequest;
@class QCloudCIFaceEffectRequest;
@class QCloudCIDetectFaceRequest;
@class QCloudCIRecognizeLogoRequest;
@class QCloudCIPostGoodsMattingRequest;
@class QCloudCIGetGoodsMattingRequest;
@class QCloudCIImageRepairRequest;
@class QCloudPostLiveVideoRecognitionRequest;
@class QCloudCancelLiveVideoRecognitionRequest;
@class QCloudGetLiveVideoRecognitionRequest;
@class QCloudRecognitionBadCaseRequest;
@class QCloudGetPrivateM3U8Request;
@class QCloudUpdateMediaQueueRequest;
@class QCloudGetWorkflowDetailRequest;
@class QCloudGetListWorkflowRequest;
@class QCloudPostTriggerWorkflowRequest;
@class QCloudPostMediaJobsRequest;
@class QCloudPostAudioTransferJobsRequest;
@class QCloudPostVideoTagRequest;
@class QCloudVideoMontageRequest;
@class QCloudVideoSnapshotRequest;
@class QCloudPostTranscodeRequest;
@class QCloudPostAnimationRequest;
@class QCloudPostConcatRequest;
@class QCloudPostSmartCoverRequest;
@class QCloudPostVoiceSeparateRequest;
@class QCloudPostNumMarkRequest;
@class QCloudExtractNumMarkRequest;
@class QCloudPostImageProcessRequest;
@class QCloudGetMediaJobRequest;
@class QCloudCreateMediaJobRequest;
@class QCloudGetMediaJobListRequest;
@class QCloudPostTextAuditReportRequest;
@class QCloudPostImageAuditReportRequest;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudCOSXMLService (ImageHelper)

/**
盲水印功能.
*/
- (void)PutWatermarkObject:(QCloudPutObjectWatermarkRequest *)request;

/**
COS 文档预览方法.
*/
- (void)GetFilePreviewObject:(QCloudGetFilePreviewRequest *)request;

//云上数据处理
- (void)CloudDataOperations:(QCloudCICloudDataOperationsRequest *)request;
/**
 上传时识别二维码
 */
- (void)PutObjectQRCodeRecognition:(QCloudCIPutObjectQRCodeRecognitionRequest *)request;
/**
 下载时识别二维码
 */
- (void)CIQRCodeRecognition:(QCloudQRCodeRecognitionRequest *)request;

/// 图片标签
- (void)CIPicRecognition:(QCloudCIPicRecognitionRequest *)request;

- (void)CIGetDescribeMediaBuckets:(QCloudGetDescribeMediaBucketsRequest *)request;

- (void)CIGetMediaInfo:(QCloudGetMediaInfoRequest *)request;

/// 图片审核
- (void)BatchImageRecognition:(QCloudBatchimageRecognitionRequest *)request;
- (void)SyncImageRecognition:(QCloudSyncImageRecognitionRequest *)request;
- (void)GetImageRecognition:(QCloudGetImageRecognitionRequest *)request;

/// 视频审核
- (void)GetVideoRecognition:(QCloudGetVideoRecognitionRequest *)request;
- (void)PostVideoRecognition:(QCloudPostVideoRecognitionRequest *)request;

/// 音频审核
- (void)PostAudioRecognition:(QCloudPostAudioRecognitionRequest *)request;
- (void)GetAudioRecognition:(QCloudGetAudioRecognitionRequest *)request;

/// 文本审核
- (void)GetTextRecognition:(QCloudGetTextRecognitionRequest *)request;
- (void)PostTextRecognition:(QCloudPostTextRecognitionRequest *)request;

/// 文档审核
- (void)PostDocRecognition:(QCloudPostDocRecognitionRequest *)request;
- (void)GetDocRecognition:(QCloudGetDocRecognitionRequest *)request;

/// 网页审核
- (void)GetWebRecognition:(QCloudGetWebRecognitionRequest *)request;
- (void)PostWebRecognition:(QCloudPostWebRecognitionRequest *)request;

/// 更新语音识别队列
-(void)UpdateAudioDiscernTaskQueue:(QCloudUpdateAudioDiscernTaskQueueRequest *)request;

/// 查询语音识别队列
-(void)GetAudioDiscernTaskQueue:(QCloudGetAudioDiscernTaskQueueRequest *)request;

/// 批量拉取语音识别任务
-(void)BatchGetAudioDiscernTask:(QCloudBatchGetAudioDiscernTaskRequest *)request;

-(void)GetDiscernMediaJobs:(QCloudGetDiscernMediaJobsRequest *)request;

/// 查询指定的语音识别任务
-(void)GetAudioDiscernTask:(QCloudGetAudioDiscernTaskRequest *)request;

/// 提交语音识别任务
-(void)PostAudioDiscernTask:(QCloudPostAudioDiscernTaskRequest *)request;

/// 查询存储桶是否已开通语音识别功能。
-(void)GetAudioDiscernOpenBucketList:(QCloudGetAudioDiscernOpenBucketListRequest *)request;

/// 开通AI 内容识别服务并生成队列
-(void)OpenAIBucket:(QCloudOpenAIBucketRequest *)request;

/// 搜索AI 内容识别队列。
-(void)GetAIJobQueue:(QCloudGetAIJobQueueRequest *)request;

/// 搜索媒体处理队列。
-(void)GetMediaJobQueue:(QCloudGetMediaJobQueueRequest *)request;

/// 更新媒体处理队列
-(void)UpdateMediaJobQueue:(QCloudUpdateMediaQueueRequest *)request;

/// 提交一个分词任务。
-(void)PostWordsGeneralizeTask:(QCloudPostWordsGeneralizeTaskRequest *)request;

/// 查询分词任务的状态或结果。。
-(void)GetWordsGeneralizeTask:(QCloudGetWordsGeneralizeTaskRequest *)request;

/// 图像修复
-(void)ImageRepair:(QCloudCIImageRepairRequest *)request;

/// 车辆车牌检测
-(void)DetectCar:(QCloudCIDetectCarRequest *)request;

/// 通用文字识别
-(void)OCR:(QCloudCIOCRRequest *)request;

/// 人体识别
-(void)BodyRecognition:(QCloudCIBodyRecognitionRequest *)request;

/// 实时文字翻译
-(void)AutoTranslation:(QCloudCIAutoTranslationRequest *)request;

/// 人脸特效
-(void)FaceEffect:(QCloudCIFaceEffectRequest *)request;

/// 人脸检测
-(void)DetectFace:(QCloudCIDetectFaceRequest *)request;

/// Logo 识别
-(void)RecognizeLogo:(QCloudCIRecognizeLogoRequest *)request;

/// 商品抠图  云上数据处理
-(void)PostGoodsMatting:(QCloudCIPostGoodsMattingRequest *)request;

- (void)GetFilePreviewHtmlObject:(QCloudGetFilePreviewHtmlRequest *)request;

- (void)GetGenerateSnapshot:(QCloudGetGenerateSnapshotRequest *)request;

/// 商品抠图 1. 下载时处理
-(void)GetGoodsMatting:(QCloudCIGetGoodsMattingRequest *)request;

/// 提交直播审核任务
-(void)PostLiveVideoRecognition:(QCloudPostLiveVideoRecognitionRequest *)request;

/// 取消直播审核任务
-(void)CancelLiveVideoRecognition:(QCloudCancelLiveVideoRecognitionRequest *)request;

- (void)PostObjectProcess:(QCloudPostObjectProcessRequest *)request;

/// 查询直播审核任务结果
-(void)GetLiveVideoRecognition:(QCloudGetLiveVideoRecognitionRequest *)request;

/// 本接口用于提交一个内容审核的Bad Case，例如被判定为正常的涉黄图片或者被判定为涉黄的正常图片。
-(void)RecognitionBadCase:(QCloudRecognitionBadCaseRequest *)request;

/// 用于获取私有 M3U8 ts 资源的下载授权。
-(void)GetPrivateM3U8:(QCloudGetPrivateM3U8Request *)request;

/// 获取工作流实例详情。
-(void)GetWorkflowDetail:(QCloudGetWorkflowDetailRequest *)request;

/// 查询工作流
-(void)GetListWorkflow:(QCloudGetListWorkflowRequest *)request;

/// 测试工作流
-(void)PostTriggerWorkflow:(QCloudPostTriggerWorkflowRequest *)request;

/// 获取媒体信息任务
-(void)PostMediaJobs:(QCloudPostMediaJobsRequest *)request;

/// 音视频转封装
-(void)PostAudioTransferJobs:(QCloudPostAudioTransferJobsRequest *)request;

/// 视频标签
-(void)PostVideoTag:(QCloudPostVideoTagRequest *)request;

/// 精彩集锦
-(void)PostVideoMontage:(QCloudVideoMontageRequest *)request;

/// 视频截图
-(void)PostVideoSnapshot:(QCloudVideoSnapshotRequest *)request;

/// 音视频转码
-(void)PostTranscode:(QCloudPostTranscodeRequest *)request;

/// 视频转动图
-(void)PostAnimation:(QCloudPostAnimationRequest *)request;

/// 音视频拼接
-(void)PostConcat:(QCloudPostConcatRequest *)request;

///  智能封面
-(void)PostSmartCover:(QCloudPostSmartCoverRequest *)request;

/// 人声分离
-(void)PostVoiceSeparate:(QCloudPostVoiceSeparateRequest *)request;

/// 数字水印
-(void)PostNumMark:(QCloudPostNumMarkRequest *)request;

/// 提取数字水印
-(void)ExtractNumMark:(QCloudExtractNumMarkRequest *)request;

/// 图片处理
-(void)PostImageProcess:(QCloudPostImageProcessRequest *)request;

/// 查询指定任务
-(void)GetMediaJob:(QCloudGetMediaJobRequest *)request;

/// 提交多任务处理
-(void)CreateMediaJob:(QCloudCreateMediaJobRequest *)request;

/// 获取符合条件的任务列表
-(void)GetMediaJobList:(QCloudGetMediaJobListRequest *)request;

-(void)PostTextAuditReport:(QCloudPostTextAuditReportRequest *)request;

-(void)PostImageAuditReport:(QCloudPostImageAuditReportRequest *)request;


@end

NS_ASSUME_NONNULL_END
