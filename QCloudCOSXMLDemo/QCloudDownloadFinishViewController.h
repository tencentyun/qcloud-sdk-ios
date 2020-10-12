//
//  QCloudDownloadFinishViewController.h
//  QCloudCOSXMLDemo
//
//  Created by erichmzhang(张恒铭) on 26/04/2018.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "ViewController.h"
#import "QCloudTaskImformation.h"
@interface QCloudDownloadFinishViewController : ViewController
@property (nonatomic, strong) NSURL* fileURL;
@property (nonatomic, strong) QCloudTaskImformation* imformation;
@end
