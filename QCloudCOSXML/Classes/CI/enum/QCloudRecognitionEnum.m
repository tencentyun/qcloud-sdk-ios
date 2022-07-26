//
//  QCloudRecognitionEnum.m
//  QCloudCOSXML
//
//  Created by garenwang on 2022/3/17.
//

#import "QCloudRecognitionEnum.h"


NSString *QCloudRecognitionEnumTransferToString(QCloudTaskStatesEnum type) {
    NSMutableArray * mTypes = [[NSMutableArray alloc]init];
    
    if(type &  QCloudTaskStatesSubmitted){
        [mTypes addObject:@"Submitted"];
    }
    if(type &  QCloudTaskStatesRunning){
        [mTypes addObject:@"Running"];
    }
    if(type &  QCloudTaskStatesSuccess){
        [mTypes addObject:@"Success"];
    }
    if(type &  QCloudTaskStatesFailed){
        [mTypes addObject:@"Failed"];
    }
    if(type &  QCloudTaskStatesPause){
        [mTypes addObject:@"Pause"];
    }
    if(type &  QCloudTaskStatesCancel){
        [mTypes addObject:@"Cancel"];
    }
    return [mTypes componentsJoinedByString:@","];
}

QCloudTaskStatesEnum QCloudTaskStatesEnumFromString(NSString *key) {
    if ([key isEqualToString:@"Submitted"]) {
        return QCloudTaskStatesSubmitted;
    } else if ([key isEqualToString:@"Running"]) {
        return QCloudTaskStatesRunning;
    } else if ([key isEqualToString:@"Success"]) {
        return QCloudTaskStatesSuccess;
    } else if ([key isEqualToString:@"Failed"]) {
        return QCloudTaskStatesFailed;
    } else if ([key isEqualToString:@"Pause"]) {
        return QCloudTaskStatesPause;
    } else{
        return QCloudTaskStatesCancel;
    }
}
