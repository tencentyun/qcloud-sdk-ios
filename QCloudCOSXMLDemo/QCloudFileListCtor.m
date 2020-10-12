//
//  QCloudFileListCtor.m
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2020/5/15.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "QCloudFileListCtor.h"
#import "BucketFileItemViewCell.h"
#import "QCloudDownLoadNewCtor.h"
#import "QCloudUploadNewCtor.h"


NSString* const BUCKET_FILE_ITEM_VIEW_CELL = @"BucketFileItemViewCell";

NSString * const BUCKET_PREFIXES_ITEM_VIEW_CELL = @"UITableViewCell";


@interface QCloudFileListCtor ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray<QCloudBucketContents*>* contentsArray;

@property (nonatomic, strong) NSMutableArray<QCloudCommonPrefixes*>* prefixeszArray;

@property (nonatomic, copy) NSString* uploadTempFilePath;

@property (nonatomic,copy)  NSString * marker;

@property (nonatomic,strong)UILabel * tableViewFooter;

@end

@implementation QCloudFileListCtor

- (NSMutableArray<QCloudBucketContents *> *)contentsArray{
    if (!_contentsArray ) {
        _contentsArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _contentsArray;
}

- (UILabel *)tableViewFooter{
    if (!_tableViewFooter) {
        _tableViewFooter = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        _tableViewFooter.font = [UIFont systemFontOfSize:14];
        _tableViewFooter.textAlignment = NSTextAlignmentCenter;
        _tableViewFooter.textColor = DEF_HEXCOLOR(0x999999);
    }
    return _tableViewFooter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchData];
}

-(void)setupUI{
    
    self.title = self.prefix == nil ? @"文件列表" : self.prefix;
    
    [self.view addSubview:self.indicatorView];
    self.tableView.rowHeight = 110;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[BucketFileItemViewCell class] forCellReuseIdentifier:BUCKET_FILE_ITEM_VIEW_CELL];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:BUCKET_PREFIXES_ITEM_VIEW_CELL];
    
    self.tableView.tableFooterView  = self.tableViewFooter;
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(uploadFileToBucket)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)fetchData {
    [self.indicatorView startAnimating];
    
    //    获取文件列表
    //      实例化 QCloudGetBucketRequest 类
    //      调用  QCloudCOSXMLService实例的 GetBucket方法
    //      参数：注重说一下 delimiter prefix；
    //                  delimiter:路径分隔符 固定为 /
    //                  prefix:路径起始位置，比如要获取bucket下所有文件以及文件夹 改参数就不传，如果要获取folder文件夹下的所有文件及文件夹 该参数就传 /folder1
    //        假如一个桶的目录如下
    //            |-bucket
    //              |-folder1
    //                |-folder1_1
    //                |-folder1_2
    //                |-file1_1
    //              |-folder2
    //                |-folder2_1
    //                |-folder2_2
    //      结果：在result里 contents里是该路径下所有的文件，注意 里面包含了当前路径，需要手动过滤掉
    //                     commonPrefixes 包含该路径下的所有文件夹， prefix代表当每一个文件夹的路径，如果需要获取里面所有文件，需要将该参数传给 QCloudGetBucketRequest 对象的 prefix
    QCloudGetBucketRequest* request = [QCloudGetBucketRequest new];
    request.bucket = [QCloudCOSXMLConfiguration sharedInstance].currentBucket;
    request.prefix = self.prefix;
    
    request.delimiter = @"/";
    
    request.maxKeys = 100;
    request.marker = self.marker;
    __weak typeof(self) weakSelf = self;
    [request setFinishBlock:^(QCloudListBucketResult * _Nonnull result, NSError * _Nonnull error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.indicatorView stopAnimating];
        });
        
        if (error != nil) {
            self.tableViewFooter.text = @"请求失败";
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
            
        }else{
            if (weakSelf.marker == nil) {
                [weakSelf.contentsArray removeAllObjects];
                
            }
            
            for (QCloudBucketContents * content in result.contents) {
                if ([content.key hasSuffix:@"/"]) {
                    continue;
                }
                [weakSelf.contentsArray addObject:content];
            }
            
            
            weakSelf.prefixeszArray = result.commonPrefixes.mutableCopy;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (result.isTruncated) {
                    weakSelf.marker = result.nextMarker;
                    weakSelf.tableViewFooter.text = @"上拉加载更多";
                }else{
                    weakSelf.marker = nil;
                    weakSelf.tableViewFooter.text = @"无更多数据";
                }
                [weakSelf.tableView reloadData];
                
            });
        }
    }];
    
    [[QCloudCOSXMLConfiguration sharedInstance].currentService GetBucket:request];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.prefixeszArray.count;
    }else{
        return self.contentsArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:BUCKET_PREFIXES_ITEM_VIEW_CELL];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor systemBlueColor];
        if (_prefix != nil) {
            cell.textLabel.text = [self.prefixeszArray[indexPath.row].prefix stringByReplacingOccurrencesOfString:_prefix withString:@""];
        }else{
            cell.textLabel.text = self.prefixeszArray[indexPath.row].prefix;
        }
        return cell;
    }else{
        BucketFileItemViewCell * cell = [tableView dequeueReusableCellWithIdentifier:BUCKET_FILE_ITEM_VIEW_CELL];
        cell.cellContent = self.contentsArray[indexPath.row];
        
        if (self.prefix != nil) {
            [cell setFileTitle:[cell.cellContent.key stringByReplacingOccurrencesOfString:_prefix withString:@""]];
        }
        
        DEF_WeakSelf(self);
        cell.deleteFile = ^(NSObject *obj) {
            DEF_StrongSelf(self);
            [self cellDeleteFile:(QCloudBucketContents *) obj];
        };
        
        cell.downLoadFile = ^(NSObject *obj) {
            DEF_StrongSelf(self);
            [self cellDownLoadFile:(QCloudBucketContents *) obj];
        };
        
        return cell;
    }
}



