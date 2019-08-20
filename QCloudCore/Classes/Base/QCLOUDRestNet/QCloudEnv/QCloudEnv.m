//
//  QCloudEnv.m
//  QCloudTernimalLab_CommonLogic
//
//  Created by tencent on 16/2/26.
//  Copyright © 2016年 QCloudTernimalLab. All rights reserved.
//

#import "QCloudEnv.h"

static QCloudEnviroment QCloudGlobalEnviroment = QCloudNormalEnviroment;

void QCloudChangeGlobalEnviroment(QCloudEnviroment env){
    QCloudGlobalEnviroment = env;
}


BOOL __IS_QCloud_NORMAL_ENV()
{
    if (QCloudGlobalEnviroment == QCloudNormalEnviroment) {
        return YES;
    }
    return NO;
}


BOOL __IS_QCloud_TEST_ENV()
{
    if (QCloudGlobalEnviroment == QCloudTestEnviroment) {
        return YES;
    }
    return NO;
}


BOOL __IS_QCloud_DEBUG_ENV()
{
    if (QCloudGlobalEnviroment == QCloudDebugEnviroment) {
        return YES;
    }
    return NO;
}


