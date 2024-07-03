//
//  QCloudCICommonModel.h  
//  QCloudCOSXML
//
//  Created by garenwang on 2023/6/13.
//

#import <Foundation/Foundation.h>
#import "QCloudWorkflowexecutionResult.h"
#import "QCloudMediaInfo.h"
@class QCloudMediaResult;
@class QCloudMediaResultOutputFile;
@class QCloudMediaResultOutputFileMd5Info;
@class QCloudJobsDetailMix;
@class QCloudJobsDetailMixEffectConfig;
@class QCloudContainerSnapshotConfig;
@class QCloudTemplateContainerClipConfig;

@class QCloudAudioConfig;
@class QCloudAudioMix;
@class QCloudCallBackMqConfig;
@class QCloudCreateWorkflowMediaWorkflow;
@class QCloudCreateWorkflowResponseMediaWorkflow;
@class QCloudCreateWorkflowTopology;
@class QCloudEffectConfig;
@class QCloudMediaInfo;
@class QCloudMediaInfoFormat;
@class QCloudMediaInfoStream;
@class QCloudMediaInfoStreamAudio;
@class QCloudMediaInfoStreamSubtitle;
@class QCloudMediaInfoStreamVideo;
@class QCloudMediaResult;
@class QCloudMediaResultMd5Info;
@class QCloudMediaResultOutputFile;
@class QCloudNoiseReduction;
@class QCloudNoiseReductionTempleteResponseTemplate;
@class QCloudNotifyConfig;
@class QCloudSpeechRecognition;
@class QCloudSpeechRecognitionTempleteResponseTemplate;
@class QCloudVideoTargetRec;
@class QCloudVideoTargetTempleteResponseTemplate;
@class QCloudVoiceSeparateTempleteResponseTemplate;
@class QCloudVoiceSeparateTempleteResponseVoiceSeparate;
@class QCloudVoiceSynthesisTempleteResponseTemplate;
@class QCloudVoiceSynthesisTempleteResponseTtsTpl;

@class QCloudPostFileUnzipProcessJobOutput;
@class QCloudPostFileUnzipProcessJobResponseJobsDetail;
@class QCloudPostFileUnzipProcessJobResponseInput;
@class QCloudPostFileUnzipProcessJobResponseOperation;
@class QCloudFileUncompressConfig;
@class QCloudDownloadConfig;
@class QCloudFileUncompressResult;
@class QCloudCreateFileZipProcessJobsResponseJobsDetail;
@class QCloudCreateFileZipProcessJobsResponseOperation;
@class QCloudCreateFileZipProcessJobsOutput;
@class QCloudFileCompressConfig;
@class QCloudFileCompressResult;
@class QCloudPostHashProcessJobsResponseJobsDetail;
@class QCloudPostHashProcessJobsResponseInput;
@class QCloudPostHashProcessJobsResponseOperation;
@class QCloudPostHashProcessJobsFileHashCodeConfig;
@class QCloudPostHashProcessJobsFileHashCodeResult;
@class QCloudQueueList;

@class QCloudFileListContents;
@class QCloudFileListContent;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudCallBackMqConfig : NSObject


///     消息队列所属园区，目前支持园区 sh（上海）、bj（北京）、gz（广州）、cd（成都）、hk（中国香港）    String    是
@property (nonatomic,strong)NSString *MqRegion;

/// 消息队列使用模式，默认 Queue ：
// 主题订阅：Topic
// 队列服务: Queue    String    是
@property (nonatomic,strong)NSString *MqMode;

///     TDMQ 主题名称    String    是
@property (nonatomic,strong)NSString *MqName;
@end

@interface QCloudMediaResult : NSObject

/// 输出文件的基本信息
@property (nonatomic,strong)QCloudMediaResultOutputFile *OutputFile;

@end

@interface QCloudMediaResultOutputFile : NSObject


///  输出文件所在的存储桶    String
@property (nonatomic,strong)NSString *Bucket;

///  输出文件所在的存储桶所在的园区    String
@property (nonatomic,strong)NSString *Region;

///  输出文件名，可能有多个    String 数组
@property (nonatomic,strong)NSString *ObjectName;

///  输出文件的 MD5 信息    Container 数组
@property (nonatomic,strong)NSArray<QCloudMediaResultOutputFileMd5Info *> *Md5Info;

@end

@interface QCloudMediaResultOutputFileMd5Info : NSObject

///  输出文件名
@property (nonatomic,strong)NSString *ObjectName;

///  输出文件的 MD5 值
@property (nonatomic,strong)NSString *Md5;

@end

@interface QCloudPicProcess : NSObject

///  输出文件名 true、false
@property (nonatomic,strong)NSString *IsPicInfo;

///  图片处理规则
///
/// 1. 基础图片处理参见 基础图片处理 文档
/// 2. 图片压缩参见 图片压缩 文档
/// 3. 盲水印参见 盲水印 文档
@property (nonatomic,strong)NSString *ProcessRule;

@end

@interface QCloudDigitalWatermark : NSObject

///  嵌入数字水印的水印信息    String    是    长度不超过64个字符，仅支持中文、英文、数字、_、-和*
@property (nonatomic,strong)NSString *Message;

///  数字水印类型    String    是    当前仅可设置为 Text
@property (nonatomic,strong)NSString *Type;

///  数字水印版本    String    是    当前仅可设置为 V1
@property (nonatomic,strong)NSString *Version;

///  当添加水印失败是否忽略错误继续执行任务    String    是    限制为 true/false
@property (nonatomic,strong)NSString *IgnoreError;

///  添加水印是否成功，执行中为Running，成功为 Success，失败为 Failed    String    否    该字段不能主动设置，当任务提交成功时，会返回该字段
@property (nonatomic,strong)NSString *State;
@end

@interface QCloudJobsDetailMix : NSObject

/// 需要被混音的音轨媒体地址, 需要做 URLEncode
@property (nonatomic,strong)NSString * AudioSource;

/// 混音模式
@property (nonatomic,strong)NSString * MixMode;

/// 是否用混音音轨媒体替换Input媒体文件的原音频
@property (nonatomic,strong)NSString * Replace;

/// 混音淡入淡出配置
@property (nonatomic,strong)QCloudJobsDetailMixEffectConfig * EffectConfig;

@end

@interface QCloudJobsDetailMixEffectConfig : NSObject

/// 开启淡入
@property (nonatomic,strong)NSString * EnableStartFadein;

/// 淡入时长
@property (nonatomic,strong)NSString * StartFadeinTime;

/// 开启淡出
@property (nonatomic,strong)NSString * EnableEndFadeout;

/// 淡出时长
@property (nonatomic,strong)NSString * EndFadeoutTime;

/// 开启 bgm 转换淡入
@property (nonatomic,strong)NSString * EnableBgmFade;

/// bgm 转换淡入时长
@property (nonatomic,strong)NSString * BgmFadeTime;

