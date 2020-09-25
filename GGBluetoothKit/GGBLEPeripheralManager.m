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

#import "GGBLEPeripheralManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "GGBLEHeader.h"
#import "GGPeripheralOptions.h"
#import "GGError.h"

DECLARE_ENUM(GG_PeripheralManagerState, GG_ENUM)
DECLARE_ENUM(GG_CBPeripheralManagerState, GG_PERIPHERAL_ENUM)

@interface GGBLEPeripheralManager ()<CBPeripheralManagerDelegate>
@property (nonatomic, strong) CBPeripheralManager *pMgr;
@property (nonatomic, strong) GGPeripheralOptions *ggOptions;

@property (nonatomic, strong) NSTimer *advertisTimer;
@property (nonatomic, strong) NSTimer *sendDataTimer;
@property (nonatomic, assign) BOOL poweredOn;
@property (nonatomic, assign) BOOL hasAddServices;
@property (nonatomic, assign) BOOL receiveEnable;
@property (nonatomic, assign,getter=hasAddServiceNumber) NSInteger servcieNumber;

@end

@implementation GGBLEPeripheralManager
{
    GGPeripheralMgrDidUpdateState               mgrUpdateStateHandle;
    GGPeripheralMgrRestoreState                 mgrRestoreStateHandle;
    GGPeripheralMgrDidStartAdvertising          mgrDidStartAdvertisingHandle;
    GGPeripheralMgrDidAddService                mgrDidAddServiceHandle;
    GGPeripheralMgrDidSubscribe                 mgrDidSubscribeHandle;
    GGPeripheralMgrDidUnsubscribe               mgrDidUnsubscribeHandle;
    GGPeripheralMgrDidReceiveReadRequest        mgrDidReceiveReadRequestHandle;
    GGPeripheralMgrDidReceiveWriteRequests      mgrDidReceiveWriteRequestsHandle;
    GGPeripheralMgrIsReadyToUpdateSubscribers   mgrIsReadyToUpdateSubscribers;
    GGPeripheralMgrRespond                      mgrRespondHandle;
}

- (GGBLEPeripheralManager *(^)(BOOL onMainTread, GGPeripheralOptions *peripheralOptions))openService {
    
    return ^GGBLEPeripheralManager *(BOOL onMainTread,GGPeripheralOptions *peripheralOptions){
        
        self.ggOptions = peripheralOptions;
        
    #if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_6_0
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:YES],CBPeripheralManagerOptionShowPowerAlertKey,
                                     @"GuoguoPeripheralhRestore",CBPeripheralManagerOptionRestoreIdentifierKey,
                                     nil];
    #else
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:YES],CBPeripheralManagerOptionShowPowerAlertKey,
                                     nil];
    #endif
        NSArray *backgroundModes = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIBackgroundModes"];
        __block dispatch_queue_t pMgrQueue;
        if (!onMainTread) {
           static dispatch_once_t onceToken;
           dispatch_once(&onceToken, ^{
               pMgrQueue = dispatch_queue_create("GuoguoPeripheralManagerQueue", DISPATCH_QUEUE_SERIAL);
           });
        }else{
           pMgrQueue = nil;
        }
        
        if ([backgroundModes containsObject:@"bluetooth-peripheral"]) {
            self.pMgr = [[CBPeripheralManager alloc] initWithDelegate:self queue:pMgrQueue options:options];
        }else {
            self.pMgr = [[CBPeripheralManager alloc] initWithDelegate:self queue:pMgrQueue options:nil];
        }
        return self;
    };
}

- (GGBLEPeripheralManager *(^)(void))startAdvertising {
    return ^GGBLEPeripheralManager *{
        NSMutableArray *sUUIDArray = [NSMutableArray array];
        for (CBMutableService *service in self.ggOptions.services) {
            [sUUIDArray addObject:service.UUID];
            if (self.poweredOn) {
                [self.pMgr addService:service];
            }
        }
        
        if (self.poweredOn && sUUIDArray.count >0 && self.hasAddServices) {
            if (!self.pMgr.isAdvertising) {
                [self.pMgr startAdvertising:@{CBAdvertisementDataServiceUUIDsKey : sUUIDArray,CBAdvertisementDataLocalNameKey:self.ggOptions.localName}];
            }
        }else {
            [self performSelector:@selector(__reStartAdvertisingWithDelay:) onThread:[NSThread currentThread] withObject:@(3.0) waitUntilDone:NO];
        }
        return self;
    };
}

- (GGBLEPeripheralManager *(^)(void))stopAdvertising {
    return ^GGBLEPeripheralManager *{
        if (self.poweredOn) {
            [self __initVar];
            [self.pMgr stopAdvertising];
        }
        return self;
    };
}

