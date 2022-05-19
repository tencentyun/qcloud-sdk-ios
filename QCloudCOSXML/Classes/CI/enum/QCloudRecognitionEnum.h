//
//  QCloudRecognitionEnum.h
//  QCloudCOSXML
//
//  Created by garenwang on 2022/3/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, QCloudRecognitionEnum) {
    QCloudRecognitionPorn = 1 << 0,
    QCloudRecognitionTerrorist = 1 << 1,
    QCloudRecognitionPolitics = 1 << 2,
    QCloudRecognitionAds = 1 << 3,
};

NS_ASSUME_NONNULL_END