@end

@interface QCloudAudioVoiceSeparateAudioConfig : NSObject

///     Request.Audio    编解码格式    String    否    aac    取值 aac、mp3、flac、amr
@property (nonatomic,strong)NSString * Codec;

/// Request.Audio    采样率    String    否    44100    1. 单位：Hz
/// 2. 可选 8000、11025、22050、32000、44100、48000、96000
/// 3. 当 Codec 设置为 aac/flac 时，不支持8000
/// 4. 当 Codec 设置为 mp3 时，不支持8000和96000
/// 5. 当 Codec 设置为 amr 时，只支持8000
@property (nonatomic,strong)NSString * Samplerate;

/// Request.Audio    原始音频码率    String    否    无    1. 单位：Kbps 2. 值范围：[8，1000]
@property (nonatomic,strong)NSString * Bitrate;

/// Request.Audio    声道数    String    否    无    1. 当 Codec 设置为 aac/flac，支持1、2、4、5、6、8
/// 2. 当 Codec 设置为 mp3，支持1、2
/// 3. 当 Codec 设置为 amr，只支持1
@property (nonatomic,strong)NSString * Channels;


/// 是否删除源音频流 取值 true、false
@property (nonatomic,strong)NSString * Remove;


/// 保持双音轨 取值 true、false。 当 Video.Codec 为H.265时，此参数无效
@property (nonatomic,strong)NSString * KeepTwoTracks;

/// 采样位宽
///
/// 当 Codec 设置为 aac，支持 fltp
/// 当 Codec 设置为 mp3，支持 fltp、s16p、s32p
/// 当 Codec 设置为 flac，支持s16、s32、s16p、s32p
/// 当 Codec 设置为 amr，支持s16、s16p
/// 当 Codec 设置为 opus，支持s16
/// 当 Codec 设置为 pcm_s16le，支持s16
/// 当 Codec 设置为 Vorbis，支持 fltp
/// 当 Video.Codec 为 H.265 时，此参数无效
@property (nonatomic,strong)NSString * SampleFormat;
@end

@interface QCloudTemplateVideo : NSObject

///     Request.ConcatTemplate.
/// Video    编解码格式    String    是    H.264    H.264
@property (nonatomic,strong)NSString * Codec;

/// 宽    String    否    视频原始宽度
/// 值范围：[128，4096]
/// 单位：px
/// 若只设置 Width 时，按照视频原始比例计算 Height
@property (nonatomic,strong)NSString * Width;
/// 高    String    否    视频原始高度
/// 值范围：[128，4096]
/// 单位：px
/// 若只设置 Height 时，按照视频原始比例计算 Width
@property (nonatomic,strong)NSString * Height;

/// 帧率    String    否    视频原始帧率
/// 值范围：(0，60]
/// 单位：fps
@property (nonatomic,strong)NSString * Fps;

/// 视频输出文件的码率    String    否    视频原始码率
/// 值范围：[10，50000]
/// 单位：Kbps
@property (nonatomic,strong)NSString * Bitrate;
/// Request.ConcatTemplate.
/// Video    码率-质量控制因子    String    否    视频原始码率
/// 值范围：(0, 51]
/// 如果设置了 Crf，则 Bitrate 的设置失效
/// 当 Bitrate 为空时，默认为25
@property (nonatomic,strong)NSString * Crf;

///     是否删除视频流    String    否    false    取值 true、false
@property (nonatomic,strong)NSString * Remove;

///     Request.Video    旋转角度    String    否    无    1. 值范围：[0, 360)
/// 2. 单位：度
@property (nonatomic,strong)NSString * Rotate;


/// 编码级别
/// 支持 baseline、main、high、auto
/// 当 Pixfmt 为 auto 时，该参数仅能设置为 auto，当设置为其他选项时，参数值将被设置为 auto
///  baseline：适合移动设备
/// main：适合标准分辨率设备
/// high：适合高分辨率设备
/// 仅H.264支持此参数
@property (nonatomic,strong)NSString * Profile;
@end


@interface QCloudTemplateContainer : NSObject

/// 封装格式：mp4，flv，hls，ts, mp3, aac
@property (nonatomic,strong)NSString * Format;

/// 分片配置，当 format 为 hls 和 dash 时有效
@property (nonatomic,strong)QCloudTemplateContainerClipConfig * ClipConfig;
@end

@interface QCloudTemplateContainerClipConfig : NSObject
@property (nonatomic,strong)NSString * Duration;
@end

@interface QCloudTemplateTimeInterval : NSObject

/// [0 视频时长]
/// 单位为秒
/// 支持 float 格式，执行精度精确到毫秒
@property (nonatomic,strong)NSString * Start;

/// [0 视频时长]
/// 单位为秒
/// 支持 float 格式，执行精度精确到毫秒
@property (nonatomic,strong)NSString * Duration;
@end


@class QCloudInputPostTranscodeWatermark;
@class QCloudInputPostTranscodeWatermarkImage;
@class QCloudInputPostTranscodeWatermarkText;
@class QCloudInputPostTranscodeWatermarkSlideConfig;
@interface QCloudInputPostTranscodeWatermark : NSObject

/// 水印类型;是否必传：是;;默认值：无;;限制：Text：文字水印、 Image：图片水印;
@property (nonatomic,strong)NSString * Type;

/// 基准位置;是否必传：是;;默认值：无;;限制：TopRight、TopLeft、BottomRight、BottomLeft、Left、Right、Top、Bottom、Center;
@property (nonatomic,strong)NSString * Pos;

/// 偏移方式;是否必传：是;;默认值：无;;限制：Relativity：按比例，Absolute：固定位置;
@property (nonatomic,strong)NSString * LocMode;

/// 水平偏移;是否必传：是;;默认值：无;;限制：1. 在图片水印中，如果 Background 为 true，当 locMode 为 Relativity 时，为%，值范围：[-300 0]；当 locMode 为 Absolute 时，为 px，值范围：[-4096 0] 2. 在图片水印中，如果 Background 为 false，当 locMode 为 Relativity 时，为%，值范围：[0 100]；当 locMode 为 Absolute 时，为 px，值范围：[0 4096]。 3. 在文字水印中，当 locMode 为 Relativity 时，为%，值范围：[0 100]；当 locMode 为 Absolute 时，为 px，值范围：[0 4096]。 4. 当Pos为Top、Bottom和Center时，该参数无效。;
@property (nonatomic,strong)NSString * Dx;

/// 垂直偏移;是否必传：是;;默认值：无;;限制：1. 在图片水印中，如果 Background 为 true，当 locMode 为 Relativity 时，为%，值范围：[-300 0]；当 locMode 为 Absolute 时，为 px，值范围：[-4096 0] 2. 在图片水印中，如果 Background 为 false，当 locMode 为 Relativity 时，为%，值范围：[0 100]；当 locMode 为 Absolute 时，为 px，值范围：[0 4096]。3. 在文字水印中，当 locMode 为 Relativity 时，为%，值范围：[0 100]；当 locMode 为 Absolute 时，为 px，值范围：[0 4096]。4. 当Pos为Left、Right和Center时，该参数无效。;
@property (nonatomic,strong)NSString * Dy;

