//
//  QCloudCOSXMLService+ImageHelper.h
//  Pods-QCloudCOSXMLDemo
//
//  Created by garenwang on 2020/6/8.
//

#import "QCloudCOSXMLService.h"
#import "QCloudCICloudDataOperationsRequest.h"

@class QCloudPutObjectWatermarkRequest;
@class QCloudGetRecognitionObjectRequest;
@class QCloudGetFilePreviewRequest;
@class QCloudGetFilePreviewHtmlRequest;
@class QCloudGetGenerateSnapshotRequest;
@class QCloudCICloudDataOperationsRequest;
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
@class QCloudOpenAIBucketRequest;
@class QCloudGetAIBucketRequest;
@class QCloudCloseAIBucketRequest;
@class QCloudUpdateAIQueueRequest;
@class QCloudAIImageColoringRequest;
@class QCloudAISuperResolutionRequest;
@class QCloudAIEnhanceImageRequest;
@class QCloudAIImageCropRequest;
@class QCloudCreateQRcodeRequest;
@class QCloudAIGameRecRequest;
@class QCloudAssessQualityRequest;
@class QCloudAIDetectPetRequest;
@class QCloudAIIDCardOCRRequest;
@class QCloudLivenessRecognitionRequest;
@class QCloudGetLiveCodeRequest;
@class QCloudGetActionSequenceRequest;

@class QCloudAILicenseRecRequest;
@class QCloudImageSearchBucketRequest;
@class QCloudAddImageSearchRequest;
@class QCloudGetSearchImageRequest;
@class QCloudDeleteImageSearchRequest;
@class QCloudPostTranslationRequest;
@class QCloudPostWordsGeneralizeRequest;
@class QCloudPostVideoTargetRecRequest;
@class QCloudPostVideoTargetTempleteRequest;
@class QCloudUpdateVideoTargetTempleteRequest;
@class QCloudPostSegmentVideoBodyRequest;
@class QCloudOpenAsrBucketRequest;
@class QCloudCloseAsrBucketRequest;
@class QCloudPostVoiceSeparateTempleteRequest;
@class QCloudUpdateVoiceSeparateTempleteRequest;
@class QCloudPostNoiseReductionRequest;
@class QCloudPostNoiseReductionTempleteRequest;
@class QCloudUpdateNoiseReductionTempleteRequest;
@class QCloudPostVoiceSynthesisRequest;
@class QCloudPostVoiceSynthesisTempleteRequest;
@class QCloudUpdateVoiceSynthesisTempleteRequest;
@class QCloudPostSpeechRecognitionRequest;
@class QCloudPostSpeechRecognitionTempleteRequest;
@class QCloudUpdateSpeechRecognitionTempleteRequest;
@class QCloudPostSoundHoundRequest;
@class QCloudVocalScoreRequest;
@class QCloudCIUploadOperationsRequest;
@class QCloudDescribeFileProcessQueuesRequest;
@class QCloudDescribeFileUnzipJobsRequest;
@class QCloudDescribeFileZipProcessJobsRequest;
@class QCloudCreateFileZipProcessJobsRequest;
@class QCloudCreateHashProcessJobsRequest;
@class QCloudDescribeHashProcessJobsRequest;
@class QCloudPostFileUnzipProcessJobRequest;
@class QCloudPostHashProcessJobsRequest;
@class QCloudUpdateFileProcessQueueRequest;
@class QCloudZipFilePreviewRequest;
 
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

// 兼容老版本
- (void)PostObjectProcess:(QCloudPostObjectProcessRequest *)request;

// 上传时处理
- (void)UploadOperations:(QCloudCIUploadOperationsRequest *)request;

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

- (void)GetFilePreviewHtmlObject:(QCloudGetFilePreviewHtmlRequest *)request;

- (void)GetGenerateSnapshot:(QCloudGetGenerateSnapshotRequest *)request;

/// 商品抠图 1. 下载时处理
-(void)GetGoodsMatting:(QCloudCIGetGoodsMattingRequest *)request;

/// 提交直播审核任务
-(void)PostLiveVideoRecognition:(QCloudPostLiveVideoRecognitionRequest *)request;

/// 取消直播审核任务
-(void)CancelLiveVideoRecognition:(QCloudCancelLiveVideoRecognitionRequest *)request;

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


/// 查询AI内容识别服务
/// 本接口用于查询已经开通AI 内容识别（异步）服务的存储桶
-(void)GetAIBucket:(QCloudGetAIBucketRequest *)request;

/// 关闭AI内容识别服务
/// 本接口用于关闭AI 内容识别（异步）服务并删除队列
-(void)CloseAIBucket:(QCloudCloseAIBucketRequest *)request;

/// 更新AI内容识别队列
/// 本接口用于更新AI 内容识别（异步）的队列
-(void)UpdateAIQueue:(QCloudUpdateAIQueueRequest *)request;

/// 图片上色
/// 腾讯云数据万象通过 AIImageColoring 接口对黑白图像进行上色
-(void)AIImageColoring:(QCloudAIImageColoringRequest *)request;

