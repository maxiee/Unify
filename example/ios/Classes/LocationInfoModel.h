// =================================================
// Autogenerated from Unify, do not edit directly.
// =================================================

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
  定位经纬度信息 实体类
*/
@interface LocationInfoModel : NSObject

@property(nonatomic, strong) NSNumber* lat; // 维度 Origin dart type is 'double'
@property(nonatomic, strong) NSNumber* lng; // 经度 Origin dart type is 'double'

+ (LocationInfoModel*)fromMap:(NSDictionary<NSString*, NSObject*>*)dict;
+ (NSArray<LocationInfoModel*>*)modelList:(NSArray<NSDictionary<NSObject*, NSObject*>*>*)list;
+ (NSArray<NSDictionary<NSObject*, NSObject*>*>*)dicList:(NSArray<LocationInfoModel*>*)list;

- (NSDictionary<NSString*, NSObject*>*)toMap;

@end

NS_ASSUME_NONNULL_END