/// 水印开始时间;是否必传：否;;默认值：0;;限制：1. [0 视频时长]  2. 单位为秒  3. 支持 float 格式，执行精度精确到毫秒;
@property (nonatomic,strong)NSString * StartTime;

/// 水印结束时间;是否必传：否;;默认值：视频结束时间;;限制：1. [0 视频时长]  2. 单位为秒  3. 支持 float 格式，执行精度精确到毫秒;
@property (nonatomic,strong)NSString * EndTime;

/// 水印滑动配置，配置该参数后水印位移设置不生效，极速高清/H265转码暂时不支持该参数;是否必传：否;;限制：无;
@property (nonatomic,strong)QCloudInputPostTranscodeWatermarkSlideConfig * SlideConfig;

/// 图片水印节点;是否必传：否;;限制：无;
@property (nonatomic,strong)QCloudInputPostTranscodeWatermarkImage * Image;

/// 文本水印节点;是否必传：否;;限制：无;
@property (nonatomic,strong)QCloudInputPostTranscodeWatermarkText * Text;

@end

@interface QCloudInputPostTranscodeWatermarkImage : NSObject

/// 水印图地址(需要 Urlencode 后传入);是否必传：是;;默认值：无;;限制：同 bucket 的水印图片地址;
@property (nonatomic,strong)NSString * Url;

/// 尺寸模式;是否必传：是;;默认值：无;;限制：1. Original：原有尺寸  2. Proportion：按比例  3. Fixed：固定大小;
@property (nonatomic,strong)NSString * Mode;

/// 宽;是否必传：否;;默认值：无;;限制：1. 当 Mode 为 Original 时，不支持设置水印图宽度  2. 当 Mode 为 Proportion，单位为%，背景图值范围：[100 300]；前景图值范围：[1 100]，相对于视频宽，最大不超过4096px 3. 当 Mode 为 Fixed，单位为 px，值范围：[8，4096]  4.若只设置 Width 时，按照水印图比例计算 Height;
@property (nonatomic,strong)NSString * Width;

/// 高;是否必传：否;;默认值：无;;限制：1. 当 Mode 为 Original 时，不支持设置水印图高度  2. 当 Mode 为 Proportion，单位为%，背景图值范围：[100 300]；前景图值范围：[1 100]，相对于视频高，最大不超过4096px 3. 当 Mode 为 Fixed，单位为 px，值范围：[8，4096] 4.若只设置 Height 时，按照水印图比例计算 Width;
@property (nonatomic,strong)NSString * Height;

/// 透明度;是否必传：是;;默认值：无;;限制：值范围：[1 100]，单位%;
@property (nonatomic,strong)NSString * Transparency;

/// 是否背景图;是否必传：否;;默认值：FALSE;;限制：true、false;
@property (nonatomic,strong)NSString * Background;

@end

@interface QCloudInputPostTranscodeWatermarkSlideConfig : NSObject

/// 滑动模式;是否必传：是;;默认值：无;;限制：Default: 默认不开启、ScrollFromLeft: 从左到右滚动，若设置了ScrollFromLeft模式，则Watermark.Pos参数不生效;
@property (nonatomic,strong)NSString * SlideMode;

/// 横向滑动速度;是否必传：是;;默认值：无;;限制：取值范围：[0,10]内的整数，默认为0;
@property (nonatomic,strong)NSString * XSlideSpeed;

/// 纵向滑动速度;是否必传：是;;默认值：无;;限制：取值范围：[0,10]内的整数，默认为0;
@property (nonatomic,strong)NSString * YSlideSpeed;

@end

@interface QCloudInputPostTranscodeWatermarkText : NSObject


/// 字体大小  值范围：[5 100]，单位 px
@property (nonatomic,strong)NSString * FontSize;

/// 字体类型   参考下表
@property (nonatomic,strong)NSString * FontType;

/// 字体颜色   格式：0xRRGGBB
@property (nonatomic,strong)NSString * FontColor;

/// 透明度    值范围：[1 100]，单位%
@property (nonatomic,strong)NSString * Transparency;

/// 水印内容   长度不超过64个字符，仅支持中文、英文、数字、_、-和*
@property (nonatomic,strong)NSString * Text;

@end

@interface QCloudInputPostTranscodeDigitalWatermark : NSObject

//距离左上角原点 x 偏移    String    是
//值范围：[0, 4096]
//单位：px
@property (nonatomic,strong)NSString * Dx;
//距离左上角原点 y 偏移    String    是
//值范围：[0, 4096]
//单位：px
@property (nonatomic,strong)NSString * Dy;
//水印的宽度    String    是
//值范围：(0, 4096]
//单位：px
@property (nonatomic,strong)NSString * Width;
//水印的高度    String    是
//值范围：(0, 4096]
//单位：px
@property (nonatomic,strong)NSString * Height;

@end

@class QCloudContainerTransConfigHlsEncrypt;
@class QCloudContainerTransConfigDashEncrypt;
@interface QCloudContainerTransConfig : NSObject

///  分辨率调整方式    String    否    none
@property (nonatomic,strong)NSString * AdjDarMethod;
///  是否检查分辨率    String    否    FALSE
@property (nonatomic,strong)NSString * IsCheckReso;
///  分辨率调整方式    String    否    0
@property (nonatomic,strong)NSString * ResoAdjMethod;
///  是否检查视频码率    String    否    FALSE
@property (nonatomic,strong)NSString * IsCheckVideoBitrate;
///  视频码率调整方式    String    否    0
@property (nonatomic,strong)NSString * VideoBitrateAdjMethod;
///  是否检查音频码率    String    否    FALSE
@property (nonatomic,strong)NSString * IsCheckAudioBitrate;
///  音频码率调整方式    String    否    0
@property (nonatomic,strong)NSString * AudioBitrateAdjMethod;
///  是否检查视频帧率    String    否    FALSE
@property (nonatomic,strong)NSString * IsCheckVideoFps;
///  视频帧率调整方式    String    否    0
@property (nonatomic,strong)NSString * VideoFpsAdjMethod;
///  是否删除文件中的 MetaData 信息    String    否    FALSE
@property (nonatomic,strong)NSString * DeleteMetadata;
///  是否开启 HDR 转 SDR    String    否    FALSE
@property (nonatomic,strong)NSString * IsHdr2Sdr;
///  指定处理的流编号，对应媒体信息中的
@property (nonatomic,strong)NSString * TranscodeIndex;
///  hls 加密配置    Container    否    无
@property (nonatomic,strong)QCloudContainerTransConfigHlsEncrypt * HlsEncrypt;
///  dash 加密配置    Container    否    无
@property (nonatomic,strong)QCloudContainerTransConfigDashEncrypt * DashEncrypt;

