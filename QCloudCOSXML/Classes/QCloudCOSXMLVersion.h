//
// QCloud Terminal Lab --- service for developers
//
#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCoreVersion.h>

#ifndef QCloudCOSXMLModuleVersion_h
#define QCloudCOSXMLModuleVersion_h
#define QCloudCOSXMLModuleVersionNumber 505002

//dependency
#if QCloudCoreModuleVersionNumber != 505002
    #error "库QCloudCOSXML依赖QCloudCore最小版本号为5.5.1，当前引入的QCloudCore版本号过低，请及时升级后使用" 
#endif

//
FOUNDATION_EXTERN NSString * const QCloudCOSXMLModuleVersion;
FOUNDATION_EXTERN NSString * const QCloudCOSXMLModuleName;

#endif
