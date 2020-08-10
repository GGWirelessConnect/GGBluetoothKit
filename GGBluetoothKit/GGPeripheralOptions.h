//
//  GGPeripheralOptions.h
//  GGBluetoothDemo
//
//  Created by marsung on 2020/7/28.
//  Copyright © 2020 marsung. All rights reserved.
//

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
