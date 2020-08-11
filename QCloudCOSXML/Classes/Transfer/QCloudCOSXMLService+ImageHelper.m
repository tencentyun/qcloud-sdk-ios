//
//  QCloudCOSXMLService+ImageHelper.m
//  Pods-QCloudCOSXMLDemo
//
//  Created by garenwang on 2020/6/8.
//

#import "QCloudCOSXMLService+ImageHelper.h"
#import "QCloudPutObjectWatermarkRequest.h"
#import "QCloudGetRecognitionObjectRequest.h"

#import "QCloudGetFilePreviewRequest.h"
#import "QCloudGetGenerateSnapshotRequest.h"

@implementation QCloudCOSXMLService (ImageHelper)


- (void) PutWatermarkObject:(QCloudPutObjectWatermarkRequest*)request
{
    [super performRequest:request ];
}

- (void) GetRecognitionObject:(QCloudGetRecognitionObjectRequest*)request
{
    [super performRequest:request ];
}


- (void) GetFilePreviewObject:(QCloudGetFilePreviewRequest*)request
{
    [super performRequest:request ];
}

-(void)GetGenerateSnapshot:(QCloudGetGenerateSnapshotRequest *)request{
    [super performRequest:request];
}

@end
