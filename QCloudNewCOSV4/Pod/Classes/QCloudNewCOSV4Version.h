//
// QCloud Terminal Lab --- service for developers
//
#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCoreVersion.h>

#ifndef QCloudNewCOSV4ModuleVersion_h
#define QCloudNewCOSV4ModuleVersion_h
#define QCloudNewCOSV4ModuleVersionNumber 503002

//dependency
#if QCloudCoreModuleVersionNumber != 503002 
    #error "库QCloudNewCOSV4依赖QCloudCore最小版本号为5.3.2，当前引入的QCloudCore版本号过低，请及时升级后使用" 
#endif

//
FOUNDATION_EXTERN NSString * const QCloudNewCOSV4ModuleVersion;
FOUNDATION_EXTERN NSString * const QCloudNewCOSV4ModuleName;

#endif