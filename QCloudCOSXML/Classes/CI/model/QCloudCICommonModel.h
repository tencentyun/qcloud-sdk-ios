//
//  QCloudCICommonModel.h  
//  QCloudCOSXML
//
//  Created by garenwang on 2023/6/13.
//

#import <Foundation/Foundation.h>
#import "QCloudWorkflowexecutionResult.h"
@class QCloudMediaResult;
@class QCloudMediaResultOutputFile;
@class QCloudMediaResultOutputFileMd5Info;
@class QCloudJobsDetailMix;
@class QCloudJobsDetailMixEffectConfig;
@class QCloudContainerSnapshotConfig;
@class QCloudTemplateContainerClipConfig;
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
NS_ASSUME_NONNULL_END
