//
//  QCloudPostBucketInventoryRequest.h
//  QCloudPostBucketInventoryRequest
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
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
#import <QCloudCore/QCloudCore.h>
@class QCloudInventoryConfiguration;
NS_ASSUME_NONNULL_BEGIN
/**

 用于存储桶创建一个一次性清单任务

 ### 功能说明

 COS 支持在每个存储桶中创建最多1000条清单任务。

 POST Bucket inventory 可以对一个存储桶创建一个一次性清单任务。区别于 PUT Bucket inventory，这个清单任务创建后将立即开始执行，每个任务只会执行一次，而不会周期性地重复执行。通过使用此功能，您能够更加灵活地获取到存储桶的对象清单，进而更精细化地管理对象。

 关于在存储桶中创建清单任务接口的具体描述，请查看 https://cloud.tencent.com/document/product/436/83382

 ### 示例

  @code

    QCloudPostBucketInventoryRequest *putReq = [QCloudPostBucketInventoryRequest new];

    // 存储桶名称，格式为 BucketName-APPID
    putReq.bucket= @"examplebucket-1250000000";

    // 清单任务的名称
    putReq.inventoryID = @"list1";

    // 用户在请求体中使用 XML 语言设置清单任务的具体配置信息。配置信息包括清单任务分析的对象，
    // 分析的频次，分析的维度，分析结果的格式及存储的位置等信息。
    QCloudInventoryConfiguration *config = [QCloudInventoryConfiguration new];

    // 清单的名称，与请求参数中的 id 对应
    config.identifier = @"list1";

    // 清单是否启用的标识：
    // 如果设置为 true，清单功能将生效
    // 如果设置为 false，将不生成任何清单
    config.isEnabled = @"True";

    // 描述存放清单结果的信息
    QCloudInventoryDestination *des = [QCloudInventoryDestination new];

    QCloudInventoryBucketDestination *btDes =[QCloudInventoryBucketDestination new];

    // 清单分析结果的文件形式，可选项为 CSV 格式
    btDes.cs = @"CSV";

    // 存储桶的所有者 ID
    btDes.account = @"1278687956";

    // 存储桶名称，格式为 BucketName-APPID
    btDes.bucket  = @"qcs::cos:ap-guangzhou::examplebucket-1250000000";

    // 清单分析结果的前缀
    btDes.prefix = @"list1";

    // COS 托管密钥的加密方式
    QCloudInventoryEncryption *enc = [QCloudInventoryEncryption new];
    enc.ssecos = @"";

    // 为清单结果提供服务端加密的选项
    btDes.encryption = enc;

    // 清单结果导出后存放的存储桶信息
    des.bucketDestination = btDes;

    // 描述存放清单结果的信息
    config.destination = des;

    // 配置清单任务周期
    QCloudInventorySchedule *sc = [QCloudInventorySchedule new];

    // 清单任务周期，可选项为按日或者按周，枚举值：Daily、Weekly
    sc.frequency = @"Daily";
    config.schedule = sc;
    QCloudInventoryFilter *fileter = [QCloudInventoryFilter new];
    fileter.prefix = @"myPrefix";
    config.filter = fileter;
    config.includedObjectVersions = QCloudCOSIncludedObjectVersionsAll;
    QCloudInventoryOptionalFields *fields = [QCloudInventoryOptionalFields new];

    fields.field = @[ @"Size",
                      @"LastModifiedDate",
                      @"ETag",
                      @"StorageClass",
                      @"IsMultipartUploaded",
                      @"ReplicationStatus"];

    // 设置清单结果中应包含的分析项目
    config.optionalFields = fields;
    putReq.inventoryConfiguration = config;
    [putReq setFinishBlock:^(id outputObject, NSError *error) {
        // 可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
        NSDictionary * result = (NSDictionary *)outputObject;

    }];
    [[QCloudCOSXMLService defaultCOSXML] PostBucketInventory:putReq];

*/
@interface QCloudPostBucketInventoryRequest : QCloudBizHTTPRequest
/**
说明日志记录配置的状态
*/
@property (strong, nonatomic) QCloudInventoryConfiguration *inventoryConfiguration;

/**
 清单任务的名称。缺省值：None；合法字符：a-z，A-Z，0-9，-，_，.
 */

@property (strong, nonatomic) NSString *inventoryID;
/**
存储桶名
*/
@property (strong, nonatomic) NSString *bucket;

@end
NS_ASSUME_NONNULL_END
