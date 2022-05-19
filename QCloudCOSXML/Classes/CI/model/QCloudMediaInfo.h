//
//  QCloudMediaInfo.h
//  QCloudCOSXML
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.
//
//   ██████╗  ██████╗██╗      ██████╗ ██╗   ██╗██████╗     ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗         ██╗      █████╗
//   ██████╗
//  ██╔═══██╗██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║         ██║ ██╔══██╗██╔══██╗
//  ██║   ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║         ██║ ███████║██████╔╝
//  ██║▄▄ ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║         ██║ ██╔══██║██╔══██╗
//  ╚██████╔╝╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝       ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗    ███████╗██║
//  ██║██████╔╝
//   ╚══▀▀═╝  ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝        ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝    ╚══════╝╚═╝ ╚═╝╚═════╝
//
//
//                                                                              _             __                 _                _
//                                                                             (_)           / _|               | |              | |
//                                                          ___  ___ _ ____   ___  ___ ___  | |_ ___  _ __    __| | _____   _____| | ___  _ __   ___ _
//                                                          __ ___
//                                                         / __|/ _ \ '__\ \ / / |/ __/ _ \ |  _/ _ \| '__|  / _` |/ _ \ \ / / _ \ |/ _ \| '_ \ / _ \
//                                                         '__/ __|
//                                                         \__ \  __/ |   \ V /| | (_|  __/ | || (_) | |    | (_| |  __/\ V /  __/ | (_) | |_) |  __/
//                                                         |  \__
//                                                         |___/\___|_|    \_/ |_|\___\___| |_| \___/|_|     \__,_|\___| \_/ \___|_|\___/| .__/
//                                                         \___|_|  |___/
//    ______ ______ ______ ______ ______ ______ ______ ______                                                                            | |
//   |______|______|______|______|______|______|______|______|                                                                           |_|
//

#import <Foundation/Foundation.h>
@class QCloudMediaInfoStream;
@class QCloudMediaInfoStreamVideo;
@class QCloudMediaInfoStreamAudio;
@class QCloudMediaInfoStreamSubtitle;
@class QCloudMediaInfoFormat;

NS_ASSUME_NONNULL_BEGIN

@interface QCloudMediaInfo : NSObject

/// 流信息
@property (strong, nonatomic) QCloudMediaInfoStream *Stream;

/// 格式信息
@property (strong, nonatomic) QCloudMediaInfoFormat *Format;
@end

@interface QCloudMediaInfoStream : NSObject


/// 视频信息
@property (strong, nonatomic) QCloudMediaInfoStreamVideo *Video;

/// 音频信息
@property (strong, nonatomic) QCloudMediaInfoStreamAudio *Audio;

/// 字幕信息
@property (strong, nonatomic) QCloudMediaInfoStreamSubtitle *Subtitle;

@end

@interface QCloudMediaInfoStreamVideo : NSObject


/// 该流的编号
@property (assign, nonatomic) NSInteger Index;

/// 编解码格式名字
@property (strong, nonatomic) NSString *CodecName;

/// 编解码格式的详细名字
@property (strong, nonatomic) NSString *CodecLongName;

/// 编码时基
@property (strong, nonatomic) NSString *CodecTimeBase;

/// 编码标签名
@property (strong, nonatomic) NSString *CodecTagString;

/// 编码标签
@property (strong, nonatomic) NSString *CodecTag;

/// 视频编码档位
@property (strong, nonatomic) NSString *Profile;

/// 视频高，单位 px
@property (assign, nonatomic) NSInteger Height;

/// 视频宽，单位 px
@property (assign, nonatomic) NSInteger Width;

/// 是否有B帧。1表示有，0表示无
@property (assign, nonatomic) NSInteger HasBFrame;

/// 视频编码的参考帧个数
@property (assign, nonatomic) NSInteger RefFrames;

/// 采样宽高比
@property (strong, nonatomic) NSString *Sar;

/// 显示宽高比
@property (strong, nonatomic) NSString *Dar;

/// 像素格式
@property (strong, nonatomic) NSString *PixFormat;

/// 场的顺序
@property (strong, nonatomic) NSString *FieldOrder;

/// 视频编码等级
@property (assign, nonatomic) NSInteger Level;

/// 视频帧率
@property (assign, nonatomic) NSInteger Fps;

/// 平均帧率
@property (strong, nonatomic) NSString *AvgFps;

/// 时基
@property (strong, nonatomic) NSString *Timebase;

/// 视频开始时间，单位为秒
@property (assign, nonatomic) CGFloat StartTime;

/// 视频时长，单位为秒
@property (assign, nonatomic) CGFloat Duration;

/// 比特率，单位为 kbps
@property (assign, nonatomic) CGFloat Bitrate;

/// 总帧数
@property (assign, nonatomic) NSInteger NumFrames;

/// 语言
@property (strong, nonatomic) NSString *Language;

@end

@interface QCloudMediaInfoStreamAudio : NSObject


/// 该流的编号
@property (assign, nonatomic) NSInteger Index;

/// 编解码格式名字
@property (strong, nonatomic) NSString *CodecName;

/// 编解码格式的详细名字
@property (strong, nonatomic) NSString *CodecLongName;

/// 编码时基
@property (strong, nonatomic) NSString *CodecTimeBase;

/// 编码标签名
@property (strong, nonatomic) NSString *CodecTagString;

/// 编码标签
@property (strong, nonatomic) NSString *CodecTag;

/// 采样格式
@property (strong, nonatomic) NSString *SampleFmt;

/// 采样率
@property (assign, nonatomic) NSInteger SampleRate;

/// 通道数量
@property (assign, nonatomic) NSInteger Channel;

/// 通道格式
@property (strong, nonatomic) NSString *ChannelLayout;

/// 时基
@property (strong, nonatomic) NSString *Timebase;

/// 音频开始时间，单位秒
@property (assign, nonatomic) CGFloat StartTime;

/// 音频时长，单位秒
@property (assign, nonatomic) CGFloat Duration;

/// 比特率，单位 kbps
@property (assign, nonatomic) CGFloat Bitrate;

/// 语言
@property (strong, nonatomic) NSString *Language;

@end

@interface QCloudMediaInfoStreamSubtitle : NSObject


/// 该流的编号
@property (assign, nonatomic) NSInteger Index;

/// 语言，und 表示无查询结果
@property (strong, nonatomic) NSString *Language;

@end

/// Container 节点 Format 的内容（查询视频信息时，可能部分字段未返回）：
@interface QCloudMediaInfoFormat : NSObject

/// Stream（包含 Video、Audio、Subtitle）的数量
@property (assign, nonatomic) NSInteger NumStream;

/// 节目的数量
@property (assign, nonatomic) NSInteger NumProgram;

/// 容器格式名字
@property (strong, nonatomic) NSString *FormatName;

/// 容器格式的详细名字
@property (strong, nonatomic) NSString *FormatLongName;

/// 起始时间，单位为秒
@property (assign, nonatomic) CGFloat StartTime;

/// 时长，单位为秒
@property (assign, nonatomic) CGFloat Duration;

/// 比特率，单位为 kbps
@property (assign, nonatomic) NSInteger Bitrate;

/// 大小，单位为 Byte
@property (assign, nonatomic) NSInteger Size;
@end

NS_ASSUME_NONNULL_END









