/// 图像超分
/// 腾讯云数据万象通过 AISuperResolution 接口对图像进行超分辨率处理，当前默认超分为宽高的2倍
-(void)AISuperResolution:(QCloudAISuperResolutionRequest *)request;

/// 图像增强
/// 腾讯云数据万象通过 AIEnhanceImage 接口对图像进行增强处理
-(void)AIEnhanceImage:(QCloudAIEnhanceImageRequest *)request;

/// 图像智能裁剪
/// 腾讯云数据万象通过 AIImageCrop 接口对图像进行智能裁剪，支持持久化、云上处理及下载时处理
-(void)AIImageCrop:(QCloudAIImageCropRequest *)request;

/// 图片二维码生成
/// 数据万象二维码生成功能可根据用户指定的文本信息（URL 或文本），生成对应的二维码或条形码
-(void)CreateQRcode:(QCloudCreateQRcodeRequest *)request;

/// 游戏场景识别
/// 游戏标签功能实现游戏图片场景的识别，返回图片中置信度较高的游戏类别标签。游戏标签识别请求包属于 GET 请求，请求时需要携带签名
-(void)AIGameRec:(QCloudAIGameRecRequest *)request;

/// 图片质量评分
/// 图片质量评分功能为同步请求方式，您可以通过本接口对图片文件进行检测，从多方面评估，最终给出综合可观的清晰度评分和主观的美观度评分。该接口属于 GET 请求
-(void)AssessQuality:(QCloudAssessQualityRequest *)request;

/// 宠物识别
/// 腾讯云数据万象通过 detect-pet 接口识别并输出画面中宠物，输出其位置（矩形框）和置信度。图片宠物识别请求包属于 GET 请求，请求时需要携带签名
-(void)AIDetectPet:(QCloudAIDetectPetRequest *)request;

/// 身份证识别
/// 支持中国大陆居民二代身份证正反面所有字段的识别，包括姓名、性别、民族、出生日期、住址、公民身份证号、签发机关、有效期限；具备身份证照片、人像照片的裁剪功能和翻拍、PS、复印件告警功能，以及边框和框内遮挡告警、临时身份证告警和身份证有效期不合法告警等扩展功能
-(void)AIIDCardOCR:(QCloudAIIDCardOCRRequest *)request;

/// 活体人脸核身
/// 集成了活体检测和跟权威库进行比对的能力，传入一段视频和姓名、身份证号信息即可进行验证。对录制的自拍视频进行活体检测，从而确认当前用户为真人，可防止照片、视频、静态3D建模等各种不同类型的攻击。检测为真人后，再判断该视频中的人与权威库的证件照是否属于同一个人，实现用户身份信息核实
-(void)LivenessRecognition:(QCloudLivenessRecognitionRequest *)request;

/// 获取数字验证码
/// 使用数字活体检测模式前，需调用本接口获取数字验证码
-(void)GetLiveCode:(QCloudGetLiveCodeRequest *)request;

/// 获取动作顺序
/// 使用动作活体检测模式前，需调用本接口获取动作顺序
-(void)GetActionSequence:(QCloudGetActionSequenceRequest *)request;

/// 卡证识别
/// 本接口支持中国大陆居民二代身份证正面（暂不支持背面）、驾驶证主页（暂不支持副页）所有字段的自动定位，暂不支持文本识别，用于对特定字段的抹除、屏蔽，以及进一步的文本识别
-(void)AILicenseRec:(QCloudAILicenseRecRequest *)request;

/// 开通以图搜图
/// 该接口用于开通 Bucket 搜图功能
-(void)ImageSearchBucket:(QCloudImageSearchBucketRequest *)request;

/// 添加图库图片
/// 该接口用于添加图库图片
-(void)AddImageSearch:(QCloudAddImageSearchRequest *)request;

/// 图片搜索接口
/// 该接口用于检索图片
-(void)GetSearchImage:(QCloudGetSearchImageRequest *)request;

/// 删除图库图片
/// 该接口用于删除图库图片
-(void)DeleteImageSearch:(QCloudDeleteImageSearchRequest *)request;

/// 提交任务
/// 提交一个翻译任务
-(void)PostTranslation:(QCloudPostTranslationRequest *)request;

/// 提交任务
/// 提交一个分词任务
-(void)PostWordsGeneralize:(QCloudPostWordsGeneralizeRequest *)request;

/// 提交任务
/// 提交一个视频目标检测任务
-(void)PostVideoTargetRec:(QCloudPostVideoTargetRecRequest *)request;

/// 创建模板
/// 创建视频目标检测模板
-(void)PostVideoTargetTemplete:(QCloudPostVideoTargetTempleteRequest *)request;

/// 更新模板
/// 更新视频目标检测模板
-(void)UpdateVideoTargetTemplete:(QCloudUpdateVideoTargetTempleteRequest *)request;

/// 提交任务
/// 提交一个视频人像抠图任务
-(void)PostSegmentVideoBody:(QCloudPostSegmentVideoBodyRequest *)request;

