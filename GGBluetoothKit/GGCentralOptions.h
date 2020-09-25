/**
 *
 *     _ __ __ __        _ __ __ __
 *    / __ __ __ |     /  __ __ __ |
 *   / /              / /
 *  | |     __ __    | |      _ _ _
 *  | |    |_ __ |   | |     |_ _  |
 *   \ \ __ __ | |    \ \ __ __ _| |
 *    \ __ __ __ |     \ __ __ __ _|
 *
 *
 * This code is distributed under the terms and conditions of the MIT license.
 *
 * Created by GG on 2020/9/25
 * Copyright © 2018-2020 GG. All rights reserved.
 *
 * Organization: GGWirlessConnect (https://github.com/GGWirelessConnect)
 * Github Pages: https://github.com/GGWirelessConnect/GGBluetoothKit
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THESOFTWARE
*/

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CBUUID.h>
#import "GGBLEOptions.h"

typedef NS_ENUM(NSInteger, GGUUIDsType) {
    GGUUIDsTypeUnkown           = 0,
    GGUUIDsTypeRead             = 1 << 0,
    GGUUIDsTypeNotify           = 1 << 1,
    GGUUIDsTypeWrite            = 1 << 2,
    GGUUIDsTypeReadAndNotify    = GGUUIDsTypeRead | GGUUIDsTypeNotify,
    GGUUIDsTypeAll              = GGUUIDsTypeRead | GGUUIDsTypeWrite | GGUUIDsTypeNotify
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
