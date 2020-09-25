/**
*
*     _ __ __ __        _ __ __ __
*    / __ __ __ |     /  __ __ __ |
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

#import "GGBLECentralManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "GGBLEHeader.h"
#import "GGError.h"

DECLARE_ENUM(GG_CBManagerState, GG_ENUM)
DECLARE_ENUM(GG_CBCentralManagerState, GG_CENTRAL_ENUM)

@interface GGBLECentralManager()<CBCentralManagerDelegate,CBPeripheralDelegate>
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) GGCentralOptions *ggOptions;
@property (nonatomic, strong) NSMutableArray <CBPeripheral*> *searchedPeripherals;
@property (nonatomic, strong) NSMutableArray <CBPeripheral*> *connectedPeripherals;
@property (nonatomic, strong) NSMutableArray <CBPeripheral*> *reconnectPeripherals;

@property (nonatomic, assign) BOOL poweredOn;
@end

@implementation GGBLECentralManager
{
    GGOnCentralManagerUpdateStateBlock  mgrOpenState;
    GGOnRestoreBlcok                    mgrRestore;
    GGOnScanBlock                       mgrScanPeripherals;
    GGOnConnectBlock                    mgrConnect;
    
    GGOnDisconnectBlock                 mgrDidDisconnect;
    GGOnDiscoverServicesBlock           mgrDiscoverServices;
    GGOnDiscoverCharacteristicsBlock    mgrDiscoverCharacteristics;
    GGOnUpdateNotificationStateBlock    mgrUpdateNotificationState;
    
    GGOnDidUpdateValueBlock             mgrDidUpdateValue;
    GGOnWriteValueBlock                 mgrWriteValue;
    GGOnDidUpdateNotificationStateBlock mgrDidUpdateNoficationState;
    
    GGOnUpdateNameBlock                 mgrUpdateName;
    GGOnReadRSSIBlock                   mgrReadRSSI;
    
    GGOnDiscoverDescriptors             mgrDiscoverDescriptors;
    GGOnReadDescriptor                  mgrReadDescriptor;
    GGOnWriteDescriptor                 mgrWriteDescriptor;
}


/// Open Service
/// @param onMainThread <#onMainThread description#>
/// @param bleOptions <#bleOptions description#>
/// @param complete <#complete description#>
- (void)openServiceWithOnMainThread:(BOOL)onMainThread bleOptions:(GGCentralOptions *_Nullable)bleOptions complete:(GGOnCentralManagerUpdateStateBlock)complete {
    self.ggOptions = bleOptions;
    if (complete) {
        mgrOpenState = complete;
    }
     __block dispatch_queue_t centralManagerQueue;
    if (!onMainThread) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            centralManagerQueue = dispatch_queue_create("GuoguoCentralManagerQueue", DISPATCH_QUEUE_SERIAL);
        });
    }else{
        centralManagerQueue = nil;
    }
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_6_0
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES],CBCentralManagerOptionShowPowerAlertKey,
                             @"GuoguoCentralRestore",CBCentralManagerOptionRestoreIdentifierKey,
                             nil];
#else
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES],CBCentralManagerOptionShowPowerAlertKey,
                             nil];
#endif
    NSArray *backgroundModes = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIBackgroundModes"];
    
    if ([backgroundModes containsObject:@"bluetooth-central"]) {
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:centralManagerQueue options:options];
    }else{
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:centralManagerQueue options:nil];
    }
}

/// Scan peripherals
- (void)scanPeripherals {
    if (_scanEnable) {
        [self.centralManager scanForPeripheralsWithServices:_ggOptions.servicesUUIDs options:_ggOptions.scanOptions];
    }
}

/// Stop scan peripherals
- (void)stopScanPeripheral {
    if (@available(iOS 9.0, *)) {
        if (self.centralManager.isScanning) {
            [self.centralManager stopScan];
        }
    } else {
        // Fallback on earlier versions
        [self.centralManager stopScan];
    }
}


/// Central connect peripheral
/// @param peripheral <#peripheral description#>
/// @param complete <#complete description#>
- (void)connectPeripheral:(CBPeripheral *)peripheral complete:(GGOnConnectBlock)complete {
    if (complete) {
        mgrConnect = complete;
    }
    if (peripheral) {
        [self.centralManager connectPeripheral:peripheral options:self.ggOptions.connectOptions];
    }else{
        GGError *error = [[GGError alloc] initWithBLEErrorCode:GGEC_PeripherlIsNil
        userInfo: @{
                    GGErroUserInfoDescriptionKey:@"PeripherlIsNil",
                    GGErroUserInfoReasonKey:@"excute the method of `disconnectPeripheral:complete:` peripheral is fail",
                    GGErroUserInfoSuggestionKey:@"the pheripheral must be not nill",
        }];
        GGLog(@"%@",error);
    }
}


/// DisConnect peripherial
/// @param peripheral <#peripheral description#>
- (void)disConnectPeripherial:(CBPeripheral *)peripheral {
    if (peripheral) {
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
}

- (void)discoverServicesWithPeripheral:(CBPeripheral *)peripheral serviceUUIDs:(nullable NSArray<CBUUID *> *)serviceUUIDs {
    [peripheral discoverServices:serviceUUIDs];
}

- (void)discoverCharacteristicsWithPeripheral:(CBPeripheral *)peripheral characteristicsUUIDs:(nullable NSArray<CBUUID *> *)characteristicUUIDs forService:(CBService *)service {
    [peripheral discoverCharacteristics:characteristicUUIDs forService:service];
}

#pragma mark- Characteristic operation
/// Read value
/// @param peripheral <#peripheral description#>
/// @param characteristic <#characteristic description#>
- (void)readValueWithPeripheral:(CBPeripheral *)peripheral forCharacteristic:(CBCharacteristic *)characteristic {
    [peripheral readValueForCharacteristic:characteristic];
}

/// Notify value
/// @param peripheral <#peripheral description#>
/// @param isNotify <#isNotify description#>
/// @param characteristic <#characteristic description#>
- (void)notifyValueWithPeripheral:(CBPeripheral *)peripheral isNotify:(BOOL)isNotify forCharacteristic:(CBCharacteristic *)characteristic {
    [peripheral setNotifyValue:isNotify forCharacteristic:characteristic];
}

/// Write data with callback for verify
/// @param data <#data description#>
/// @param peripheral <#peripheral description#>
/// @param characteristic <#characteristic description#>
/// @param callback <#callback description#>
- (void)writeData:(NSData *)data forPeripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic callback:(void (^)(BOOL success,NSError *error))callback {
            if ((characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) != 0) {
                [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
                if(callback) callback(YES,nil);
           }else if((characteristic.properties & CBCharacteristicPropertyWrite) != 0){
               [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
               if(callback) callback(YES,nil);
           }else{
               GGError *error = [[GGError alloc] initWithBLEErrorCode:GGEC_InvalidCharacteristicPropertyWriteType
               userInfo: @{
                           GGErroUserInfoDescriptionKey:@"InvalidCharacteristicPropertyWriteType",
                           GGErroUserInfoReasonKey:[NSString stringWithFormat:@"No write property on transport characteristic, %lu.",characteristic.properties],
                           GGErroUserInfoSuggestionKey:@"please choose the characteristic who`s write type is `CBCharacteristicPropertyWriteWithoutResponse` or `CBCharacteristicWriteWithResponse`.",
               }];
               
               GGLog(@"%@",error);
               if(callback){
                   callback(NO,error);
               }
           }
}


#pragma mark- Descriptor
- (void)discoverDescriptorsWithPeripheral:(CBPeripheral *)peripheral forCharacteristic:(CBCharacteristic *)characteristic {
    [peripheral discoverDescriptorsForCharacteristic:characteristic];
}

- (void)readValueForDescriptorWithPeripheral:(CBPeripheral *)peripheral forCharacteristic:(CBCharacteristic *)characteristic {
    for (CBDescriptor *desciptor in characteristic.descriptors) {
        [peripheral readValueForDescriptor:desciptor];
    }
}

#pragma mark- Tool methods
/// Disconnect all peripherals
- (void)disconnectAllPeripherals {
    for (CBPeripheral *per in self.connectedPeripherals) {
        [self disConnectPeripherial:per];
    }
}
/// Get peripherals for connected
- (NSArray <CBPeripheral *> *)getPeripheralsForDidConnected {
    return self.connectedPeripherals;
}



#pragma mark -set callback for central and peripheral

- (void)setScanNofication:(GGOnScanBlock)complete {
    if (complete) {
        mgrScanPeripherals = complete;
    }
}

- (void)setConnectNotification:(GGOnConnectBlock)complete {
    if (complete) {
        mgrConnect = complete;
    }
}

- (void)setDisconnectNotification:(GGOnDisconnectBlock)complete {
    if (complete) {
        mgrDidDisconnect = complete;
    }
}

- (void)setDiscoverServicesNotification:(GGOnDiscoverServicesBlock)complete {
    if (complete) {
        mgrDiscoverServices = complete;
    }
}

- (void)setDiscoverCharacteristicsNotificaiton:(GGOnDiscoverCharacteristicsBlock)complete {
    if (complete) {
        mgrDiscoverCharacteristics = complete;
    }
}

- (void)setDidUpdateValueForCharacteristicNotification:(GGOnDidUpdateValueBlock)complete {
    if (complete) {
        mgrDidUpdateValue = complete;
    }
}


- (void)setDidWriteValueNotification:(GGOnWriteValueBlock)complete {
    if (complete) {
        mgrWriteValue = complete;
    }
}

- (void)setDidUpdateNotificationStateNotification:(GGOnDidUpdateNotificationStateBlock)complete {
    if (complete) {
        mgrDidUpdateNoficationState = complete;
    }
}

- (void)setDidUpdateNameNotification:(GGOnUpdateNameBlock)complete {
    if (complete) {
        mgrUpdateName = complete;
    }
}

- (void)setDidUpdateRSSINotification:(GGOnReadRSSIBlock)complete {
    if (complete) {
        mgrReadRSSI = complete;
    }
}

- (void)setDidDiscoverDescriptorsNotification:(GGOnDiscoverDescriptors)complete {
    if (complete) {
        mgrDiscoverDescriptors = complete;
    }
}

- (void)setReadDescriptorNotification:(GGOnReadDescriptor)complete {
    if (complete) {
        mgrReadDescriptor = complete;
    }
}

- (void)setDidWriteDescripNotification:(GGOnWriteDescriptor)complete {
    if (complete) {
        mgrWriteDescriptor = complete;
    }
}

#pragma -mark CBCentralManagerDelegate

DEFINE_ENUM(GG_CBManagerState, GG_ENUM)
DEFINE_ENUM(GG_CBCentralManagerState, GG_CENTRAL_ENUM)

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSString *logMsg = nil;
    if (GGAPIAvailable(10.0, 10.13)) {
        logMsg = NSStringFromGG_CBManagerState((GG_CBManagerState)central.state);
        self.poweredOn = central.state == CBManagerStatePoweredOn ? YES:NO;
    }else {
        logMsg = NSStringFromGG_CBCentralManagerState((GG_CBCentralManagerState)central.state);
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        self.poweredOn = central.state == CBCentralManagerStatePoweredOn ? YES:NO;
    #pragma clang diagnostic pop
    }
    GGLog(@"central state: %@",logMsg);
    if (mgrOpenState) {
        mgrOpenState(central,logMsg);
    }
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict {
    if (mgrRestore) {
        mgrRestore(central,dict);
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    if (mgrScanPeripherals) {
        mgrScanPeripherals(central,peripheral,advertisementData,RSSI);
    }
    if (_connectEnable) {
        if (self.ggOptions.bleName) {
            if ([self.ggOptions.bleName isEqualToString:peripheral.name]) {
                [self __addPeripheralForSearched:peripheral];
            }
        }else{
            [self __addPeripheralForSearched:peripheral];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    GGLog(@"peripheral for didConneced:%@",peripheral);
    [self __removePeripheralForSearched:peripheral];
    [self __addPeripheralForDidConnected:peripheral];
    [self __removePeripheralForReconnect:peripheral];
    
    peripheral.delegate = self;
    if (mgrConnect) {
        mgrConnect(central,peripheral,YES,nil);
    }
    if (_discoverServicesEnable) {
        [peripheral discoverServices:self.ggOptions.servicesUUIDs];
    }
}


- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    GGLog(@"didFailToConnectPeripheral: %@",error.description);
    [self __removePeripheralForSearched:peripheral];
    [self __removePeripheralForDidConnected:peripheral];
    if (mgrConnect) {
        mgrConnect(central,peripheral,NO,error);
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    GGLog(@"didDisconnectPeripheral: %@",error.description);
    [self __removePeripheralForSearched:peripheral];
    [self __removePeripheralForDidConnected:peripheral];
    [self __addPeripheralForReconnect:peripheral];
    if (mgrDidDisconnect) {
        mgrDidDisconnect(central,peripheral,error);
    }
}


#pragma mark- CBPeripheralDelegate

- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral {
    GGLog(@"peripheral update name:%@  ->peripheral:%@",peripheral.name,peripheral);
    if (mgrUpdateName) {
        mgrUpdateName(peripheral);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error {
    if (error) {
        GGLog(@"Error didReadRSSI: %@",error);
    }
    if (mgrReadRSSI) {
        mgrReadRSSI(peripheral,RSSI,error);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        GGLog(@"Error discovering services: %@", error);
    }
    if (mgrDiscoverServices) {
        mgrDiscoverServices(peripheral,peripheral.services,error);
    }
    if (_discoverCharacteristicsEnable) {
        for (CBService *service in peripheral.services) {
            [peripheral discoverCharacteristics:[self.ggOptions getCharacteristicsUUIDsWithServiceUUID:service.UUID.UUIDString forUUIDsType:GGUUIDsTypeReadAndNotify] forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error){
        GGLog(@"Error discovering characteristics: %@", error);
    }
    if (mgrDiscoverCharacteristics) {
        mgrDiscoverCharacteristics(peripheral,service.characteristics,error);
    }
    
    NSArray *readUUIDs = [self.ggOptions getCharacteristicsUUIDsWithServiceUUID:service.UUID.UUIDString forUUIDsType:GGUUIDsTypeRead];
    NSArray *notifyUUIDs = [self.ggOptions getCharacteristicsUUIDsWithServiceUUID:service.UUID.UUIDString forUUIDsType:GGUUIDsTypeNotify];
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        if (_readValueEnable) {
            for (CBUUID *uuid in readUUIDs) {
                if ([characteristic.UUID.UUIDString isEqualToString:uuid.UUIDString]) {
                    [peripheral readValueForCharacteristic:characteristic];
                }
            }
        }
        if (_notifyValueEnable) {
            for (CBUUID *uuid in notifyUUIDs) {
                if ([characteristic.UUID.UUIDString isEqualToString:uuid.UUIDString]) {
                    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                }
            }
        }
    }
    // description
    if (_discoverDescriptorsCharacteristicEnable) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            [peripheral discoverDescriptorsForCharacteristic:characteristic];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (error){
        GGLog(@"Error update notificaion state characteristics: %@", error);
    }
    if (mgrDidUpdateNoficationState) {
        mgrDidUpdateNoficationState(peripheral,characteristic,error);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        GGLog(@"Error RX notification for characteristic %@: %@", characteristic, error);
    }
    if (mgrDidUpdateValue) {
        mgrDidUpdateValue(peripheral,characteristic,error);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (error) {
        GGLog(@"Error TX notification for characteristic %@: %@", characteristic, error);
    }
    if (mgrWriteValue) {
        mgrWriteValue(peripheral,characteristic,error);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    if (mgrDiscoverDescriptors) {
        mgrDiscoverDescriptors(peripheral,characteristic,error);
    }
    
    if (_readValueForDescriptorsEnable) {
        for (CBDescriptor *des in characteristic.descriptors) {
            [peripheral readValueForDescriptor:des];
        }
    }
    if (_onceReadValueForDescriptorsEnable) {
        for (CBDescriptor *des in characteristic.descriptors) {
            [peripheral readValueForDescriptor:des];
        }
        self.onceReadValueForDescriptorsEnable = NO;
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error{
    if (mgrReadDescriptor) {
        mgrReadDescriptor(peripheral,descriptor,error);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error{
    if (mgrWriteDescriptor) {
        mgrWriteDescriptor(peripheral,descriptor,error);
    }
}

#pragma mark -private method
- (void)__addPeripheralForSearched:(CBPeripheral *)peripheral
{
    BOOL has = NO;
    for (NSInteger i = 0;i < self.searchedPeripherals.count;i++) {
        CBPeripheral *per = self.searchedPeripherals[i];
        if ([per.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            has = YES;
        }
    }
    if (!has) {
        GGLog(@"Did scaned peripheral: %@",peripheral);
        [self.searchedPeripherals addObject:peripheral];
        [self.centralManager connectPeripheral:peripheral options:self.ggOptions.connectOptions];
    }
}

- (void)__removePeripheralForSearched:(CBPeripheral *)peripheral
{
    NSInteger index = -1;
    for (NSInteger i = 0;i < self.searchedPeripherals.count;i++) {
        CBPeripheral *per = self.searchedPeripherals[i];
        if ([per.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            index = i;
        }
    }
    if (index >0) {
        [self.searchedPeripherals removeObject:self.searchedPeripherals[index]];
    }
}

- (void)__addPeripheralForDidConnected:(CBPeripheral *)peripheral
{
    BOOL has = NO;
    NSInteger index = -1;
    for (NSInteger i = 0;i < self.connectedPeripherals.count;i++) {
        CBPeripheral *per = self.connectedPeripherals[i];
        if ([per.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            has = YES;
            if (per.state == CBPeripheralStateConnecting || per.state == CBPeripheralStateConnected) return;
            index = i;
        }
    }
    if (index >0) {
       [self.connectedPeripherals removeObject:self.connectedPeripherals[index]];
    }
    if (!has) {
        [self.connectedPeripherals addObject:peripheral];
    }
}

- (void)__removePeripheralForDidConnected:(CBPeripheral *)peripheral
{
    NSInteger index = -1;
    for (NSInteger i = 0;i < self.connectedPeripherals.count;i++) {
        CBPeripheral *per = self.connectedPeripherals[i];
        if ([per.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            index = i;
        }
    }
    if (index >0) {
        [self.connectedPeripherals removeObject:self.connectedPeripherals[index]];
    }
}

- (void)__addPeripheralForReconnect:(CBPeripheral *)peripheral
{
    BOOL has = NO;
    for (NSInteger i = 0;i < self.reconnectPeripherals.count;i++) {
        CBPeripheral *per = self.reconnectPeripherals[i];
        if ([per.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            has = YES;
        }
    }
    if (!has) {
        [self.reconnectPeripherals addObject:peripheral];
    }
    for (CBPeripheral *peripheral in self.reconnectPeripherals) {
        // auto repconnect for disconnnected
        [self connectPeripheral:peripheral complete:^(CBCentralManager *central, CBPeripheral *peripheral, BOOL success, NSError *error) {
            GGLog(@"peripheral:%@ %@ , %@",peripheral,[NSString stringWithFormat:@"auto reConnect:%@",success ? @"success":@"fail"],error);
        }];
    }
}

- (void)__removePeripheralForReconnect:(CBPeripheral *)peripheral
{
    NSInteger index = -1;
    for (NSInteger i = 0;i < self.reconnectPeripherals.count;i++) {
        CBPeripheral *per = self.reconnectPeripherals[i];
        if ([per.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            index = i;
        }
    }
    if (index >0) {
        [self.reconnectPeripherals removeObject:self.reconnectPeripherals[index]];
    }
}

- (CBPeripheral *)__getPeripheral:(CBPeripheral *)peripheral
{
    for (CBPeripheral *per in self.searchedPeripherals) {
        if ([per.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            return per;
        }
    }
    return nil;
}

- (void)__addPeripheral:(CBPeripheral *)peripheral
{
    if (![self.searchedPeripherals containsObject:peripheral]) {
        [self.searchedPeripherals addObject:peripheral];
    }
}

- (void)__removePeripheral:(CBPeripheral *)pBox
{
    if ([self.searchedPeripherals containsObject:pBox]) {
        [self.searchedPeripherals removeObject:pBox];
    }
}

#pragma mark - getter
- (NSMutableArray<CBPeripheral *> *)searchedPeripherals {
    if (!_searchedPeripherals) {
        _searchedPeripherals = [NSMutableArray array];
    }
    return _searchedPeripherals;
}

- (NSMutableArray<CBPeripheral *> *)connectedPeripherals {
    if (!_connectedPeripherals) {
        _connectedPeripherals = [NSMutableArray array];
    }
    return _connectedPeripherals;
}

- (NSMutableArray<CBPeripheral *> *)reconnectPeripherals {
    if (!_reconnectPeripherals) {
        _reconnectPeripherals = [NSMutableArray array];
    }
    return _reconnectPeripherals;
}
@end
