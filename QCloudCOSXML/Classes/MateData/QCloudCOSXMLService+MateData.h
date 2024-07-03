#import "QCloudCOSXMLService.h"

#import "QCloudCreateDatasetRequest.h"
#import "QCloudCreateDatasetBindingRequest.h"
#import "QCloudCreateFileMetaIndexRequest.h"
#import "QCloudDatasetSimpleQueryRequest.h"
#import "QCloudDeleteDatasetRequest.h"
#import "QCloudDeleteDatasetBindingRequest.h"
#import "QCloudDeleteFileMetaIndexRequest.h"
#import "QCloudDescribeDatasetRequest.h"
#import "QCloudDescribeDatasetBindingRequest.h"
#import "QCloudDescribeDatasetBindingsRequest.h"
#import "QCloudDescribeDatasetsRequest.h"
#import "QCloudDescribeFileMetaIndexRequest.h"
#import "QCloudUpdateDatasetRequest.h"
#import "QCloudUpdateFileMetaIndexRequest.h"
#import "QCloudDatasetFaceSearchRequest.h"
#import "QCloudSearchImageRequest.h"

@interface QCloudCOSXMLService (MateData)
/// 创建数据集
/// 本接口用于创建一个数据集（Dataset）。
-(void)CreateDataset:(QCloudCreateDatasetRequest *)request;

/// 绑定存储桶与数据集
/// 创建数据集（Dataset）和对象存储（COS）Bucket 的绑定关系，绑定后将使用创建数据集时所指定算子对文件进行处理。
/// 绑定关系创建后，将对 COS 中新增的文件进行准实时的增量追踪扫描，使用创建数据集时所指定算子对文件进行处理，抽取文件元数据信息进行索引。通过此方式为文件建立索引后，您可以使用元数据查询API（例如SimpleQuery）对元数据进行查询、管理和统计。
-(void)CreateDatasetBinding:(QCloudCreateDatasetBindingRequest *)request;

/// 创建元数据索引
/// 提取一个COS文件的元数据，在数据集中建立索引。会根据数据集中的算子提取不同的元数据建立索引，也支持建立自定义的元数据索引。
-(void)CreateFileMetaIndex:(QCloudCreateFileMetaIndexRequest *)request;

/// 简单查询
/// 查询和统计数据集内文件，支持逻辑关系表达方式。
-(void)DatasetSimpleQuery:(QCloudDatasetSimpleQueryRequest *)request;

/// 删除数据集
/// 删除一个数据集（Dataset）。
-(void)DeleteDataset:(QCloudDeleteDatasetRequest *)request;

/// 解绑存储桶与数据集
/// 解绑数据集和对象存储（COS）Bucket ，解绑会导致 COS Bucket新增的变更不会同步到数据集，请谨慎操作。
-(void)DeleteDatasetBinding:(QCloudDeleteDatasetBindingRequest *)request;

/// 删除元数据索引
/// 从数据集内删除一个文件的元信息。无论该文件的元信息是否在数据集内存在，均会返回删除成功。


-(void)DeleteFileMetaIndex:(QCloudDeleteFileMetaIndexRequest *)request;

/// 查询数据集
/// 查询一个数据集（Dataset）信息。
-(void)DescribeDataset:(QCloudDescribeDatasetRequest *)request;

/// 查询数据集与存储桶的绑定关系
/// 查询数据集和对象存储（COS）Bucket 绑定关系列表。
-(void)DescribeDatasetBinding:(QCloudDescribeDatasetBindingRequest *)request;

/// 查询绑定关系列表
/// 查询数据集和对象存储（COS）Bucket 绑定关系列表。
-(void)DescribeDatasetBindings:(QCloudDescribeDatasetBindingsRequest *)request;

/// 列出数据集
/// 获取数据集（Dataset）列表。
-(void)DescribeDatasets:(QCloudDescribeDatasetsRequest *)request;

/// 查询元数据索引
/// 获取数据集内已完成索引的一个文件的元数据。
-(void)DescribeFileMetaIndex:(QCloudDescribeFileMetaIndexRequest *)request;

/// 更新数据集
/// 更新一个数据集（Dataset）信息。
-(void)UpdateDataset:(QCloudUpdateDatasetRequest *)request;

/// 更新元数据索引
/// 更新数据集内已索引的一个文件的部分元数据。
/// 并非所有的元数据都允许您自定义更新，在您发起更新请求时需要填写数据集，默认会根据该数据集的算子进行元数据重新提取并更新已存在的索引，此外您也可以更新部分自定义的元数据索引，如CustomTags、CustomId等字段，具体请参考请求参数一节。
-(void)UpdateFileMetaIndex:(QCloudUpdateFileMetaIndexRequest *)request;
 
/// 人脸搜索
/// 从数据集中搜索与指定图片最相似的前N张图片并返回人脸坐标可对数据集内文件进行一个或多个人员的人脸识别。
-(void)DatasetFaceSearch:(QCloudDatasetFaceSearchRequest *)request;

/// 图像检索
/// 可通过输入自然语言或图片，基于语义对数据集内文件进行图像检索。
-(void)SearchImage:(QCloudSearchImageRequest *)request;

@end
