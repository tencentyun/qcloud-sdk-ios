//
//  QCloudBatchRecognitionUserInfo.h
//  QCloudCOSXML
//
//  Created by garenwang on 2023/6/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface QCloudBatchRecognitionUserInfo : NSObject

///  一般用于表示账号信息。
@property (nonatomic,strong)NSString * TokenId;

///  一般用于表示昵称信息。
@property (nonatomic,strong)NSString * Nickname;

///  一般用于表示设备信息。
@property (nonatomic,strong)NSString * DeviceId;

///  一般用于表示 App 的唯一标识。
@property (nonatomic,strong)NSString * AppId;

///  一般用于表示房间号信息。
@property (nonatomic,strong)NSString * Room;

///  一般用于表示 IP 地址信息。
@property (nonatomic,strong)NSString * IP;

///  一般用于表示业务类型。
@property (nonatomic,strong)NSString * Type;

///  一般用于表示接收消息的用户账号。
@property (nonatomic,strong)NSString * ReceiveTokenId;

///  一般用于表示性别信息。
@property (nonatomic,strong)NSString * Gender;

///  一般用于表示等级信息。
@property (nonatomic,strong)NSString * Level;

///  一般用于表示角色信息。
@property (nonatomic,strong)NSString * Role;


@end

NS_ASSUME_NONNULL_END