- (GGBLEPeripheralManager *(^)(NSData *data,NSString *characteristicUUIDString,void(^)(CBATTRequest*respond,NSError *error)))sendDataWithRespond {
    return ^GGBLEPeripheralManager *(NSData *data,NSString *characteristicUUIDString,void(^block)(CBATTRequest *respond,NSError *error)) {
        if (block) {
            self->mgrRespondHandle = block;
        }
        if (self.receiveEnable) {
            [self sendData:data forCharacteristicUUIDString:characteristicUUIDString];
        }else {
            NSArray *arg = @[data,characteristicUUIDString];
            NSThread *newThread = [[NSThread alloc] initWithTarget:self selector:@selector(__waitDataForSend:) object:arg];
            [newThread start];
        }
        return self;
    };
}

- (BOOL)sendData:(NSData *)data forCharacteristicUUIDString:(NSString *)characteristicUUIDString {
    CBMutableCharacteristic *c = [self.ggOptions getCharacteristicWithUUIDString:characteristicUUIDString];
    if (!c || !data) return NO;
    return [self.pMgr updateValue:data forCharacteristic:c onSubscribedCentrals:nil];
}


#pragma mark- Callback
- (void)setDidStartAdvertisingCallback:(GGPeripheralMgrDidStartAdvertising)callback {
    if (callback) {
        mgrDidStartAdvertisingHandle = callback;
    }
}

- (void)setDidAddServiceCallback:(GGPeripheralMgrDidAddService)callback {
    if (callback) {
        mgrDidAddServiceHandle = callback;
    }
}

- (void)setDidSubscribeToCharacteristicCallback:(GGPeripheralMgrDidSubscribe)callback {
    if (callback) {
        mgrDidSubscribeHandle = callback;
    }
}

- (void)setDidUnsubscribeFromCharacteristicCallback:(GGPeripheralMgrDidUnsubscribe)callback {
    if (callback) {
        mgrDidUnsubscribeHandle = callback;
    }
}

- (void)setDidReceiveReadRequestCallback:(GGPeripheralMgrDidReceiveReadRequest)callback {
    if (callback) {
        mgrDidReceiveReadRequestHandle = callback;
    }
}

- (void)setDidReceiveWriteRequests:(GGPeripheralMgrDidReceiveWriteRequests)callback {
    if (callback) {
        mgrDidReceiveWriteRequestsHandle = callback;
    }
}

- (void)setIsReadyToUpdateSubscribers:(GGPeripheralMgrIsReadyToUpdateSubscribers)callback {
    if (callback) {
        mgrIsReadyToUpdateSubscribers = callback;
    }
}


#pragma mark-CBPeripheralManagerDelegate

