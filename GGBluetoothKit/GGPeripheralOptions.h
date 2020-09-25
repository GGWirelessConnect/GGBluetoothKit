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
#import <CoreBluetooth/CBCharacteristic.h>
#import "GGBLEOptions.h"

@class CBPeripheralManager,CBCentral,CBATTRequest;
typedef void(^GGPeripheralMgrDidUpdateState)(CBPeripheralManager *pMgr,NSString *log);
typedef void (^GGPeripheralMgrRestoreState)(CBPeripheralManager *pMgr,NSDictionary<NSString *, id> *dict);
typedef void (^GGPeripheralMgrDidStartAdvertising)(CBPeripheralManager *pMgr,NSError *error);
typedef void (^GGPeripheralMgrDidAddService)(CBPeripheralManager *pMgr,CBService *service,NSError *error);

typedef void (^GGPeripheralMgrDidSubscribe)(CBPeripheralManager *pMgr,CBCentral *central,CBCharacteristic *characteristic);
typedef void (^GGPeripheralMgrDidUnsubscribe)(CBPeripheralManager *pMgr,CBCentral *central,CBCharacteristic *characteristic);
typedef void (^GGPeripheralMgrDidReceiveReadRequest)(CBPeripheralManager *pMgr,CBATTRequest *request);
typedef void (^GGPeripheralMgrDidReceiveWriteRequests)(CBPeripheralManager *pMgr,NSArray<CBATTRequest*> *requests);
typedef void (^GGPeripheralMgrRespond)(CBATTRequest *respond,NSError *error);
typedef void (^GGPeripheralMgrIsReadyToUpdateSubscribers)(CBPeripheralManager *pMgr);

NS_ASSUME_NONNULL_BEGIN


@interface GGPeripheralCharacteristic : NSObject
@property (retain, readonly, nonatomic) CBUUID *UUID;
@property(assign, readonly, nonatomic) CBAttributePermissions permissions;
@property(assign, readonly, nonatomic) CBCharacteristicProperties properties;
@property(retain, readonly, nonatomic) NSData *data;
@property(retain, readonly, nonatomic) GGDescriptors *descriptors;

- (instancetype)initWithUUIDString:(NSString *)uuidString
                        properties:(CBCharacteristicProperties)properties
                              data:(NSData *_Nullable)data
                       permissions:(CBAttributePermissions)permissions
                       strsForDescriptor:(NSString *_Nullable)descriptor;

+ (GGPeripheralCharacteristic *)setWithUUIDString:(NSString *)uuidString
                                                     properties:(CBCharacteristicProperties)properties
                                                           data:(NSData *_Nullable)data
                                                    permissions:(CBAttributePermissions)permissions
                                      strsForDescriptor:(NSString *_Nullable)descriptor;

@end

@interface GGPeripheralOptions : GGBLEOptions
@property (nonatomic, copy) NSString *localName;
@property (nonatomic, strong) NSDictionary <NSString *,NSArray<GGPeripheralCharacteristic*> *> *configOptions;
@property (nonatomic, strong, readonly) GGMultiServices *services;
@property (nonatomic, strong, readonly) NSArray<CBMutableCharacteristic *> *characteristics;
- (CBMutableCharacteristic *)getCharacteristicWithUUIDString:(NSString *)uuidString;
@end

NS_ASSUME_NONNULL_END