@end

@interface QCloudContainerTransConfigHlsEncrypt : NSObject

///  Request.TransConfig.HlsEncrypt    是否开启 HLS 加密    String    否    false 当 Container.Format 为 dash 时支持加密
@property (nonatomic,strong)NSString * IsHlsEncrypt;

///  Request.TransConfig.HlsEncrypt    HLS 加密的 key    String    否    无    当 IsHlsEncrypt 为 true 时，该参数才有意义
@property (nonatomic,strong)NSString * UriKey;
@end

@interface QCloudContainerTransConfigDashEncrypt : NSObject

///  Request.TransConfig.DashEncrypt    是否开启 DASH 加密    String    否    false 当 Container.Format 为 dash 时支持加密
@property (nonatomic,strong)NSString * IsEncrypt;

///  Request.TransConfig.DashEncrypt    DASH 加密的 key    String    否    无    当 IsEncrypt 为 true 时，该参数才有意义
@property (nonatomic,strong)NSString * UriKey;
@end

@interface QCloudContainerSnapshot : NSObject

///  截图模式
@property (nonatomic,strong)NSString * Mode;

///  开始时间
@property (nonatomic,strong)NSString * Start;

///  截图时间间隔
@property (nonatomic,strong)NSString * TimeInterval;

///  截图数量
@property (nonatomic,strong)NSString * Count;

///  宽
@property (nonatomic,strong)NSString * Width;

///  高
@property (nonatomic,strong)NSString * Height;

///  截图图片处理参数
@property (nonatomic,strong)NSString * CIParam;

///  是否强制检查截图个数
@property (nonatomic,strong)NSString * IsCheckCount;

///  是否开启黑屏检测
@property (nonatomic,strong)NSString * IsCheckBlack;

///  截图黑屏检测参数
@property (nonatomic,strong)NSString * BlackLevel;

///  截图黑屏检测参数
@property (nonatomic,strong)NSString * PixelBlackThreshold;

///  截图输出模式参数
@property (nonatomic,strong)NSString * SnapshotOutMode;

///  雪碧图输出配置
@property (nonatomic,strong)QCloudContainerSnapshotConfig * SpriteSnapshotConfig;
@end

@interface QCloudContainerSnapshotConfig : NSObject

/// 单图宽度    String    否    截图宽度
@property (nonatomic,strong)NSString * CellWidth;

/// 单图高度    String    否    截图高度
@property (nonatomic,strong)NSString * CellHeight;

/// 雪碧图内边距大小    String    否    0
@property (nonatomic,strong)NSString * Padding;

/// 雪碧图外边距大小    String    否    0
@property (nonatomic,strong)NSString * Margin;

/// 背景颜色    String    是    无    支持颜色详见 FFmpeg
@property (nonatomic,strong)NSString * Color;

/// 雪碧图列数    String    是    0    值范围：[1，10000]
@property (nonatomic,strong)NSString * Columns;

/// 雪碧图行数    String    是    0    值范围：[1，10000]
@property (nonatomic,strong)NSString * Lines;

/// 雪碧图缩放模式    String    否    DirectScale
@property (nonatomic,strong)NSString * ScaleMethod;


@end


@interface QCloudAudioConfig : NSObject

/// 编解码格式，取值 aac、mp3、flac、amr。当 Request.AudioMode 为 MusicMode 时，仅支持 mp3、wav、acc;是否必传：否
@property (nonatomic,strong) NSString * Codec;

/// 采样率单位：Hz可选 8000、11025、22050、32000、44100、48000、96000当 Codec 设置为 aac/flac 时，不支持 8000当 Codec 设置为 mp3 时，不支持 8000 和 96000当 Codec 设置为 amr 时，只支持 8000当 Request.AudioMode 为 MusicMode 时，该参数无效;是否必传：否
@property (nonatomic,strong) NSString * Samplerate;

/// 音频码率单位：Kbps值范围：[8，1000]当 Request.AudioMode 为 MusicMode 时，该参数无效;是否必传：否
@property (nonatomic,strong) NSString * Bitrate;

/// 声道数当 Codec 设置为 aac/flac，支持1、2、4、5、6、8当 Codec 设置为 mp3，支持1、2 当 Codec 设置为 amr，只支持1当 Request.AudioMode 为 MusicMode 时，该参数无效;是否必传：否
@property (nonatomic,strong) NSString * Channels;

@end

@interface QCloudAudioMix : NSObject

/// 需要被混音的音轨媒体地址, 需要做 URLEncode;是否必传：是
@property (nonatomic,strong) NSString * AudioSource;

/// 混音模式;是否必传：否
@property (nonatomic,strong) NSString * MixMode;

/// 是否用混音音轨媒体替换Input媒体文件的原音频;是否必传：否
@property (nonatomic,strong) NSString * Replace;

/// 混音淡入淡出配置;是否必传：否
@property (nonatomic,strong) QCloudEffectConfig * EffectConfig;

@end

@interface QCloudCreateWorkflowMediaWorkflow : NSObject

/// 工作流名称;是否必传：是
@property (nonatomic,strong) NSString * Name;

/// 工作流状态;是否必传：否
@property (nonatomic,strong) NSString * State;

/// 拓扑信息;是否必传：是
@property (nonatomic,strong) QCloudCreateWorkflowTopology * Topology;

@end

@interface QCloudCreateWorkflowResponseMediaWorkflow : NSObject

/// 工作流名称
@property (nonatomic,strong) NSString * Name;

/// 工作流 ID
@property (nonatomic,strong) NSString * WorkflowId;

/// 工作流状态
@property (nonatomic,strong) NSString * State;

/// 创建时间
@property (nonatomic,strong) NSString * CreateTime;

/// 更新时间
@property (nonatomic,strong) NSString * UpdateTime;

/// 拓扑信息，同请求中的 Request.MediaWorkflow.Topology
@property (nonatomic,strong)NSArray <QCloudCreateWorkflowTopology * > * Topology;

@end

@interface QCloudCreateWorkflowTopology : NSObject

/// 节点依赖关系;是否必传：是
@property (nonatomic,strong) NSDictionary * Dependencies;

/// 节点列表;是否必传：是
@property (nonatomic,strong) NSDictionary * Nodes;

@end

@interface QCloudEffectConfig : NSObject

/// 开启淡入;是否必传：否
@property (nonatomic,strong) NSString * EnableStartFadein;

/// 淡入时长;是否必传：否
@property (nonatomic,strong) NSString * StartFadeinTime;

/// 开启淡出;是否必传：否
@property (nonatomic,strong) NSString * EnableEndFadeout;

/// 淡出时长;是否必传：否
@property (nonatomic,strong) NSString * EndFadeoutTime;

