//
//  GGBLEPeripheralManager.h
//  GGBluetooth
//
//  Created by marsung on 18/6/13.
//  Copyright © 2018 com.marsung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGPeripheralOptions.h"


NS_ASSUME_NONNULL_BEGIN

@interface GGBLEPeripheralManager : NSObject
- (GGBLEPeripheralManager *(^)(BOOL onMainTread, GGPeripheralOptions *peripheralOptions))openService;
- (GGBLEPeripheralManager *(^)(void))startAdvertising;
- (GGBLEPeripheralManager *(^)(void))stopAdvertising;
- (GGBLEPeripheralManager *(^)(NSData *data,NSString *characteristicUUIDString,void(^)(CBATTRequest *respond,NSError *error)))sendDataWithRespond;

- (BOOL)sendData:(NSData *)data forCharacteristicUUIDString:(NSString *)characteristicUUIDString;


#pragma mark- notification
- (void)setDidStartAdvertisingCallback:(GGPeripheralMgrDidStartAdvertising)callback;
- (void)setDidAddServiceCallback:(GGPeripheralMgrDidAddService)callback;
- (void)setDidSubscribeToCharacteristicCallback:(GGPeripheralMgrDidSubscribe)callback;
- (void)setDidUnsubscribeFromCharacteristicCallback:(GGPeripheralMgrDidUnsubscribe)callback;
- (void)setDidReceiveReadRequestCallback:(GGPeripheralMgrDidReceiveReadRequest)callback;
- (void)setDidReceiveWriteRequests:(GGPeripheralMgrDidReceiveWriteRequests)callback;
- (void)setIsReadyToUpdateSubscribers:(GGPeripheralMgrIsReadyToUpdateSubscribers)callback;
@end

NS_ASSUME_NONNULL_END
