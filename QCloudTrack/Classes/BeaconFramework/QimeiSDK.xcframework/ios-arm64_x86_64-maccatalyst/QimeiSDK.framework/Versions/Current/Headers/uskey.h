//
//  uskey.h
//
//  Created by pariszhao on 2024/8/29.
//

#include <stdio.h>

#define KEEP_PUBLIC __attribute__((visibility("default")))

typedef const struct __UKInstance* UKInstance;

#ifdef __cplusplus
extern "C" {
#endif
  
    /// 获取Key单例
KEEP_PUBLIC UKInstance UKInstanceGetDefault();
  
    /// USkey初始化
KEEP_PUBLIC void UKInstanceInit(UKInstance instance, const char *app_key, const char *app_ver);
  
  
    /// 生成uskey加密字符串
    /// - Parameters:
    ///   - UKInstance, uskey实例对象
    ///   - bus_id, 由星迹分配，标识一个业务场景
    ///   - q36:调用QimeiSDK接口拿到的Q36
    ///   - bus_infos: k1=v1&k2=v2&k3=v3&k4=&k5=v5
KEEP_PUBLIC const char* UKInstanceGetUSkey(UKInstance instance, const char *bus_id, const char *q36, const char *bus_infos);
  
  
    /// 在用完uskey后需要调用该函数进行释放
    /// - Parameter uskey:UKInstanceGetUSkey返回的内容
KEEP_PUBLIC void UKInstanceFreeUskey(const char *uskey);
  
#ifdef __cplusplus
}
#endif
