//
//  QCloudCommonModel.h
//  QCloudCommonModel
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


NS_ASSUME_NONNULL_BEGIN

@class QCloudAggregations;
@class QCloudAggregationsResult;
@class QCloudBinding;
@class QCloudDataset;
@class QCloudDatasets;
@class QCloudFile;
@class QCloudFileResult;
@class QCloudFilesDetail;
@class QCloudGroups;
@class QCloudImageResult;
@class QCloudObject;
@class QCloudPersons;
@class QCloudQuery;
@class QCloudSubQueries;
@class QCloudUpdateMetaFile;
@interface QCloudAggregations : NSObject 

///  聚合字段的操作符。枚举值：min：最小值。max：最大值。average：平均数sum：求和。count：计数。distinct：去重计数。group：分组计数，按照分组计数结果从高到低排序。 ;是否必传：否
@property (nonatomic,strong) NSString * Operation;

/// 字段名称。关于支持的字段，请参考字段和操作符的支持列表。;是否必传：否
@property (nonatomic,strong) NSString * Field;

@end

@interface QCloudAggregationsResult : NSObject 

///  聚合字段的聚合操作符。      ;是否必传：否
@property (nonatomic,strong) NSString * Operation;

///  聚合的统计结果。     ;是否必传：否
@property (nonatomic,assign) CGFloat Value;

///  分组聚合的结果列表。仅在请求的Aggregations中存在group类型的Operation时才会返回。;是否必传：否
@property (nonatomic,strong)NSArray <QCloudGroups * > * Groups;

/// 聚合字段名称。;是否必传：否
@property (nonatomic,strong) NSString * Field;

@end

@interface QCloudBinding : NSObject 

///  资源标识字段，表示需要与数据集绑定的资源，当前仅支持COS存储桶，字段规则：cos://，其中BucketName表示COS存储桶名称，例如：cos://examplebucket-1250000000 ;是否必传：否
@property (nonatomic,strong) NSString * URI;

///  数据集和 COS Bucket绑定关系的状态。取值范围如下：Running：绑定关系运行中。 ;是否必传：否
@property (nonatomic,strong) NSString * State;

///  数据集和 COS Bucket绑定关系创建时间的时间戳，格式为RFC3339Nano。 ;是否必传：否
@property (nonatomic,strong) NSString * CreateTime;

///  数据集和 COS Bucket的绑定关系修改时间的时间戳，格式为RFC3339Nano。创建绑定关系后，如果未暂停或者未重启过绑定关系，则绑定关系修改时间的时间戳和绑定关系创建时间的时间戳相同。 ;是否必传：否
@property (nonatomic,strong) NSString * UpdateTime;

/// 数据集名称。;是否必传：否
@property (nonatomic,strong) NSString * DatasetName;

@end

@interface QCloudDataset : NSObject 

///    模板ID。   ;是否必传：否
@property (nonatomic,strong) NSString * TemplateId;

///    数据集描述信息 ;是否必传：否
@property (nonatomic,strong) NSString * Description;

///  数据集创建时间的时间戳，格式为RFC3339Nano。;是否必传：否
@property (nonatomic,strong) NSString * CreateTime;

///  数据集修改时间的时间戳，格式为RFC3339Nano。创建数据集后，如果未更新过数据集，则数据集修改时间的时间戳和数据集创建时间的时间戳相同 ;是否必传：否
@property (nonatomic,strong) NSString * UpdateTime;

///  数据集当前绑定的COS Bucket数量                               ;是否必传：否
@property (nonatomic,assign) NSInteger BindCount;

///  数据集当前文件数量                                           ;是否必传：否
@property (nonatomic,assign) NSInteger FileCount;

///  数据集中当前文件总大小，单位为字节                           ;是否必传：否
@property (nonatomic,assign) NSInteger TotalFileSize;

/// 数据集名称;是否必传：否
@property (nonatomic,strong) NSString * DatasetName;

@end

@interface QCloudDatasets : NSObject 

///    模板ID。   ;是否必传：否
@property (nonatomic,strong) NSString * TemplateId;

///    数据集描述信息 ;是否必传：否
@property (nonatomic,strong) NSString * Description;

///  数据集创建时间的时间戳，格式为RFC3339Nano。;是否必传：否
@property (nonatomic,strong) NSString * CreateTime;

///  数据集修改时间的时间戳，格式为RFC3339Nano。创建数据集后，如果未更新过数据集，则数据集修改时间的时间戳和数据集创建时间的时间戳相同 ;是否必传：否
@property (nonatomic,strong) NSString * UpdateTime;

///  数据集当前绑定的COS Bucket数量                               ;是否必传：否
@property (nonatomic,assign) NSInteger BindCount;