/// 开启 bgm 转换淡入;是否必传：否
@property (nonatomic,strong) NSString * EnableBgmFade;

/// bgm 转换淡入时长;是否必传：否
@property (nonatomic,strong) NSString * BgmFadeTime;

@end


@interface QCloudNoiseReduction : NSObject

/// 封装格式，支持 mp3、m4a、wav;是否必传：否
@property (nonatomic,strong) NSString * Format;

/// 采样率单位：Hz可选 8000、12000、16000、24000、32000、44100、48000;是否必传：否
@property (nonatomic,strong) NSString * Samplerate;

@end

@interface QCloudNoiseReductionTempleteResponseTemplate : NSObject

/// 模板 ID
@property (nonatomic,strong) NSString * TemplateId;

/// 模板名称
@property (nonatomic,strong) NSString * Name;

/// 模板所属存储桶
@property (nonatomic,strong) NSString * BucketId;

/// 模板属性，Custom 或者 Official
@property (nonatomic,strong) NSString * Category;

/// 模板类型，NoiseReduction
@property (nonatomic,strong) NSString * Tag;

/// 更新时间
@property (nonatomic,strong) NSString * UpdateTime;

/// 创建时间
@property (nonatomic,strong) NSString * CreateTime;

/// 同请求体中的 Request.NoiseReduction
@property (nonatomic,strong) QCloudNoiseReduction * NoiseReduction;

@end

@interface QCloudNotifyConfig : NSObject

/// 回调开关OffOn;是否必传：否
@property (nonatomic,strong) NSString * State;

/// 回调事件TaskFinish：任务完成WorkflowFinish：工作流完成;是否必传：否
@property (nonatomic,strong) NSString * Event;

/// 回调格式XMLJSON;是否必传：否
@property (nonatomic,strong) NSString * ResultFormat;

/// 回调类型UrlTDMQ;是否必传：否
@property (nonatomic,strong) NSString * Type;

/// 回调地址，不能为内网地址。;是否必传：否
@property (nonatomic,strong) NSString * Url;

/// TDMQ 使用模式Topic：主题订阅Queue: 队列服务;是否必传：否
@property (nonatomic,strong) NSString * MqMode;

/// TDMQ 所属园区，目前支持园区 sh（上海）、bj（北京）、gz（广州）、cd（成都）、hk（中国香港）;是否必传：否
@property (nonatomic,strong) NSString * MqRegion;

/// TDMQ 主题名称;是否必传：否
@property (nonatomic,strong) NSString * MqName;

@end

@interface QCloudSpeechRecognition : NSObject

/// 开启极速ASR，取值 true/false;是否必传：否
@property (nonatomic,strong) NSString * FlashAsr;

/// 引擎模型类型，分为电话场景和非电话场景。电话场景：8k_zh：电话 8k 中文普通话通用（可用于双声道音频）8k_zh_s：电话 8k 中文普通话话者分离（仅适用于单声道音频）8k_en：电话 8k 英语 非电话场景： 6k_zh：16k 中文普通话通用16k_zh_video：16k 音视频领域16k_en：16k 英语16k_ca：16k 粤语16k_ja：16k 日语16k_zh_edu：中文教育16k_en_edu：英文教育16k_zh_medical：医疗16k_th：泰语16k_zh_dialect：多方言，支持23种方言极速 ASR 支持8k_zh、16k_zh、16k_en、16k_zh_video、16k_zh_dialect、16k_ms（马来语）、16k_zh-PY（中英粤）;是否必传：是
@property (nonatomic,strong) NSString * EngineModelType;

/// 语音声道数：1 表示单声道。EngineModelType为非电话场景仅支持单声道2 表示双声道（仅支持 8k_zh 引擎模型 双声道应分别对应通话双方）仅���持非极速ASR，为非极速ASR时，该参数必填;是否必传：否
@property (nonatomic,strong) NSString * ChannelNum;

/// 识别结果返回形式：0：识别结果文本（含分段时间戳）1：词级别粒度的详细识别结果，不含标点，含语速值（词时间戳列表，一般用于生成字幕场景）2：词级别粒度的详细识别结果（包含标点、语速值）3：标点符号分段，包含每段时间戳，特别适用于字幕场景（包含词级时间、标点、语速值）仅支持非极速ASR;是否必传：否
@property (nonatomic,strong) NSString * ResTextFormat;

/// 是否过滤脏词（目前支持中文普通话引擎）0：不过滤脏词1：过滤脏词2：将脏词替换为 *;是否必传：否
@property (nonatomic,strong) NSString * FilterDirty;

/// 是否过滤语气词（目前支持中文普通话引擎）：0 表示不过滤语气词1 表示部分过滤2 表示严格过滤 ;是否必传：否
@property (nonatomic,strong) NSString * FilterModal;

/// 是否进行阿拉伯数字智能转换（目前支持中文普通话引擎）0：不转换，直接输出中文数字1：根据场景智能转换为阿拉伯数字3 ：打开数学相关数字转换仅支持非极速ASR;是否必传：否
@property (nonatomic,strong) NSString * ConvertNumMode;

/// 是否开启说话人分离0：不开启1：开启(仅支持8k_zh，16k_zh，16k_zh_video，单声道音频)8k电话场景建议使用双声道来区分通话双方，设置ChannelNum=2即可，不用开启说话人分离。;是否必传：否
@property (nonatomic,strong) NSString * SpeakerDiarization;

/// 说话人分离人数（需配合开启说话人分离使用），取值范围：[0, 10]0 代表自动分离（目前仅支持≤6个人）1-10代表指定说话人数分离仅支持非极速ASR;是否必传：否
@property (nonatomic,strong) NSString * SpeakerNumber;

/// 是否过滤标点符号（目前支持中文普通话引擎）0：不过滤。1：过滤句末标点2：过滤所有标点;是否必传：否
@property (nonatomic,strong) NSString * FilterPunc;

/// 输出文件类型，可选txt、srt极速ASR仅支持txt非极速Asr且ResTextFormat为3时仅支持txt;是否必传：否
@property (nonatomic,strong) NSString * OutputFileType;

/// 极速ASR音频格式，支持 wav、pcm、ogg-opus、speex、silk、mp3、m4a、aac极速ASR时，该参数必填;是否必传：否
@property (nonatomic,strong) NSString * Format;

/// 是否识别首个声道0：识别所有声道1：识别首个声道仅支持极速ASR;是否必传：否
@property (nonatomic,strong) NSString * FirstChannelOnly;

/// 是否显示词级别时间戳0：不显示1：显示，不包含标点时间戳2：显示，包含标点时间戳仅支持极速ASR;是否必传：否
@property (nonatomic,strong) NSString * WordInfo;

/// 单标点最多字数，取值范围：[6，40]默认值为 0 表示不开启该功能该参数可用于字幕生成场景，控制单行字幕最大字数当FlashAsr为false时，仅ResTextFormat为3时参数有效;是否必传：否
@property (nonatomic,strong) NSString * SentenceMaxLength;

