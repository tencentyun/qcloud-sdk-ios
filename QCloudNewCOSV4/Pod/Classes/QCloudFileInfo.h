//
//  QCloudFileInfo.h
//  QCloudFileInfo
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//
//   ██████╗  ██████╗██╗      ██████╗ ██╗   ██╗██████╗     ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗         ██╗      █████╗ ██████╗
//  ██╔═══██╗██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║         ██║     ██╔══██╗██╔══██╗
//  ██║   ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║         ██║     ███████║██████╔╝
//  ██║▄▄ ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║         ██║     ██╔══██║██╔══██╗
//  ╚██████╔╝╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝       ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗    ███████╗██║  ██║██████╔╝
//   ╚══▀▀═╝  ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝        ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝    ╚══════╝╚═╝  ╚═╝╚═════╝
//
//
//                                                                              _             __                 _                _
//                                                                             (_)           / _|               | |              | |
//                                                          ___  ___ _ ____   ___  ___ ___  | |_ ___  _ __    __| | _____   _____| | ___  _ __   ___ _ __ ___
//                                                         / __|/ _ \ '__\ \ / / |/ __/ _ \ |  _/ _ \| '__|  / _` |/ _ \ \ / / _ \ |/ _ \| '_ \ / _ \ '__/ __|
//                                                         \__ \  __/ |   \ V /| | (_|  __/ | || (_) | |    | (_| |  __/\ V /  __/ | (_) | |_) |  __/ |  \__
//                                                         |___/\___|_|    \_/ |_|\___\___| |_| \___/|_|     \__,_|\___| \_/ \___|_|\___/| .__/ \___|_|  |___/
//    ______ ______ ______ ______ ______ ______ ______ ______                                                                            | |
//   |______|______|______|______|______|______|______|______|                                                                           |_|
//



#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>

NS_ASSUME_NONNULL_BEGIN
@interface QCloudFileInfo : NSObject
/**
文件名
*/
@property (strong, nonatomic) NSString *name;
/**
文件大小，当类型为文件时返回
*/
@property (assign, nonatomic) int64_t fileSize;
/**
文件已传输大小，当类型为文件时返回
*/
@property (assign, nonatomic) int64_t fileLength;
/**
文件 sha，当类型为文件时返回
*/
@property (strong, nonatomic) NSString *sha;
/**
创建时间，10位 Unix 时间戳
*/
@property (strong, nonatomic) NSString *ctime;
/**
修改时间，10位 Unix 时间戳
*/
@property (strong, nonatomic) NSString *mtime;
/**
生成的资源可访问的cdn url，当类型为文件时返回
*/
@property (strong, nonatomic) NSString *accessURL;
/**
如果没有对文件单独设置该属性，则可能不会返回该字段。返回值：eInvalid（表示继承 bucket 的读写权限）；eWRPrivate（私有读写）；eWPrivateRPublic（公有读私有写）。说明：文件可以和 bucket 拥有不同的权限类型，已经设置过权限的文件如果想要撤销，将会直接被赋值为 eInvalid，即继承 bucket 的权限
*/
@property (strong, nonatomic) NSString *authority;
/**
生成的资源可访问的源站 url，当类型为文件时返回
*/
@property (strong, nonatomic) NSString *sourceURL;
@property (strong, nonatomic) NSString *previewURL;
/**
用户自定义头部
*/
@property (strong, nonatomic) NSDictionary *customHeaders;
/**
COS 服务调用方自定义属性，可通过 查询目录属性 获取该属性值
*/
@property (strong, nonatomic) NSString *attribute;
@end
NS_ASSUME_NONNULL_END