-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    CGFloat bottomHeight = 0.0f;
    if (@available(iOS 11.0, *)) {
        bottomHeight = scrollView.adjustedContentInset.bottom;
    }
    
    if ((scrollView.contentOffset.y - bottomHeight + SCREEN_HEIGHT >= scrollView.contentSize.height) && self.marker != nil) {
        [self fetchData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50;
    }else{
        return 110;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        QCloudFileListCtor * fileList = [[QCloudFileListCtor alloc]init];
        fileList.prefix = self.prefixeszArray[indexPath.row].prefix;
        [self.navigationController pushViewController:fileList animated:YES];
    }
}

-(void)cellDeleteFile:(QCloudBucketContents *)content{
    
    
    //    删除存储桶中的文件对象
    //    实例化 QCloudDeleteObjectRequest
    //    调用 QCloudCOSXMLService 实例的 DeleteObject 方法 发起请求
    //    在FinishBlock获取结果
    //    参数： bucket 桶名（要删除的文件在哪个桶，该参数就传该桶名称）
    //            object 文件key （要删除的文件名称 key）
    QCloudDeleteObjectRequest * deleteRequest = [[QCloudDeleteObjectRequest alloc]init];
    deleteRequest.bucket = CURRENT_BUCKET;
    deleteRequest.object = content.key;
    
    DEF_WeakSelf(self)
    [deleteRequest setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself fetchData];
        });
    }];
    [CURRENT_SERVICE DeleteObject:deleteRequest];
}

-(void)cellDownLoadFile:(QCloudBucketContents *)content{
    QCloudDownLoadNewCtor * downLoadVC = [[QCloudDownLoadNewCtor alloc]init];
    downLoadVC.content = content;
    [self.navigationController pushViewController:downLoadVC animated:YES];
}

-(void)uploadFileToBucket{
    QCloudUploadNewCtor * uploadVC = [[QCloudUploadNewCtor alloc]init];
    [self.navigationController pushViewController:uploadVC animated:YES];
}

@end