@end

@interface QCloudSpeechRecognitionTempleteResponseTemplate : NSObject

/// 模板 ID
@property (nonatomic,strong) NSString * TemplateId;

/// 模板名称
@property (nonatomic,strong) NSString * Name;

/// 模板所属存储桶
@property (nonatomic,strong) NSString * BucketId;

/// 模板属性，Custom 或者 Official
@property (nonatomic,strong) NSString * Category;

/// 模板类型，SpeechRecognition
@property (nonatomic,strong) NSString * Tag;

/// 更新时间
@property (nonatomic,strong) NSString * UpdateTime;

/// 创建时间
@property (nonatomic,strong) NSString * CreateTime;

/// 同请求体中的 Request.SpeechRecognition
@property (nonatomic,strong) QCloudSpeechRecognition * SpeechRecognition;

@end

@interface QCloudVideoTargetRec : NSObject

/// 是否开启人体检测，取值 true/false;是否必传：否
@property (nonatomic,strong) NSString * Body;

/// 是否开启宠物检测，取值 true/false;是否必传：否
@property (nonatomic,strong) NSString * Pet;

/// 是否开启车辆检测，取值 true/false;是否必传：否
@property (nonatomic,strong) NSString * Car;

@end

@interface QCloudVideoTargetTempleteResponseTemplate : NSObject

/// 模板 ID
@property (nonatomic,strong) NSString * TemplateId;

/// 模板名称
@property (nonatomic,strong) NSString * Name;

/// 模板所属存储桶
@property (nonatomic,strong) NSString * BucketId;

/// 模板属性，Custom 或者 Official
@property (nonatomic,strong) NSString * Category;

/// 模板类型，VideoTargetRec
@property (nonatomic,strong) NSString * Tag;

/// 更新时间
@property (nonatomic,strong) NSString * UpdateTime;

/// 创建时间
@property (nonatomic,strong) NSString * CreateTime;

/// 同请求体中的 Request.VideoTargetRec
@property (nonatomic,strong) QCloudVideoTargetRec * VideoTargetRec;

@end

@interface QCloudVoiceSeparateTempleteResponseTemplate : NSObject

/// 模板 ID
@property (nonatomic,strong) NSString * TemplateId;

/// 模板名称
@property (nonatomic,strong) NSString * Name;

/// 模板所属存储桶
@property (nonatomic,strong) NSString * BucketId;

/// 模板属性，Custom 或者 Official
@property (nonatomic,strong) NSString * Category;

/// 模板类型，VoiceSeparate
@property (nonatomic,strong) NSString * Tag;

/// 更新时间
@property (nonatomic,strong) NSString * UpdateTime;

/// 创建时间
@property (nonatomic,strong) NSString * CreateTime;

@property (nonatomic,strong) NSString * State;

/// 详细的模板参数
@property (nonatomic,strong) QCloudVoiceSeparateTempleteResponseVoiceSeparate * VoiceSeparate;

@end

@interface QCloudVoiceSeparateTempleteResponseVoiceSeparate : NSObject

/// 同请求体中的 Request.AudioMode
@property (nonatomic,strong) NSString * AudioMode;

/// 同请求体中的 Request.AudioConfig
@property (nonatomic,strong) QCloudAudioConfig * AudioConfig;

@end

@interface QCloudVoiceSynthesisTempleteResponseTemplate : NSObject

/// 模板 ID
@property (nonatomic,strong) NSString * TemplateId;

/// 模板名称
@property (nonatomic,strong) NSString * Name;

/// 模板所属存储桶
@property (nonatomic,strong) NSString * BucketId;

/// 模板属性，Custom 或者 Official
@property (nonatomic,strong) NSString * Category;

/// 模板类型，Tts
@property (nonatomic,strong) NSString * Tag;

/// 更新时间
@property (nonatomic,strong) NSString * UpdateTime;

/// 创建时间
@property (nonatomic,strong) NSString * CreateTime;

/// 详细的模板参数
@property (nonatomic,strong) QCloudVoiceSynthesisTempleteResponseTtsTpl * TtsTpl;

@end

@interface QCloudVoiceSynthesisTempleteResponseTtsTpl : NSObject

/// 同请求体中的 Request.Mode
@property (nonatomic,strong) NSString * Mode;

/// 同请求体中的 Request.Codec
@property (nonatomic,strong) NSString * Codec;

/// 同请求体中的 Request.VoiceType
@property (nonatomic,strong) NSString * VoiceType;

/// 同请求体中的 Request.Volume
@property (nonatomic,strong) NSString * Volume;

/// 同请求体中的 Request.Speed
@property (nonatomic,strong) NSString * Speed;

/// 同请求体中的 Request.Emotion
@property (nonatomic,strong) NSString * Emotion;

@end

@interface QCloudPostFileUnzipProcessJobOutput : NSObject

/// 存储桶的地域。;是否必传：是
@property (nonatomic,strong) NSString * Region;

/// 保存解压后文件的存储桶。;是否必传：是
@property (nonatomic,strong) NSString * Bucket;

@end

@interface QCloudPostFileUnzipProcessJobResponseJobsDetail : NSObject

/// 错误码，只有 State 为 Failed 时有意义。
@property (nonatomic,strong) NSString * Code;

/// 错误描述，只有 State 为 Failed 时有意义。
@property (nonatomic,strong) NSString * Message;

/// 新创建任务的 ID。
@property (nonatomic,strong) NSString * JobId;

/// 表示任务的类型，文件解压默认为：FileUncompress。
@property (nonatomic,strong) NSString * Tag;

/// 任务状态Submitted：已提交，待执行Running：执行中Success：执行成功Failed：执行失败Pause：任务暂停，当暂停队列时，待执行的任务会变为暂停状态Cancel：任务被取消执行
@property (nonatomic,strong) NSString * State;

/// 任务进度百分比，范围为[0, 100]。
@property (nonatomic,assign) NSInteger Progress;

/// 任务的创建时间。
@property (nonatomic,strong) NSString * CreationTime;

/// 任务的开始时间。
@property (nonatomic,strong) NSString * StartTime;

/// 任务的结束时间。
@property (nonatomic,strong) NSString * EndTime;

/// 任务所属的 队列 ID。
@property (nonatomic,strong) NSString * QueueId;

/// 被解压文件的信息。
@property (nonatomic,strong) QCloudPostFileUnzipProcessJobResponseInput * Input;

/// 文件解压的处理规则。
@property (nonatomic,strong) QCloudPostFileUnzipProcessJobResponseOperation * Operation;

@end

@interface QCloudPostFileUnzipProcessJobResponseInput : NSObject

/// 存储桶所在地域。
@property (nonatomic,strong) NSString * Region;

/// 文件所在的存储桶。
@property (nonatomic,strong) NSString * BucketId;