///  数据集当前文件数量                                           ;是否必传：否
@property (nonatomic,assign) NSInteger FileCount;

///  数据集中当前文件总大小，单位为字节                           ;是否必传：否
@property (nonatomic,assign) NSInteger TotalFileSize;

/// 数据集名称;是否必传：否
@property (nonatomic,strong) NSString * DatasetName;

@end

@interface QCloudFile : NSObject 

/// 自定义ID。该文件索引到数据集后，作为该行元数据的属性存储，用于和您的业务系统进行关联、对应。您可以根据业务需求传入该值，例如将某个URI关联到您系统内的某个ID。推荐传入全局唯一的值。在查询时，该字段支持前缀查询和排序，详情请见[字段和操作符的支持列表](https://cloud.tencent.com/document/product/460/106154)。   ;是否必传：否
@property (nonatomic,strong) NSString * CustomId;

/// 自定义标签。您可以根据业务需要自定义添加标签键值对信息，用于在查询时可以据此为筛选项进行检索，详情请见[字段和操作符的支持列表](https://cloud.tencent.com/document/product/460/106154)。  ;是否必传：否
@property (nonatomic,strong) NSDictionary * CustomLabels;

/// 自定义标签键 ;是否必传：否
@property (nonatomic,strong) NSString * Key;

/// 自定义标签值 ;是否必传：否
@property (nonatomic,strong) NSString * Value;

/// 可选项，文件媒体类型，枚举值： image：图片。  other：其他。 document：文档。 archive：压缩包。 video：视频。  audio：音频。  ;是否必传：否
@property (nonatomic,strong) NSString * MediaType;

/// 可选项，文件内容类型（MIME Type），如image/jpeg。  ;是否必传：否
@property (nonatomic,strong) NSString * ContentType;

/// 资源标识字段，表示需要建立索引的文件地址，当前仅支持COS上的文件，字段规则：cos:///，其中BucketName表示COS存储桶名称，ObjectKey表示文件完整路径，例如：cos://examplebucket-1250000000/test1/img.jpg。 注意： 1、仅支持本账号内的COS文件 2、不支持HTTP开头的地址;是否必传：是
@property (nonatomic,strong) NSString * URI;

/// 输入图片中检索的人脸数量，默认值为20，最大值为20。(仅当数据集模板 ID 为 Official:FaceSearch 有效)。;是否必传：否
@property (nonatomic,assign) NSInteger MaxFaceNum;

/// 自定义人物属性(仅当数据集模板 ID 为 Official:FaceSearch 有效)。;是否必传：否
@property (nonatomic,strong)NSArray <QCloudPersons * > * Persons;

@end

@interface QCloudFileResult : NSObject 

/// 对象唯一ID。      ;是否必传：否
@property (nonatomic,strong) NSString * ObjectId;

///  元数据创建时间的时间戳，格式为RFC3339Nano ;是否必传：否
@property (nonatomic,strong) NSString * CreateTime;

///  元数据修改时间的时间戳，格式为RFC3339Nano创建元数据后，如果未更新过元数据，则元数据修改时间的时间戳和元数据创建时间的时间戳相同 ;是否必传：否
@property (nonatomic,strong) NSString * UpdateTime;

///   资源标识字段，表示需要建立索引的文件地址  ;是否必传：否
@property (nonatomic,strong) NSString * URI;

///   文件路径  ;是否必传：否
@property (nonatomic,strong) NSString * Filename;

///    文件媒体类型。 枚举值：image：图片。other：其他。document：文档。archive：压缩包。audio：音频。video：视频。;是否必传：否
@property (nonatomic,strong) NSString * MediaType;

///   文件内容类型（MIME Type）。;是否必传：否
@property (nonatomic,strong) NSString * ContentType;

///   文件存储空间类型。;是否必传：否
@property (nonatomic,strong) NSString * COSStorageClass;

///    文件CRC64值。 ;是否必传：否
@property (nonatomic,strong) NSString * COSCRC64;

///    文件大小，单位为字节。 ;是否必传：否
@property (nonatomic,assign) NSInteger Size;

///    指定Object被下载时网页的缓存行为。该字段需要设置COS Object HTTP属性Cache-Control。 ;是否必传：否
@property (nonatomic,strong) NSString * CacheControl;

///    指定Object被下载时的名称。需要设置COS Object HTTP属性Content-Disposition。 ;是否必传：否
@property (nonatomic,strong) NSString * ContentDisposition;

///    指定该Object被下载时的内容编码格式。需要设置COS Object HTTP属性Content-Encoding。 ;是否必传：否
@property (nonatomic,strong) NSString * ContentEncoding;

///    Object内容使用的语言。需要设置COS Object HTTP属性Content-Language。 ;是否必传：否
@property (nonatomic,strong) NSString * ContentLanguage;