DEFINE_ENUM(GG_PeripheralManagerState, GG_ENUM)
DEFINE_ENUM(GG_CBPeripheralManagerState, GG_PERIPHERAL_ENUM)

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    NSString *logMsg = nil;
    
    if (GGAPIAvailable(10.0, 10.13)) {
        logMsg = NSStringFromGG_PeripheralManagerState((GG_PeripheralManagerState)peripheral.state);
        self.poweredOn = peripheral.state == CBManagerStatePoweredOn ? YES:NO;
    }else {
        logMsg = NSStringFromGG_CBPeripheralManagerState((GG_CBPeripheralManagerState)peripheral.state);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        self.poweredOn = peripheral.state == CBPeripheralManagerStatePoweredOn ? YES:NO;
#pragma clang diagnostic pop
    }

    GGLog(@"peripheral state: %@",logMsg);
    if (mgrUpdateStateHandle) {
        mgrUpdateStateHandle(peripheral,logMsg);
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral willRestoreState:(NSDictionary<NSString *, id> *)dict {
    GGLog(@"peripheral willRestoreState: %@",dict);
    if (mgrRestoreStateHandle) {
        mgrRestoreStateHandle(peripheral,dict);
    }
}



- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(nullable NSError *)error {
    GGLog(@"peripheral  didAddService ! error: %@",error);
    if (mgrDidAddServiceHandle) {
        mgrDidAddServiceHandle(peripheral,service,error);
    }
    if (!error) {
        self.servcieNumber ++;
    }
    if (self.hasAddServiceNumber == self.ggOptions.services.count) {
        self.hasAddServices = YES;
    }
}


- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(nullable NSError *)error {
    GGLog(@"peripheral  DidStartAdvertising ! error: %@",error);
    if (mgrDidStartAdvertisingHandle) {
        mgrDidStartAdvertisingHandle(peripheral,error);
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
    GGLog(@"peripheral  didSubscribeToCharacteristic : %@",characteristic);
    self.receiveEnable = YES;
    if (mgrDidSubscribeHandle) {
        mgrDidSubscribeHandle(peripheral,central,characteristic);
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic {
     GGLog(@"peripheral  didUnsubscribeFromCharacteristic : %@",characteristic);
    self.receiveEnable = NO;
    if (mgrDidUnsubscribeHandle) {
        mgrDidUnsubscribeHandle(peripheral,central,characteristic);
    }
}


- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {
    GGLog(@"peripheral  didReceiveReadRequest. characteristic:%@ value:%@",request.characteristic,request.value);
    if (mgrDidReceiveReadRequestHandle) {
        mgrDidReceiveReadRequestHandle(peripheral,request);
    }
    
    if (request.characteristic.properties & CBCharacteristicPropertyRead) {
        NSData *data = request.characteristic.value;
        [request setValue:data];
        [self.pMgr respondToRequest:request withResult:CBATTErrorSuccess];
        mgrRespondHandle(request,nil);
    }else{
        [self.pMgr respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
        GGError *error = [[GGError alloc] initWithBLEErrorCode:GGEC_PerpheralMgrRespondWriteNotPermitted userInfo:@{
            GGErroUserInfoDescriptionKey:@"GGEC_PerpheralMgrRespondWriteNotPermitted",
            GGErroUserInfoReasonKey:@"CBATTErrorWriteNotPermitted from:`peripheralManager:didReceiveReadRequest:`",
            GGErroUserInfoSuggestionKey:@"",
        }];
        mgrRespondHandle(request,error);
    }
}


- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray<CBATTRequest *> *)requests {
    GGLog(@"peripheral  didReceiveWriteRequests. requests:%@",requests);
    if (mgrDidReceiveWriteRequestsHandle) {
        mgrDidReceiveWriteRequestsHandle(peripheral,requests);
    }
    
    for (CBATTRequest *request in requests) {
        if (request.characteristic.properties & CBCharacteristicPropertyWrite) {
            CBMutableCharacteristic *c =(CBMutableCharacteristic *)request.characteristic;
            c.value = request.value;
            [self.pMgr respondToRequest:request withResult:CBATTErrorSuccess];
            mgrRespondHandle(request,nil);
        }else{
            [self.pMgr respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
            GGError *error = [[GGError alloc] initWithBLEErrorCode:GGEC_PerpheralMgrRespondWriteNotPermitted userInfo:@{
                GGErroUserInfoDescriptionKey:@"GGEC_PerpheralMgrRespondWriteNotPermitted",
                GGErroUserInfoReasonKey:@"CBATTErrorWriteNotPermitted from `peripheralManager:didReceiveWriteRequests:`",
                GGErroUserInfoSuggestionKey:@"",
            }];
            mgrRespondHandle(request,error);
        }
    }
}

- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral {
    if (mgrIsReadyToUpdateSubscribers) {
        mgrIsReadyToUpdateSubscribers(peripheral);
    }
}

- (void)setPoweredOn:(BOOL)poweredOn {
    _poweredOn = poweredOn;
    if (!poweredOn) {
        [self __initVar];
    }
}

- (void)__waitDataForSend:(NSArray *)arg {
    self.sendDataTimer = [NSTimer timerWithTimeInterval:0 target:self selector:@selector(__waitFinishedForSendData:) userInfo:arg repeats:NO];
    [self.sendDataTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:3.0]];
    [[NSRunLoop currentRunLoop] addTimer:self.sendDataTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] run];
}

- (void)__waitFinishedForSendData:(NSArray *)arg {
    NSData *data = arg[0];
    NSString *uuidString = arg[1];
    self.sendDataWithRespond(data,uuidString,^(CBATTRequest*respond,NSError *error){});
    [self.sendDataTimer invalidate];
    self.sendDataTimer = nil;
}

- (void)__reStartAdvertisingWithDelay:(id)secs {
    self.advertisTimer = [NSTimer timerWithTimeInterval:0 target:self selector:@selector(__reStartAdvertisingWithFinished) userInfo:nil repeats:NO];
    [self.advertisTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:((NSNumber*)secs).doubleValue]];
    [[NSRunLoop currentRunLoop] addTimer:self.advertisTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] run];
}

- (void)__reStartAdvertisingWithFinished {
    self.startAdvertising();
    [self.advertisTimer invalidate];
    self.advertisTimer = nil;
}

- (void)__initVar {
    self.hasAddServices = NO;
    self.receiveEnable = NO;
    self.servcieNumber = 0;
}
@end
