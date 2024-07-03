//
//  QCloudDatasetSimpleQueryResponse.h
//  QCloudDatasetSimpleQueryResponse
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
#import "QCloudCommonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCloudDatasetSimpleQueryResponse : NSObject 

/// 请求ID
@property (nonatomic,strong) NSString * RequestId;

/// 文件信息列表。仅在请求的Aggregations为空时返回。
@property (nonatomic,strong)NSArray <QCloudFileResult * > * Files;

/// 聚合字段信息列表。仅在请求的Aggregations不为空时返回。
@property (nonatomic,strong)NSArray <QCloudAggregationsResult * > * Aggregations;

/// 翻页标记。当文件总数大于设置的MaxResults时，用于翻页的Token。符合条件的文件信息未全部返回时，此参数才有值。下一次列出文件信息时将此值作为NextToken传入，将后续的文件信息返回。
@property (nonatomic,strong) NSString * NextToken;

@end

@interface QCloudDatasetSimpleQuery : NSObject 

/// 数据集名称，同一个账户下唯一。;是否必传：是
@property (nonatomic,strong) NSString * DatasetName;

/// 简单查询参数条件，可自嵌套。;是否必传：否
@property (nonatomic,strong) QCloudQuery * Query;

/// 返回文件元数据的最大个数，取值范围为0200。 使用聚合参数时，该值表示返回分组的最大个数，取值范围为02000。 不设置此参数或者设置为0时，则取默认值100。;是否必传：否
@property (nonatomic,assign) NSInteger MaxResults;

/// 当绑定关系总数大于设置的MaxResults时，用于翻页的token。从NextToken开始按字典序返回绑定关系信息列表。第一次调用此接口时，设置为空。;是否必传：否
@property (nonatomic,strong) NSString * NextToken;

/// 排序字段列表。请参考[字段和操作符的支持列表](https://cloud.tencent.com/document/product/460/106154)。 多个排序字段可使用半角逗号（,）分隔，例如：Size,Filename。 最多可设置5个排序字段。 排序字段顺序即为排序优先级顺序。;是否必传：否
@property (nonatomic,strong) NSString * Sort;

/// 排序字段的排序方式。取值如下： asc：升序； desc（默认）：降序。 多个排序方式可使用半角逗号（,）分隔，例如：asc,desc。 排序方式不可多于排序字段，即参数Order的元素数量需小于等于参数Sort的元素数量。例如Sort取值为Size,Filename时，Order可取值为asc,desc或asc。 排序方式少于排序字段时，未排序的字段默认取值asc。例如Sort取值为Size,Filename，Order取值为asc时，Filename默认排序方式为asc，即升序排列;是否必传：否
@property (nonatomic,strong) NSString * Order;

/// 聚合字段信息列表。 当您使用聚合查询时，仅返回聚合结果，不再返回匹配到的元信息列表。;是否必传：否
@property (nonatomic,strong)NSArray <QCloudAggregations * > * Aggregations;

/// 仅返回特定字段的值，而不是全部已有的元信息字段。可用于降低返回的结构体大小。不填或留空则返回所有字段。;是否必传：否
@property (nonatomic,strong) NSString * WithFields;

@end



NS_ASSUME_NONNULL_END
