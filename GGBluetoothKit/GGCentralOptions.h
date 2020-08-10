//
//  GGCentralOptions.h
//  GGBluetooth
//
//  Created by marsung on 18/6/13.
//  Copyright © 2018 com.marsung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CBUUID.h>
#import "GGBLEOptions.h"

typedef NS_ENUM(NSInteger, GGUUIDsType) {
    GGUUIDsTypeUnkown       = 0 ,
    GGUUIDsTypeRead         = 1 << 1,
    GGUUIDsTypeNotify       = 1 << 2,
    GGUUIDsTypeWrite        = 1 << 3,
    GGUUIDsTypeReadAndNotiy = GGUUIDsTypeRead | GGUUIDsTypeNotify,
    GGUUIDsTypeAll          = GGUUIDsTypeRead | GGUUIDsTypeWrite | GGUUIDsTypeNotify
};

@class CBCentralManager,CBPeripheral;

typedef void (^GGOnCentralManagerUpdateStateBlock)(CBCentralManager *_Nonnull central,NSString * _Nonnull logMsg);
typedef void (^GGOnRestoreBlcok)(CBCentralManager *_Nonnull central,NSDictionary<NSString *, id> *_Nonnull dic);
typedef void (^GGOnScanBlock)(CBCentralManager *_Nonnull central,CBPeripheral *_Nonnull peripheral,NSDictionary<NSString *, id> * _Nonnull advertisementData,NSNumber *_Nonnull RSSI);
typedef void (^GGOnConnectBlock)(CBCentralManager *_Nonnull central,CBPeripheral *_Nonnull peripheral,BOOL success,NSError *_Nullable error);
typedef void (^GGOnDisconnectBlock)(CBCentralManager *_Nonnull central,CBPeripheral *_Nonnull peripheral,NSError *_Nullable error);

typedef void (^GGOnUpdateNameBlock)(CBPeripheral *_Nonnull peripheral);
typedef void (^GGOnReadRSSIBlock)(CBPeripheral *_Nonnull peripheral,NSNumber *_Nonnull RSSI,NSError *_Nullable error);

typedef void (^GGOnDiscoverServicesBlock)(CBPeripheral *_Nonnull peripheral,GGServices *_Nonnull services,NSError *_Nullable error);
typedef void (^GGOnDiscoverCharacteristicsBlock)(CBPeripheral *_Nonnull peripheral,GGCharacteristics *_Nonnull characteristics,NSError *_Nullable error);

typedef void (^GGOnDidUpdateValueBlock)(CBPeripheral *_Nonnull peripheral,CBCharacteristic *_Nonnull characteristic,NSError *_Nullable error);

typedef void (^GGOnUpdateNotificationStateBlock)(CBPeripheral *_Nonnull peripheral,CBCharacteristic *_Nonnull characteristic,NSError *_Nullable error);
typedef void (^GGOnWriteValueBlock)(CBPeripheral *_Nonnull peripheral,CBCharacteristic *_Nonnull characteristic,NSError *_Nullable error);
typedef void (^GGOnDidUpdateNotificationStateBlock)(CBPeripheral *_Nonnull peripheral,CBCharacteristic *_Nonnull characteristic,NSError *_Nullable error);

typedef void (^GGOnDiscoverDescriptors)(CBPeripheral *_Nonnull peripheral,CBCharacteristic *_Nonnull characteristic,NSError *_Nullable error);
typedef void (^GGOnReadDescriptor)(CBPeripheral *_Nonnull peripheral,CBDescriptor *_Nonnull descriptor,NSError *_Nullable error);
typedef void (^GGOnWriteDescriptor)(CBPeripheral *_Nonnull peripheral,CBDescriptor *_Nonnull descriptor,NSError *_Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface GGCentralCharacterUUID : GGBLEOptions
@property (nonatomic, strong, readonly) CBUUID *UUID;
@property (nonatomic, assign, readonly) GGUUIDsType type;

- (GGCentralCharacterUUID *)initWithhUUIDString:(NSString *)uuidString type:(GGUUIDsType)type;
+ (GGCentralCharacterUUID *)setWithUUIDString:(NSString *)uuidString type:(GGUUIDsType)type;
@end


@interface GGCentralOptions : NSObject
@property (nonatomic, copy) NSString *bleName;
/**
 @{
    @"serviceUUID1":@[[GGBLECharacterUUID setWithUUIDString:uuid type:GGUUIDsTypeRead | GGUUIDsTypeNotify]],
    ...
 }
 */

@property (nonatomic, strong) NSDictionary <NSString *,NSArray<GGCentralCharacterUUID*> *> *configOptions;
/**
 scanOptions
 
 default: @{CBCentralManagerScanOptionAllowDuplicatesKey: [NSNumber numberWithBool:NO]}
 */
@property (nonatomic, strong) NSDictionary<NSString *, id> *scanOptions;
/**
 connectOptions
 
 default:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}
 */
@property (nonatomic, strong) NSDictionary<NSString *, id> *connectOptions;

@property (nonatomic, strong, readonly) GGUUIDs *servicesUUIDs;
@property (nonatomic, strong, readonly) GGUUIDs *characteristcsUUIDs;

- (nullable NSArray<CBUUID *> *)getCharacteristicsUUIDsWithServiceUUID:(NSString *)sUUID forUUIDsType:(GGUUIDsType)type;

@end

NS_ASSUME_NONNULL_END