///    加密算法,需要设置x-cos-server-side-encryption。 ;是否必传：否
@property (nonatomic,strong) NSString * ServerSideEncryption;

///    Object生成时会创建相应的ETag ，ETag用于标识一个Object的内容。 ;是否必传：否
@property (nonatomic,strong) NSString * ETag;

///   文件最近一次修改时间的时间戳， 格式为RFC3339Nano。;是否必传：否
@property (nonatomic,strong) NSString * FileModifiedTime;

///   该文件的自定义ID。该文件索引到数据集后，作为该行元数据的属性存储，用于和您的业务系统进行关联、对应。您可以根据业务需求传入该值，例如将某个URI关联到您系统内的某个ID。推荐传入全局唯一的值。;是否必传：否
@property (nonatomic,strong) NSString * CustomId;

///   文件自定义标签列表。储存您业务自定义的键名、键值对信息，用于在查询时可以据此为筛选项进行检索。;是否必传：否
@property (nonatomic,strong) NSDictionary * CustomLabels;

///   cos自定义头部。储存您业务在cos object上的键名、键值对信息，用于在查询时可以据此为筛选项进行检索。;是否必传：否
@property (nonatomic,strong) NSDictionary * COSUserMeta;

///    文件访问权限属性。 ;是否必传：否
@property (nonatomic,strong) NSString * ObjectACL;

///   cos自定义标签。储存您业务在cos object上的自定义标签的键名、键值对信息，用于在查询时可以据此为筛选项进行检索。;是否必传：否
@property (nonatomic,strong) NSDictionary * COSTagging;

///    cos自定义标签的数量。 ;是否必传：否
@property (nonatomic,assign) NSInteger COSTaggingCount;

/// 数据集名称。;是否必传：否
@property (nonatomic,strong) NSString * DatasetName;

@end

@interface QCloudFilesDetail : NSObject 

///  元数据创建时间的时间戳，格式为RFC3339Nano ;是否必传：否
@property (nonatomic,strong) NSString * CreateTime;

///  元数据修改时间的时间戳，格式为RFC3339Nano创建元数据后，如果未更新过元数据，则元数据修改时间的时间戳和元数据创建时间的时间戳相同 ;是否必传：否
@property (nonatomic,strong) NSString * UpdateTime;

///   资源标识字段，表示需要建立索引的文件地址  ;是否必传：否
@property (nonatomic,strong) NSString * URI;

///   文件路径  ;是否必传：否
@property (nonatomic,strong) NSString * Filename;

///    文件媒体类型。 枚举值：image：图片。other：其他。document：文档。archive：压缩包。audio：音频。video：视频。;是否必传：否
@property (nonatomic,strong) NSString * MediaType;

///   文件内容类型（MIME Type）。;是否必传：否
@property (nonatomic,strong) NSString * ContentType;

///   文件存储空间类型。;是否必传：否
@property (nonatomic,strong) NSString * COSStorageClass;

///    文件CRC64值。 ;是否必传：否
@property (nonatomic,strong) NSString * COSCRC64;

///    对象ACL。 ;是否必传：否
@property (nonatomic,strong) NSString * ObjectACL;

///    文件大小，单位为字节。 ;是否必传：否
@property (nonatomic,assign) NSInteger Size;

///    指定Object被下载时网页的缓存行为。 ;是否必传：否
@property (nonatomic,strong) NSString * CacheControl;

///    Object生成时会创建相应的ETag ，ETag用于标识一个Object的内容。 ;是否必传：否
@property (nonatomic,strong) NSString * ETag;

///   文件最近一次修改时间的时间戳， 格式为RFC3339Nano。;是否必传：否
@property (nonatomic,strong) NSString * FileModifiedTime;

///   该文件的自定义ID。该文件索引到数据集后，作为该行元数据的属性存储，用于和您的业务系统进行关联、对应。您可以根据业务需求传入该值，例如将某个URI关联到您系统内的某个ID。推荐传入全局唯一的值。;是否必传：否
@property (nonatomic,strong) NSString *  CustomId;

///   文件自定义标签列表。储存您业务自定义的键名、键值对信息，用于在查询时可以据此为筛选项进行检索。;是否必传：否
@property (nonatomic,strong) NSDictionary * CustomLabels;

/// 数据集名称。;是否必传：否
@property (nonatomic,strong) NSString * DatasetName;

@end

@interface QCloudGroups : NSObject 

///  分组聚合的总个数。      ;是否必传：否
@property (nonatomic,assign) NSInteger Count;

/// 分组聚合的值。;是否必传：否
@property (nonatomic,strong) NSString * Value;

@end

@interface QCloudImageResult : NSObject 