/// 被解压文件的文件名。
@property (nonatomic,strong) NSString * Object;

@end

@interface QCloudPostFileUnzipProcessJobResponseOperation : NSObject

/// 透传用户信息。
@property (nonatomic,strong) NSString * UserData;

/// 同请求中的 Request.Operation.Output。
@property (nonatomic,strong) QCloudPostFileUnzipProcessJobOutput * Output;

/// 同请求中的 Request.Operation.FileUncompressConfig。
@property (nonatomic,strong) QCloudFileUncompressConfig * FileUncompressConfig;

/// 文件解压的结果，任务未完成时不返回。
@property (nonatomic,strong) QCloudFileUncompressResult * FileUncompressResult;

@end

@interface QCloudFileUncompressConfig : NSObject

/// 指定解压后输出文件的前缀，不填则默认保存在存储桶根路径。;是否必传：否
@property (nonatomic,strong) NSString * Prefix;

/// 解压密钥，传入时需先经过 base64编码。;是否必传：否
@property (nonatomic,strong) NSString * UnCompressKey;

/// 指定解压后的文件路径是否需要替换前缀，有效值：0：不添加额外的前缀，解压缩将保存在 Prefix 指定的路径下（不会保留压缩包的名称，仅将压缩包内的文件保存至指定的路径）1：以压缩包本身的名称作为前缀，解压缩将保存在 Prefix 指定的路径下2：以压缩包完整路径作为前缀，此时如果不指定 Prefix，就是解压到压缩包所在的当前路径（包含压缩包本身名称）默认值为0。;是否必传：否
@property (nonatomic,strong) NSString * PrefixReplaced;

/// 解压模式0：全部下载1：解压指定内容默认值为0;是否必传：否
@property (nonatomic,strong) NSString * Mode ;

/// 解压指定内容配置，当 Mode = 1 时必填;是否必传：否
@property (nonatomic,strong) QCloudDownloadConfig * DownloadConfig;

/// 指定查询任务或查看任务回调时，是否需要输出已解压的文件列表。输出的列表将在查询任务响应或回调中的<FileList>字段下展示。限制说明：仅支持展示前1000条文件，1000条以后的文件记录将被截断。如需查看更多文件，建议通过 COS GET Bucket 接口查询。;是否必传：否
@property (nonatomic,assign) BOOL ListingFile;

@end

@interface QCloudDownloadConfig : NSObject

/// 解压该前缀下的文件;是否必传：是
@property (nonatomic,strong) NSString * Prefix ;

/// 解压该文件，最多同时填 1000 个;是否必传：是
@property (nonatomic,strong) NSString * Key ;

@end


@interface QCloudFileUncompressResult : NSObject

/// 解压后文件保存的存储桶的地域。
@property (nonatomic,strong) NSString * Region;

/// 解压后文件保存的存储桶。
@property (nonatomic,strong) NSString * Bucket;

/// 解压后文件的个数。
@property (nonatomic,strong) NSString * FileCount;

/// 提交解压任务时指定了<ListingFile>为 true 时，并且任务状态为已成功完成时返回该节点，表示已解压的文件列表。 限制说明：仅支持展示前1000条文件，1000条以后的文件记录将被截断。 如需查看更多文件，建议通过 COS GET Bucket 接口查询。;是否必传：否
@property (nonatomic,strong) QCloudFileListContents * FileList;

@end

@interface QCloudFileListContents : NSObject

@property (nonatomic,assign) BOOL IsTruncated;

/// 已解压的文件信息，可包含多条。;是否必传：否
@property (nonatomic,strong)NSArray <QCloudFileListContent * > * Contents;

@end

@interface QCloudFileListContent : NSObject

/// 文件名称。;是否必传：否
@property (nonatomic,strong) NSString * Key;

/// 文件的最近一次修改的时间。;是否必传：否
@property (nonatomic,strong) NSString * LastModified;

/// 文件大小。;是否必传：否
@property (nonatomic,assign) NSInteger FileSize;


@end

@interface QCloudCreateFileZipProcessJobsResponseJobsDetail : NSObject

/// 错误码，只有 State 为 Failed 时有意义。
@property (nonatomic,strong) NSString * Code;

/// 错误描述，只有 State 为 Failed 时有意义。
@property (nonatomic,strong) NSString * Message;

/// 新创建任务的 ID。
@property (nonatomic,strong) NSString * JobId;

/// 表示任务的类型，多文件打包压缩默认为：FileCompress。
@property (nonatomic,strong) NSString * Tag;

/// 任务状态Submitted：已提交，待执行。Running：执行中。Success：执行成功。Failed：执行失败。Pause：任务暂停，当暂停队列时，待执行的任务会变为暂停状态。Cancel：任务被取消执行。
@property (nonatomic,strong) NSString * State;

/// 任务进度百分比，范围为[0, 100]。
@property (nonatomic,assign) NSInteger Progress;

/// 任务的创建时间。
@property (nonatomic,strong) NSString * CreationTime;

/// 任务的开始时间。
@property (nonatomic,strong) NSString * StartTime;

/// 任务的结束时间。
@property (nonatomic,strong) NSString * EndTime;

/// 任务所属的 队列 ID。
@property (nonatomic,strong) NSString * QueueId;

@property (nonatomic,strong) NSString * QueueType;
/// 多文件打包压缩的处理规则。
@property (nonatomic,strong) QCloudCreateFileZipProcessJobsResponseOperation * Operation;

@end

@interface QCloudCreateFileZipProcessJobsResponseOperation : NSObject

/// 透传用户信息。
@property (nonatomic,strong) NSString * UserData;

/// 同请求中的 Request.Operation.Output。
@property (nonatomic,strong) QCloudCreateFileZipProcessJobsOutput * Output;

/// 同请求中的 Request.Operation.FileCompressConfig。
@property (nonatomic,strong) QCloudFileCompressConfig * FileCompressConfig;

/// 多文件打包压缩的结果，任务未完成时不返回。
@property (nonatomic,strong) QCloudFileCompressResult * FileCompressResult;

@end

@interface QCloudCreateFileZipProcessJobsOutput : NSObject

/// 存储桶的地域。;是否必传：是
@property (nonatomic,strong) NSString * Region;

/// 保存压缩后文件的存储桶。;是否必传：是
@property (nonatomic,strong) NSString * Bucket;

/// 压缩后文件的文件名;是否必传：是
@property (nonatomic,strong) NSString * Object;

@end

@interface QCloudFileCompressConfig : NSObject

/// 文件打包时，是否需要去除源文件已有的目录结构，有效值：0：不需要去除目录结构，打包后压缩包中的文件会保留原有的目录结构；1：需要，打包后压缩包内的文件会去除原有的目录结构，所有文件都在同一层级。例如：源文件 URL 为 https://domain/source/test.mp4，则源文件路径为 source/test.mp4，如果为 1，则 ZIP 包中该文件路径为 test.mp4；如果为0， ZIP 包中该文件路径为 source/test.mp4。;是否必传：是
@property (nonatomic,strong) NSString * Flatten;

