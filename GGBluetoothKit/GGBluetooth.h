/**
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
#import <CoreBluetooth/CoreBluetooth.h>
#import "GGBLEHeader.h"
#import "GGBLECentralManager.h"
#import "GGBLEPeripheralManager.h"

@interface GGBluetooth : NSObject
/// Singleton 
+ (GGBluetooth *)manager;

#pragma mark *****************************************************  Central Mode   *****************************************************


/**
 *  Automator function - 自动化操作
 *
 *  @discuss
 *  Auto connect peripherals, auto discover servcies, discover characteristics, read value for characteristic and descriptor.
 *  自动连接外设并发现服务，外设特征，读取外设信息。
 *
 * param: <#onMainThread#> GGBluetooth will be excute on main thread or multi-thread [是否开启多线程，默认在主线程工作];
 * param: <#options#> options include peripheral name,config options,scan options and connect options. NOTICE: you can`t set peripheral name and config options both nil;[配置信息：包括蓝牙名称，服务UUID，特征UUID等]
 * callback block: `<#void(^)(BOOL success,CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error)#>` is equal to `<#peripheral:didUpdateValueForCharacteristic:error:#>`;[回调信息]
 */
- (GGBluetooth *(^)(BOOL onMainThread,GGCentralOptions *options,void(^)(BOOL success,CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error)))automator;


#pragma mark- Function syntactic sugar
/**
*  setup  - 启动
*
*  @discuss:
*  链式语结构：1.setup(NO,options)scan().connect().discoverServices().discoverCharacteristics().readValue().notifyValue().discoverDesciptors().readValueForDescriptors().commit();
*
* param: <#onMainThread#> GGBluetooth will be excute on main thread or multi-thread [是否开启多线程，默认在主线程工作];
* param: <#options#> options include peripheral name,config options,scan options and connect options. NOTICE: you can`t set peripheral name and config options both nil;[配置信息：包括蓝牙名称，服务UUID，特征UUID等]
*/
- (GGBluetooth *(^)(BOOL onMainThread,GGCentralOptions *options))setup;
- (GGBluetooth *(^)(void))scan;
- (GGBluetooth *(^)(void))connect;
- (GGBluetooth *(^)(void))discoverServices;
- (GGBluetooth *(^)(void))discoverCharacteristics;
- (GGBluetooth *(^)(void))readValue;
- (GGBluetooth *(^)(void))notifyValue;
- (GGBluetooth *(^)(void))discoverDesciptors;
- (GGBluetooth *(^)(void))readValueForDescriptors;
- (GGBluetooth *(^)(void))commit;

/// Commit with callback for did update value for characteristic.
- (GGBluetooth *(^)(void(^)(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error)))commitWithDidUpdateValueForCharacteristicCallback;


#pragma mark-  Manual mode  [For step funcation]
///  setup and scan and callback
- (GGBluetooth *(^)(BOOL onMainThread,void(^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary<NSString *, id> *advertisementData,NSNumber *RSSI)))setupAndScan;
/// stop scan peripherals
- (GGBluetooth *(^)(void))doStopScan;
/// connect and callback
- (GGBluetooth *(^)(CBPeripheral *peripheral,void(^)(CBCentralManager *central,BOOL success,NSError *error)))doConnect;
///disconnect and callback
- (GGBluetooth *(^)(CBPeripheral *peripheral, void(^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error)))doDisconnect;
/// discoverServices and callback
- (GGBluetooth *(^)(CBPeripheral *peripheral,GGUUIDs *serviceUUIDs,void(^)(CBPeripheral *peripheral,GGServices *services,NSError *error)))doDiscoverServices;
/// discoverCharateristics and callback
- (GGBluetooth *(^)(CBPeripheral *peripheral,GGUUIDs *characteristicUUIDs,CBService *service, void(^)(CBPeripheral *peripheral,GGCharacteristics *characteristics,NSError *error)))doDiscoverCharateristics;
/// didUpdateValueForCharacteritic and callback
- (GGBluetooth *(^)(CBPeripheral *peripheral,CBCharacteristic *c,void(^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error)))doDidUpdateValueForCharacteritic;


#pragma mark- Characteristic operation without callback
///  Read value
/// @param peripheral <#peripheral description#>
/// @param characteristic <#characteristic description#>
- (void)setReadValueWithPeripheral:(CBPeripheral *)peripheral forCharacteristic:(CBCharacteristic *)characteristic;

