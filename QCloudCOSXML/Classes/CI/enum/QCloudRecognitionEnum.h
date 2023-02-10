//
//  QCloudRecognitionEnum.h
//  QCloudCOSXML
//
//  Created by garenwang on 2022/3/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, QCloudRecognitionEnum) {
    QCloudRecognitionPorn       = 1 << 0,
    QCloudRecognitionTerrorist  = 1 << 1,
    QCloudRecognitionPolitics   = 1 << 2,
    QCloudRecognitionAds        = 1 << 3,
    QCloudRecognitionIllegal    = 1 << 4,
    QCloudRecognitionAbuse      = 1 << 5,
};

//拉取该状态的任务，以,分割，支持多状态：All、Submitted、Running、Success、Failed、Pause、Cancel。默认为 All。
typedef NS_ENUM(NSUInteger, QCloudTaskStatesEnum) {
    QCloudTaskStatesAll         = 63,
    QCloudTaskStatesSubmitted   = 1 << 0,
    QCloudTaskStatesRunning     = 1 << 1,
    QCloudTaskStatesSuccess     = 1 << 2,
    QCloudTaskStatesFailed      = 1 << 3,
    QCloudTaskStatesPause       = 1 << 4,
    QCloudTaskStatesCancel      = 1 << 5,
};
NSString *QCloudRecognitionEnumTransferToString(QCloudTaskStatesEnum type);
QCloudTaskStatesEnum QCloudTaskStatesEnumFromString(NSString *key);
NS_ASSUME_NONNULL_END