/// 打包压缩的类型，有效值：zip、tar、tar.gz。;是否必传：是
@property (nonatomic,strong) NSString * Format;

/// 压缩类型，仅在Format为tar.gz或zip时有效。faster：压缩速度较快better：压缩质量较高，体积较小default：适中的压缩方式默认值为default;是否必传：否
@property (nonatomic,strong) NSString * Type;

/// 压缩包密钥，传入时需先经过 base64 编码，编码后长度不能超过128。当 Format 为 zip 时生效。;是否必传：否
@property (nonatomic,strong) NSString * CompressKey;

/// 支持将需要打包的文件整理成索引文件，后台将根据索引文件内提供的文件 url，打包为一个压缩包文件。索引文件需要保存在当前存储桶中，本字段需要提供索引文件的对象地址，不需要带域名，填写示例：/test/index.csv索引文件格式：仅支持 CSV 文件，一行一条 URL（仅支持本存储桶文件），如有多列字段，默认取第一列作为URL。;是否必传：否
@property (nonatomic,strong) NSString * UrlList;

/// 支持对存储桶中的某个前缀进行打包，如果需要对某个目录进行打包，需要加/，例如test目录打包，则值为：test/。;是否必传：否
@property (nonatomic,strong) NSString * Prefix;

/// 支持对存储桶中的多个文件进行打包，个数不能超过 1000，如需打包更多文件，请使用UrlList或Prefix参数。;是否必传：否
@property (nonatomic,strong) NSString * Key;

/// 打包时如果单个文件出错，是否忽略错误继续打包。有效值为：ture：忽略错误继续打包后续的文件；false：遇到某个文件执行打包报错时，直接终止打包任务，不返回压缩包。默认值为false。;是否必传：否
@property (nonatomic,strong) NSString * IgnoreError ;

@end

@interface QCloudFileCompressResult : NSObject

/// 打包压缩后文件保存的存储桶的地域。
@property (nonatomic,strong) NSString * Region;

/// 打包压缩后文件保存的存储桶。
@property (nonatomic,strong) NSString * Bucket;

/// 打包压缩后文件的名称。
@property (nonatomic,strong) NSString * Object;

/// 打包文件的总数
@property (nonatomic,strong) NSString * CompressFileCount  ;

/// 打包时出错的文件数
@property (nonatomic,strong) NSString * ErrorCount;

@end

@interface QCloudPostHashProcessJobsResponseJobsDetail : NSObject

/// 错误码，只有 State 为 Failed 时有意义。
@property (nonatomic,strong) NSString * Code;

/// 错误描述，只有 State 为 Failed 时有意义。
@property (nonatomic,strong) NSString * Message;

/// 创建任务的 ID。
@property (nonatomic,strong) NSString * JobId;

/// 表示任务的类型，哈希值计算默认为：FileHashCode。
@property (nonatomic,strong) NSString * Tag;

/// 任务状态Submitted：已提交，待执行。Running：执行中。Success：执行成功。Failed：执行失败。Pause：任务暂停，当暂停队列时，待执行的任务会变为暂停状态。Cancel：任务被取消执行。
@property (nonatomic,strong) NSString * State;

/// 任务进度百分比，范围为[0, 100]。
@property (nonatomic,assign) NSInteger Progress;

/// 任务的创建时间。
@property (nonatomic,strong) NSString * CreationTime;

/// 任务的开始时间。
@property (nonatomic,strong) NSString * StartTime;

/// 任务的结束时间。
@property (nonatomic,strong) NSString * EndTime;

/// 任务所属的 队列 ID。
@property (nonatomic,strong) NSString * QueueId;

@property (nonatomic,strong) NSString * QueueType;

/// 被计算哈希值的文件信息。
@property (nonatomic,strong) QCloudPostHashProcessJobsResponseInput * Input;

/// 哈希值计算的处理规则。
@property (nonatomic,strong) QCloudPostHashProcessJobsResponseOperation * Operation;

@end

@interface QCloudPostHashProcessJobsResponseInput : NSObject

/// 存储桶所在地域。
@property (nonatomic,strong) NSString * Region;

/// 文件所在的存储桶。
@property (nonatomic,strong) NSString * BucketId;

/// 被计算哈希值的文件名。
@property (nonatomic,strong) NSString * Object;

@end

@interface QCloudPostHashProcessJobsResponseOperation : NSObject

/// 透传用户信息。
@property (nonatomic,strong) NSString * UserData;

/// 同请求中的 Request.Operation.FileHashCodeConfig。
@property (nonatomic,strong) QCloudPostHashProcessJobsFileHashCodeConfig * FileHashCodeConfig;

/// 计算得到的文件 hash 值信息，任务未完成时不返回。
@property (nonatomic,strong) QCloudPostHashProcessJobsFileHashCodeResult * FileHashCodeResult;

@end

@interface QCloudPostHashProcessJobsFileHashCodeConfig : NSObject

/// 哈希值的算法类型，支持：MD5、SHA1、SHA256;是否必传：是
@property (nonatomic,strong) NSString * Type;

/// 是否将计算得到的哈希值添加至文件自定义header，有效值：true、false，默认值为 false。自定义 header 根据Type的值变化，例如Type值为MD5时，自定义 header 为 x-cos-meta-md5。;是否必传：否
@property (nonatomic,strong) NSString * AddToHeader;

@end

@interface QCloudPostHashProcessJobsFileHashCodeResult : NSObject

/// MD5 计算结果。
@property (nonatomic,strong) NSString * MD5;

/// SHA1 计算结果。
@property (nonatomic,strong) NSString * SHA1;

/// SHA256 计算结果。
@property (nonatomic,strong) NSString * SHA256;

/// 文件大小。
@property (nonatomic,assign) NSInteger FileSize;

/// 文件的最后修改时间。
@property (nonatomic,strong) NSString * LastModified;

/// 文件的Etag。
@property (nonatomic,strong) NSString * Etag;

@end

@interface QCloudQueueList : NSObject

/// 队列 ID
@property (nonatomic,strong) NSString * QueueId;

/// 队列名字
@property (nonatomic,strong) NSString * Name;

/// 当前状态，Active 或者 Paused
@property (nonatomic,strong) NSString * State;

/// 回调配置
@property (nonatomic,strong) QCloudNotifyConfig * NotifyConfig;

/// 队列最大长度
@property (nonatomic,assign) NSInteger MaxSize;

/// 当前队列最大并行执行的任务数
@property (nonatomic,assign) NSInteger MaxConcurrent;

/// 更新时间
@property (nonatomic,strong) NSString * UpdateTime;

/// 创建时间
@property (nonatomic,strong) NSString * CreateTime;

@end

NS_ASSUME_NONNULL_END
