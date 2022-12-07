//
//  QCloudCOSXMLService+ImageHelper.h
//  Pods-QCloudCOSXMLDemo
//
//  Created by garenwang on 2020/6/8.
//

#import "QCloudCOSXMLService.h"
@class QCloudPutObjectWatermarkRequest;
@class QCloudGetFilePreviewRequest;
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
@class QCloudGetAudioDiscernTaskRequest;
@class QCloudPostAudioDiscernTaskRequest;
@class QCloudGetAudioDiscernOpenBucketListRequest;
@class QCloudOpenAIBucketRequest;
@class QCloudGetAIJobQueueRequest;
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

- (void)GetGenerateSnapshot:(QCloudGetGenerateSnapshotRequest *)request;
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

/// 商品抠图 1. 下载时处理
-(void)GetGoodsMatting:(QCloudCIGetGoodsMattingRequest *)request;

/// 提交直播审核任务
-(void)PostLiveVideoRecognition:(QCloudPostLiveVideoRecognitionRequest *)request;

/// 取消直播审核任务
-(void)CancelLiveVideoRecognition:(QCloudCancelLiveVideoRecognitionRequest *)request;

/// 查询直播审核任务结果
-(void)GetLiveVideoRecognition:(QCloudGetLiveVideoRecognitionRequest *)request;
@end

NS_ASSUME_NONNULL_END