/// 开通智能语音服务
/// 本接口用于开通智能语音服务并生成队列
-(void)OpenAsrBucket:(QCloudOpenAsrBucketRequest *)request;

/// 关闭智能语音服务
/// 本接口用于关闭智能语音服务并删除队列
-(void)CloseAsrBucket:(QCloudCloseAsrBucketRequest *)request;

/// 创建模板
/// 创建人声分离模板
-(void)PostVoiceSeparateTemplete:(QCloudPostVoiceSeparateTempleteRequest *)request;

/// 更新模板
/// 更新人声分离转码模板
-(void)UpdateVoiceSeparateTemplete:(QCloudUpdateVoiceSeparateTempleteRequest *)request;

/// 提交任务
/// 提交一个音频降噪任务
-(void)PostNoiseReduction:(QCloudPostNoiseReductionRequest *)request;

/// 创建模板
/// 创建音频降噪模板
-(void)PostNoiseReductionTemplete:(QCloudPostNoiseReductionTempleteRequest *)request;

/// 更新模板
/// 更新音频降噪模板
-(void)UpdateNoiseReductionTemplete:(QCloudUpdateNoiseReductionTempleteRequest *)request;

/// 提交任务
/// 提交一个语音合成任务
-(void)PostVoiceSynthesis:(QCloudPostVoiceSynthesisRequest *)request;

/// 创建模板
/// 创建语音合成模板
-(void)PostVoiceSynthesisTemplete:(QCloudPostVoiceSynthesisTempleteRequest *)request;

/// 更新模板
/// 更新语音合成模板
-(void)UpdateVoiceSynthesisTemplete:(QCloudUpdateVoiceSynthesisTempleteRequest *)request;

/// 提交任务
/// 提交一个语音识别任务
-(void)PostSpeechRecognition:(QCloudPostSpeechRecognitionRequest *)request;

/// 创建模板
/// 创建语音识别模板
-(void)PostSpeechRecognitionTemplete:(QCloudPostSpeechRecognitionTempleteRequest *)request;

/// 更新模板
/// 更新语音识别模板
-(void)UpdateSpeechRecognitionTemplete:(QCloudUpdateSpeechRecognitionTempleteRequest *)request;

/// 提交任务
/// 提交一个听歌识曲任务
-(void)PostSoundHound:(QCloudPostSoundHoundRequest *)request;

/// 提交任务
/// 提交一个音乐评分任务
-(void)VocalScore:(QCloudVocalScoreRequest *)request;

/// 查询文件处理队列
/// 本接口用于查询文件处理队列
-(void)DescribeFileProcessQueues:(QCloudDescribeFileProcessQueuesRequest *)request;

/// 查询文件解压结果
/// 本接口用于主动查询指定的文件解压任务结果
-(void)DescribeFileUnzipJobs:(QCloudDescribeFileUnzipJobsRequest *)request;

/// 查询多文件打包压缩结果
/// 本接口用于主动查询指定的多文件打包压缩任务结果
-(void)DescribeFileZipProcessJobs:(QCloudDescribeFileZipProcessJobsRequest *)request;

/// 提交多文件打包压缩任务
/// 多文件打包压缩功能可以将您的多个文件，打包为 zip 等压缩包格式，以提交任务的方式进行多文件打包压缩，异步返回打包后的文件，该接口属于 POST 请求
-(void)CreateFileZipProcessJobs:(QCloudCreateFileZipProcessJobsRequest *)request;

/// 哈希值计算同步请求
/// 以同步请求的方式进行文件哈希值计算，实时返回计算得到的哈希值，该接口属于 GET 请求
-(void)CreateHashProcessJobs:(QCloudCreateHashProcessJobsRequest *)request;

/// 查询哈希值计算结果
/// 本接口用于主动查询指定的文件哈希值计算任务结果
-(void)DescribeHashProcessJobs:(QCloudDescribeHashProcessJobsRequest *)request;

/// 提交文件解压任务
/// 以提交任务的方式进行压缩包文件的解压缩，异步返回压缩包内的全部或部分文件，该接口属于 POST 请求
-(void)PostFileUnzipProcessJob:(QCloudPostFileUnzipProcessJobRequest *)request;

/// 提交哈希值计算任务
/// 以提交任务的方式进行文件哈希值计算，异步返回计算得到的哈希值，该接口属于 POST 请求
-(void)PosthashProcessJobs:(QCloudPostHashProcessJobsRequest *)request;

/// 更新文件处理队列
/// 本接口用于更新文件处理的队列
-(void)UpdateFileProcessQueue:(QCloudUpdateFileProcessQueueRequest *)request;

/// 压缩包预览
/// 该接口可以在不解压文件的情况下预览压缩包内的内容，包含文件数量、名称、文件时间等，接口为同步请求方式
-(void)ZipFilePreview:(QCloudZipFilePreviewRequest *)request;



@end

NS_ASSUME_NONNULL_END