/// Notfiy value
/// @param peripheral <#peripheral description#>
/// @param isNotify <#isNotify description#>
/// @param characteristic <#characteristic description#>
- (void)setNotifyValueWithPeripheral:(CBPeripheral *)peripheral isNotify:(BOOL)isNotify forCharacteristic:(CBCharacteristic *)characteristic;

/// Write data
/// @param data <#data description#>
/// @param peripheral <#peripheral description#>
/// @param characteristic <#characteristic description#>
- (void)setWriteData:(NSData *)data forPeripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic;


#pragma mark- Characteristic operation with callback

/// Read value with callback
/// @param peripheral <#peripheral description#>
/// @param characteristic <#characteristic description#>
/// @param complete <#complete description#>
- (void)setReadValueWithPeripheral:(CBPeripheral *)peripheral forCharacteristic:(CBCharacteristic *)characteristic complete:(void(^)(BOOL success,CBCharacteristic *c,NSError *error))complete;


/// Notify value with callback
/// @param peripheral <#peripheral description#>
/// @param isNotify <#isNotify description#>
/// @param characteristic <#characteristic description#>
/// @param complete <#complete description#>
- (void)setNotifyValueWithPeripheral:(CBPeripheral *)peripheral isNotify:(BOOL)isNotify forCharacteristic:(CBCharacteristic *)characteristic complete:(void(^)(BOOL success,CBCharacteristic *c,NSError *error))complete;

/// Write data with callback
/// @param data <#data#>
/// @param peripheral <#peripheral description#>
/// @param characteristic <#characteristic description#>
/// @param complete <#complete description#>
- (void)setWriteData:(NSData *)data forPeripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic complete:(void(^)(BOOL success,CBCharacteristic *c,NSError *error))complete;



#pragma mark-  Callback
// callback: searched peripherals
- (void)setScanPeripheralsCallback:(void(^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary<NSString *, id> *advertisementData,NSNumber *RSSI))callback;
// callback: connected peripheral
- (void)setConnectPeripheralCallback:(void(^)(CBCentralManager * _Nonnull central, CBPeripheral * _Nonnull peripheral, BOOL success, NSError * _Nullable error))callback;
/// callback: disconnnect peripheral
/// @param callback callback(central,peripheral,error)
- (void)setDisconnectPeripheralCallback:(void(^)(CBCentralManager * _Nonnull central, CBPeripheral * _Nonnull peripheral, NSError * _Nullable error))callback;
// calllback: discover services
- (void)setDiscoverServicesCallback:(void(^)(CBPeripheral * _Nonnull peripheral, GGServices * _Nonnull services, NSError * _Nullable error))callback;
// callback: discover characteriscs
- (void)setDiscoverCharacteristicsCallback:(void(^)(CBPeripheral * _Nonnull peripheral, GGCharacteristics * _Nonnull characteristics, NSError * _Nullable error))callback;
// callback: update value for characteristic
- (void)setUpdateValueForCharacteristicCallback:(void(^)(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error))callback;

#pragma mark- Tool method
- (NSArray *)GG_getAllConnectedPeripherals;
- (void)GG_disconnectAllPeripherals;


#pragma mark *****************************************************  Peripheral Mode   *****************************************************
- (GGBluetooth *(^)(BOOL onMainTread, GGPeripheralOptions *peripheralOptions))openPeripheralService;
- (GGBluetooth *(^)(void))startAdvertising;
- (GGBluetooth *(^)(void))stopAdvertising;
- (GGBluetooth *(^)(NSData *data,NSString *uuidString))sendData;
- (GGBluetooth *(^)(NSData *data,NSString *characteristicUUIDString,void(^)(CBATTRequest *respond,NSError *error)))sendDataWithRespond;

#pragma mark- notification
- (void)setDidStartAdvertisingCallback:(GGPeripheralMgrDidStartAdvertising)callback;
- (void)setDidAddServiceCallback:(GGPeripheralMgrDidAddService)callback;
- (void)setDidSubscribeToCharacteristicCallback:(GGPeripheralMgrDidSubscribe)callback;
- (void)setDidUnsubscribeFromCharacteristicCallback:(GGPeripheralMgrDidUnsubscribe)callback;
- (void)setDidReceiveReadRequestCallback:(GGPeripheralMgrDidReceiveReadRequest)callback;
- (void)setDidReceiveWriteRequests:(GGPeripheralMgrDidReceiveWriteRequests)callback;
- (void)setIsReadyToUpdateSubscribers:(GGPeripheralMgrIsReadyToUpdateSubscribers)callback;
@end
