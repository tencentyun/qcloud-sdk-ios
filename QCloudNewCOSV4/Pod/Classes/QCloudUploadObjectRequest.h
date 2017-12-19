//
//  QCloudUploadObjectRequest.h
//  Pods
//
//  Created by Dong Zhao on 2017/3/9.
//
//

#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudAbstractRequest.h>
@class QCloudUploadObjectResult;
@interface QCloudUploadObjectRequest : QCloudAbstractRequest

/**
 文件在本地的路径
 */
@property (nonatomic, strong)    NSString *filePath;

/**
 自定义属性
 */
@property (strong, nonatomic) NSString *bizAttribute;
/**
 同名文件覆盖选项，有效值：NO--覆盖（删除已有的重名文件，存储新上传的文件），YES---不覆盖（若已存在重名文件，则不做覆盖，返回“上传失败”）。默认为 YES---不覆盖。
 */
@property (assign, nonatomic) BOOL insertOnly;

/**
 存储桶名称
 */
@property (nonatomic, strong) NSString* bucket;

/**
 目录名
 */
@property (nonatomic, strong) NSString* directory;

/**
 在COS上的文件名
 */
@property (nonatomic, strong) NSString* fileName;

- (void) setFinishBlock:(void (^)(QCloudUploadObjectResult* result, NSError *error))QCloudRequestFinishBlock;
@end
