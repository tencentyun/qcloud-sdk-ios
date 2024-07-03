#import "QCloudCOSXMLService+MateData.h"

@implementation QCloudCOSXMLService (MateData)
-(void)CreateDataset:(QCloudCreateDatasetRequest *)request{
     [super performRequest:(QCloudCreateDatasetRequest *)request];
}

-(void)CreateDatasetBinding:(QCloudCreateDatasetBindingRequest *)request{
     [super performRequest:(QCloudCreateDatasetBindingRequest *)request];
}

-(void)CreateFileMetaIndex:(QCloudCreateFileMetaIndexRequest *)request{
     [super performRequest:(QCloudCreateFileMetaIndexRequest *)request];
}

-(void)DatasetSimpleQuery:(QCloudDatasetSimpleQueryRequest *)request{
     [super performRequest:(QCloudDatasetSimpleQueryRequest *)request];
}

-(void)DeleteDataset:(QCloudDeleteDatasetRequest *)request{
     [super performRequest:(QCloudDeleteDatasetRequest *)request];
}

-(void)DeleteDatasetBinding:(QCloudDeleteDatasetBindingRequest *)request{
     [super performRequest:(QCloudDeleteDatasetBindingRequest *)request];
}

-(void)DeleteFileMetaIndex:(QCloudDeleteFileMetaIndexRequest *)request{
     [super performRequest:(QCloudDeleteFileMetaIndexRequest *)request];
}

-(void)DescribeDataset:(QCloudDescribeDatasetRequest *)request{
     [super performRequest:(QCloudDescribeDatasetRequest *)request];
}

-(void)DescribeDatasetBinding:(QCloudDescribeDatasetBindingRequest *)request{
     [super performRequest:(QCloudDescribeDatasetBindingRequest *)request];
}

-(void)DescribeDatasetBindings:(QCloudDescribeDatasetBindingsRequest *)request{
     [super performRequest:(QCloudDescribeDatasetBindingsRequest *)request];
}

-(void)DescribeDatasets:(QCloudDescribeDatasetsRequest *)request{
     [super performRequest:(QCloudDescribeDatasetsRequest *)request];
}

-(void)DescribeFileMetaIndex:(QCloudDescribeFileMetaIndexRequest *)request{
     [super performRequest:(QCloudDescribeFileMetaIndexRequest *)request];
}

-(void)UpdateDataset:(QCloudUpdateDatasetRequest *)request{
     [super performRequest:(QCloudUpdateDatasetRequest *)request];
}

-(void)UpdateFileMetaIndex:(QCloudUpdateFileMetaIndexRequest *)request{
     [super performRequest:(QCloudUpdateFileMetaIndexRequest *)request];
}

-(void)DatasetFaceSearch:(QCloudDatasetFaceSearchRequest *)request{
     [super performRequest:(QCloudDatasetFaceSearchRequest *)request];
}

-(void)SearchImage:(QCloudSearchImageRequest *)request{
     [super performRequest:(QCloudSearchImageRequest *)request];
}


@end
