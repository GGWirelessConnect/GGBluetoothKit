//
//  GGBLECentralManager.h
//  GGBluetooth
//
//  Created by marsung on 18/6/13.
//  Copyright © 2018 com.marsung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGCentralOptions.h"

NS_ASSUME_NONNULL_BEGIN
@interface GGBLECentralManager : NSObject
@property (nonatomic, assign) BOOL scanEnable;
@property (nonatomic, assign) BOOL connectEnable;
@property (nonatomic, assign) BOOL discoverServicesEnable;
@property (nonatomic, assign) BOOL discoverCharacteristicsEnable;
@property (nonatomic, assign) BOOL readValueEnable;
@property (nonatomic, assign) BOOL notifyValueEnable;
@property (nonatomic, assign) BOOL discoverDescriptorsCharacteristicEnable;
@property (nonatomic, assign) BOOL readValueForDescriptorsEnable;
@property (nonatomic, assign) BOOL onceReadValueForDescriptorsEnable;

/// Open Service
/// @param onMainThread <#onMainThread description#>
/// @param bleOptions <#bleOptions description#>
/// @param complete <#complete description#>
- (void)openServiceWithOnMainThread:(BOOL)onMainThread bleOptions:(GGCentralOptions *_Nullable)bleOptions complete:(GGOnCentralManagerUpdateStateBlock)complete;

/// Scan peripherals
- (void)scanPeripherals;

/// Stop scan peripherals
- (void)stopScanPeripheral;

/// Central connect peripheral
/// @param peripheral <#peripheral description#>
/// @param complete <#complete description#>
- (void)connectPeripheral:(CBPeripheral *)peripheral complete:(GGOnConnectBlock)complete;

/// DisConnect peripherial
/// @param peripheral <#peripheral description#>
- (void)disConnectPeripherial:(CBPeripheral *)peripheral;

/// discover services
/// @param peripheral <#peripheral description#>
/// @param serviceUUIDs <#serviceUUIDs description#>
- (void)discoverServicesWithPeripheral:(CBPeripheral *)peripheral serviceUUIDs:(nullable NSArray<CBUUID *> *)serviceUUIDs;

/// discover characteristics
/// @param peripheral <#peripheral description#>
/// @param characteristicUUIDs <#characteristicUUIDs description#>
/// @param service <#service description#>
- (void)discoverCharacteristicsWithPeripheral:(CBPeripheral *)peripheral characteristicsUUIDs:(nullable NSArray<CBUUID *> *)characteristicUUIDs forService:(CBService *)service;


#pragma mark- Characteristic operation

/// Read value
/// @param peripheral <#peripheral description#>
/// @param characteristic <#characteristic description#>
- (void)readValueWithPeripheral:(CBPeripheral *)peripheral forCharacteristic:(CBCharacteristic *)characteristic;

/// Notify value 
/// @param peripheral <#peripheral description#>
/// @param isNotify <#isNotify description#>
/// @param characteristic <#characteristic description#>
- (void)notifyValueWithPeripheral:(CBPeripheral *)peripheral isNotify:(BOOL)isNotify forCharacteristic:(CBCharacteristic *)characteristic;

/// Write data with callback for verify
/// @param data <#data description#>
/// @param peripheral <#peripheral description#>
/// @param characteristic <#characteristic description#>
/// @param callback <#callback description#>
- (void)writeData:(NSData *)data forPeripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic callback:(void (^)(BOOL success,NSError *error))callback;


#pragma mark- Descriptor

/// discover Descriptors
/// @param peripheral <#peripheral description#>
/// @param characteristic <#characteristic description#>
- (void)discoverDescriptorsWithPeripheral:(CBPeripheral *)peripheral forCharacteristic:(CBCharacteristic *)characteristic;

/// read value for descriptor
/// @param peripheral <#peripheral description#>
/// @param characteristic <#characteristic description#>
- (void)readValueForDescriptorWithPeripheral:(CBPeripheral *)peripheral forCharacteristic:(CBCharacteristic *)characteristic;

#pragma mark- Tool methods
/// Disconnect all peripherals
- (void)disconnectAllPeripherals;
/// Get peripherals for connected
- (NSArray <CBPeripheral *> *)getPeripheralsForDidConnected;

#pragma mark- some callback[notification]
- (void)setScanNofication:(GGOnScanBlock)complete;
- (void)setConnectNotification:(GGOnConnectBlock)complete;
- (void)setDisconnectNotification:(GGOnDisconnectBlock)complete;
- (void)setDiscoverServicesNotification:(GGOnDiscoverServicesBlock)complete;
- (void)setDiscoverCharacteristicsNotificaiton:(GGOnDiscoverCharacteristicsBlock)complete;
/// Set notifcation for device did update value. this method must be used, otherwise you can`t recieve any data from peripheral.
/// @param complete <#complete description#>
- (void)setDidUpdateValueForCharacteristicNotification:(GGOnDidUpdateValueBlock)complete;

- (void)setDidUpdateNotificationStateNotification:(GGOnDidUpdateNotificationStateBlock)complete;
- (void)setDidWriteValueNotification:(GGOnWriteValueBlock)complete;

- (void)setDidUpdateNameNotification:(GGOnUpdateNameBlock)complete;
- (void)setDidUpdateRSSINotification:(GGOnReadRSSIBlock)complete;

- (void)setDidDiscoverDescriptorsNotification:(GGOnDiscoverDescriptors)complete;
- (void)setReadDescriptorNotification:(GGOnReadDescriptor)complete;
- (void)setDidWriteDescripNotification:(GGOnWriteDescriptor)complete;

@end

NS_ASSUME_NONNULL_END