/// 资源标识字段，表示需要建立索引的文件地址。;是否必传：否
@property (nonatomic,strong) NSString * URI;

/// 相关图片匹配得分。;是否必传：否
@property (nonatomic,assign) NSInteger Score;

@end

@interface QCloudObject : NSObject 

/// 键;是否必传：否
@property (nonatomic,strong) NSString * key;

/// 值;是否必传：否
@property (nonatomic,strong) NSString * value;

@end

@interface QCloudPersons : NSObject 

/// 自定义人物 ID。;是否必传：否
@property (nonatomic,strong) NSString * PersonId;

@end

@interface QCloudQuery : NSObject 

/// 操作运算符。枚举值： not：逻辑非。 or：逻辑或。 and：逻辑与。 lt：小于。 lte：小于等于。 gt：大于。 gte：大于等于。 eq：等于。 exist：存在性查询。 prefix：前缀查询。 match-phrase：字符串匹配查询。 nested：字段为数组时，其中同一对象内逻辑条件查询。;是否必传：是
@property (nonatomic,strong) NSString * Operation;

/// 子查询的结构体。 只有当Operations为逻辑运算符（and、or、not或nested）时，才能设置子查询条件。 在逻辑运算符为and/or/not时，其SubQueries内描述的所有条件需符合父级设置的and/or/not逻辑关系。 在逻辑运算符为nested时，其父级的Field必须为一个数组类的字段（如：Labels）。 子查询条件SubQueries组的Operation必须为and/or/not中的一个或多个，其Field必须为父级Field的子属性。;是否必传：否
@property (nonatomic,strong)NSArray <QCloudSubQueries * > * SubQueries;

/// 字段名称。关于支持的字段，请参考[字段和操作符的支持列表](https://cloud.tencent.com/document/product/460/106154)。;是否必传：否
@property (nonatomic,strong) NSString * Field;

/// 查询的字段值。当Operations为逻辑运算符（and、or、not或nested）时，该字段无效。;是否必传：否
@property (nonatomic,strong) NSString * Value;

@end

@interface QCloudSubQueries : NSObject 

/// 查询的字段值。当Operations为逻辑运算符（and、or、not或nested）时，该字段无效。;是否必传：否
@property (nonatomic,strong) NSString * Value;

///  操作运算符。枚举值：not：逻辑非。or：逻辑或。and：逻辑与。lt：小于。lte：小于等于。gt：大于。gte：大于等于。eq：等于。exist：存在性查询。prefix：前缀查询。match-phrase：字符串匹配查询。nested：字段为数组时，其中同一对象内逻辑条件查询。 ;是否必传：是
@property (nonatomic,strong) NSString * Operation;

/// 字段名称。关于支持的字段，请参考字段和操作符的支持列表。;是否必传：否
@property (nonatomic,strong) NSString * Field;

@end

@interface QCloudUpdateMetaFile : NSObject 

/// 自定义ID。该文件索引到数据集后，作为该行元数据的属性存储，用于和您的业务系统进行关联、对应。您可以根据业务需求传入该值，例如将某个URI关联到您系统内的某个ID。推荐传入全局唯一的值。在查询时，该字段支持前缀查询和排序，详情请见[字段和操作符的支持列表](https://cloud.tencent.com/document/product/460/106154)。   ;是否必传：否
@property (nonatomic,strong) NSString * CustomId;

/// 自定义标签。您可以根据业务需要自定义添加标签键值对信息，用于在查询时可以据此为筛选项进行检索，详情请见[字段和操作符的支持列表](https://cloud.tencent.com/document/product/460/106154)。  ;是否必传：否
@property (nonatomic,strong) NSDictionary * CustomLabels;

/// 自定义标签键 ;是否必传：否
@property (nonatomic,strong) NSString * Key;

/// 自定义标签值 ;是否必传：否
@property (nonatomic,strong) NSString * Value;

/// 可选项，文件媒体类型，枚举值： image：图片。  other：其他。 document：文档。 archive：压缩包。 video：视频。  audio：音频。  ;是否必传：否
@property (nonatomic,strong) NSString * MediaType;

/// 可选项，文件内容类型（MIME Type），如image/jpeg。  ;是否必传：否
@property (nonatomic,strong) NSString * ContentType;

/// 资源标识字段，表示需要建立索引的文件地址，当前仅支持COS上的文件，字段规则：cos:///，其中BucketName表示COS存储桶名称，ObjectKey表示文件完整路径，例如：cos://examplebucket-1250000000/test1/img.jpg。 注意： 1、仅支持本账号内的COS文件 2、不支持HTTP开头的地址;是否必传：是
@property (nonatomic,strong) NSString * URI;

@end



NS_ASSUME_NONNULL_END
