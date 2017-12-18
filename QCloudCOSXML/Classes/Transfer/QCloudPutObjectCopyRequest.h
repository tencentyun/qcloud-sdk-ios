//
//  PutObjectCopy.h
//  PutObjectCopy
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
#import "QCloudCopyObjectResult.h"
#import "QCloudCOSStorageClassEnum.h"
NS_ASSUME_NONNULL_BEGIN

/**
 @brief Put Object Copy 请求实现将一个文件从源路径复制到目标路径。建议文件大小 1M 到 5G，超过 5G 的文件请使用分块上传 Upload - Copy。在拷贝的过程中，文件元属性和 ACL 可以被修改。
 
 用户可以通过该接口实现文件移动，文件重命名，修改文件属性和创建副本。
 
 注意：
 在跨帐号复制的时候，需要先设置被复制文件的权限为公有读，或者对目标帐号赋权，同帐号则不需要。
 */
@interface QCloudPutObjectCopyRequest : QCloudBizHTTPRequest
/**
对象名
*/
@property (strong, nonatomic) NSString *object;
/**
存储桶名
*/
@property (strong, nonatomic) NSString *bucket;
/**
源文件 URL 路径，可以通过 versionid 子资源指定历史版本
*/
@property (strong, nonatomic) NSString *objectCopySource;
/**
是否拷贝元数据，枚举值：Copy, Replaced，默认值 Copy。假如标记为 Copy，忽略 Header 中的用户元数据信息直接复制；假如标记为 Replaced，按 Header 信息修改元数据。当目标路径和原路径一致，即用户试图修改元数据时，必须为 Replaced
*/
@property (strong, nonatomic) NSString *metadataDirective;
/**
当 Object 在指定时间后被修改，则执行操作，否则返回 412。可与 x-cos-copy-source-If-None-Match 一起使用，与其他条件联合使用返回冲突。
*/
@property (strong, nonatomic) NSString *objectCopyIfModifiedSince;
/**
当 Object 在指定时间后未被修改，则执行操作，否则返回 412。可与 x-cos-copy-source-If-Match 一起使用，与其他条件联合使用返回冲突。
*/
@property (strong, nonatomic) NSString *objectCopyIfUnmodifiedSince;
/**
当 Object 的 Etag 和给定一致时，则执行操作，否则返回 412。可与x-cos-copy-source-If-Unmodified-Since 一起使用，与其他条件联合使用返回冲突。
*/
@property (strong, nonatomic) NSString *objectCopyIfMatch;
/**
当 Object 的 Etag 和给定不一致时，则执行操作，否则返回 412。可与 x-cos-copy-source-If-Modified-Since 一起使用，与其他条件联合使用返回冲突。
*/
@property (strong, nonatomic) NSString *objectCopyIfNoneMatch;
/**
    Object 的存储级别
    */
@property (assign, nonatomic) QCloudCOSStorageClass storageClass;
/**
    定义 Object 的 ACL 属性。有效值：private，public-read-write，public-read；默认值：private
    */
@property (strong, nonatomic) NSString *accessControlList;
/**
    赋予被授权者读的权限。格式：id=" ",id=" "；
    当需要给子账户授权时，id="qcs::cam::uin/<OwnerUin>:uin/<SubUin>"，
    当需要给根账户授权时，id="qcs::cam::uin/<OwnerUin>:uin/<OwnerUin>"
    */
@property (strong, nonatomic) NSString *grantRead;
/**
    赋予被授权者写的权限。格式：id=" ",id=" "；
    当需要给子账户授权时，id="qcs::cam::uin/<OwnerUin>:uin/<SubUin>"，
    当需要给根账户授权时，id="qcs::cam::uin/<OwnerUin>:uin/<OwnerUin>"
    */
@property (strong, nonatomic) NSString *grantWrite;
/**
    赋予被授权者读写权限。格式: id=" ",id=" " ；
    当需要给子账户授权时，id="qcs::cam::uin/<OwnerUin>:uin/<SubUin>"，
    当需要给根账户授权时，id="qcs::cam::uin/<OwnerUin>:uin/<OwnerUin>"
    */
@property (strong, nonatomic) NSString *grantFullControl;

/**
 请求完成后的会通过该block回调，返回结果，若error为空，即为成功。
 
 @param QCloudRequestFinishBlock 回调bock
 */
- (void) setFinishBlock:(void (^)(QCloudCopyObjectResult* result, NSError * error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
