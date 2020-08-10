//
//  GGBluetooth.m
//  GGBluetooth
//
//  Created by marsung on 18/6/13.
//  Copyright © 2018 com.marsung. All rights reserved.
//


#import "GGBluetooth.h"
#import "GGError.h"
@interface GGBluetooth()
@property (nonatomic, strong) GGBLECentralManager *ggCentralManager;
@property (nonatomic, strong) GGBLEPeripheralManager *ggPeripheralManager;
@property (nonatomic, strong) GGCentralOptions *ggOptions;
@end

@implementation GGBluetooth
{
    BOOL _scanEnable;
    BOOL _connectEnable;
    BOOL _discoverServicesEnable;
    BOOL _discoverCharacteristicsEnable;
    BOOL _readValueEnable;
    BOOL _notifyValueEnable;
    BOOL _discoverDesciptorsEnable;
    BOOL _readValuesForDesciptorsEnable;
}
static GGBluetooth *manager = nil;

+ (GGBluetooth *)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GGBluetooth alloc] initPrivate];
    });
    return manager;
}

- (instancetype)init{
    NSException *alertE = [NSException exceptionWithName:@"\nGGBluetooth init crash"
                                                  reason:@"GGBluetooth is a singleton, you should use with `[GGBluetooth manager].xx\n\n`."
                                                userInfo:nil];
    @throw alertE;
    return nil;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}

- (id)copyWithZone:(NSZone *)zone{
    return manager;
}

- (instancetype) initPrivate {
    if (self == [super init]) {
        self.ggCentralManager = [[GGBLECentralManager alloc] init];
        self.ggPeripheralManager = [[GGBLEPeripheralManager alloc] init];
    }
    return self;
}


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
- (GGBluetooth *(^)(BOOL onMainThread,GGCentralOptions *options,void(^)(BOOL success,CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error)))automator
{
    return ^GGBluetooth *(BOOL onMainThread,GGCentralOptions *options,void(^callback)(BOOL success,CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error)){
        [self.ggCentralManager openServiceWithOnMainThread:onMainThread bleOptions:options complete:^(CBCentralManager *central,NSString *logMsg) {
            if (central.state == GGBLEPoweredOnState) {
                self.ggCentralManager.scanEnable = YES;
                self.ggCentralManager.connectEnable = YES;
                self.ggCentralManager.discoverServicesEnable = YES;
                self.ggCentralManager.discoverCharacteristicsEnable = YES;
                self.ggCentralManager.readValueEnable = YES;
                self.ggCentralManager.notifyValueEnable = YES;
                
                [self.ggCentralManager scanPeripherals];
                
                [self.ggCentralManager setDidUpdateValueForCharacteristicNotification:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
                    BOOL success = error == nil ? YES:NO;
                    callback(success,peripheral,characteristic,error);
                }];

            }else{
                self.ggCentralManager.scanEnable = NO;
                
                GGError *error = [[GGError alloc] initWithBLEErrorCode:GGEC_CBManagerState
                userInfo: @{
                            GGErroUserInfoDescriptionKey:@"CBManagerState",
                            GGErroUserInfoReasonKey:logMsg,
                            GGErroUserInfoSuggestionKey:@" please check device bluetooth state!",
                }];
                callback(NO,nil,nil,error);
            }
        }];
        return manager;
    };
}

#pragma mark- Function syntactic sugar

- (GGBluetooth *(^)(BOOL onMainThread,GGCentralOptions *options))setup {
    @GGWeakObjc(self);
    return ^GGBluetooth *(BOOL onMainThread,GGCentralOptions *options){
        @GGStrongObjc(self);
        self.ggOptions = options;

        [self.ggCentralManager openServiceWithOnMainThread:onMainThread bleOptions:options complete:^(CBCentralManager *central,NSString *logMsg) {
            if (central.state == GGBLEPoweredOnState) {
                if (manager->_scanEnable && self.ggCentralManager.scanEnable) {
                    [self.ggCentralManager scanPeripherals];
                }
            }
        }];
        return manager;
    };
}

- (GGBluetooth *(^)(void))scan {
    return ^GGBluetooth *(void){
        manager ->_scanEnable = YES;
        return manager;
    };
}

- (GGBluetooth *(^)(void))connect {
    return ^GGBluetooth *(void){
        manager ->_connectEnable = YES;
        return manager;
    };
}

- (GGBluetooth *(^)(void))discoverServices {
    return ^GGBluetooth *(void){
        manager ->_discoverServicesEnable = YES;
        return manager;
    };
}

- (GGBluetooth *(^)(void))discoverCharacteristics {
    return ^GGBluetooth *(void){
        manager ->_discoverCharacteristicsEnable = YES;
        return manager;
    };
}

- (GGBluetooth *(^)(void))readValue {
    return ^GGBluetooth *(void){
        manager ->_readValueEnable = YES;
        return manager;
    };
}

- (GGBluetooth *(^)(void))notifyValue {
    return ^GGBluetooth *(void){
        manager ->_notifyValueEnable = YES;
        return manager;
    };
}

- (GGBluetooth *(^)(void))discoverDesciptors {
    return ^GGBluetooth *(void){
        manager ->_discoverDesciptorsEnable = YES;
        return manager;
    };
}

- (GGBluetooth *(^)(void))readValueForDescriptors {
    return ^GGBluetooth *(void){
        manager ->_readValuesForDesciptorsEnable = YES;
        return manager;
    };
}

- (GGBluetooth *(^)(void))commit {
    @GGWeakObjc(self);
    return ^GGBluetooth *(void){
        @GGStrongObjc(self);
        [self __resetGGCentralManagerState];
        [self __verifyGGBLECentralManangerStates];
        [self __setGGBLECentralManagerStates];
        
        return manager;
    };
}

- (GGBluetooth *(^)(void(^)(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error)))commitWithDidUpdateValueForCharacteristicCallback {
     @GGWeakObjc(self);
     return ^GGBluetooth *(void(^callback)(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error)){
         @GGStrongObjc(self);
         [self __verifyGGBLECentralManangerStates];
         [self __setGGBLECentralManagerStates];
         
         [self.ggCentralManager setDidUpdateValueForCharacteristicNotification:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
             callback(peripheral,characteristic,error);
         }];
         
         return manager;
     };
}


#pragma mark- Characteristic operation

/// Read value
/// @param peripheral <#peripheral description#>
/// @param characteristic <#characteristic description#>
- (void)setReadValueWithPeripheral:(CBPeripheral *)peripheral forCharacteristic:(CBCharacteristic *)characteristic {
    [self.ggCentralManager readValueWithPeripheral:peripheral forCharacteristic:characteristic];
}

/// Notify valu
/// @param peripheral <#peripheral description#>
/// @param isNotify <#isNotify description#>
/// @param characteristic <#characteristic description#>
- (void)setNotifyValueWithPeripheral:(CBPeripheral *)peripheral isNotify:(BOOL)isNotify forCharacteristic:(CBCharacteristic *)characteristic {
    [self.ggCentralManager notifyValueWithPeripheral:peripheral isNotify:isNotify forCharacteristic:characteristic];
}

/// Write data
/// @param data <#data description#>
/// @param peripheral <#peripheral description#>
/// @param characteristic <#characteristic description#>
- (void)setWriteData:(NSData *)data forPeripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic {
    [self.ggCentralManager writeData:data forPeripheral:peripheral characteristic:characteristic callback:^(BOOL success, NSError * _Nonnull error) {
        if (error) return;
    }];
}

#pragma mark- Characteristic operation with callback

- (void)setReadValueWithPeripheral:(CBPeripheral *)peripheral forCharacteristic:(CBCharacteristic *)characteristic complete:(void(^)(BOOL success,CBCharacteristic *c,NSError *error))complete {
    
    [self.ggCentralManager readValueWithPeripheral:peripheral forCharacteristic:characteristic];

    // callback for write data
    [self.ggCentralManager setDidUpdateValueForCharacteristicNotification:^(CBPeripheral * _Nonnull peripheralForCallback, CBCharacteristic * _Nonnull characteristicForCallback, NSError * _Nullable error) {
        if ([peripheralForCallback.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            if ([characteristicForCallback.UUID.UUIDString isEqualToString:characteristic.UUID.UUIDString]) {
                complete(YES,characteristicForCallback,nil);
            }
        }
    }];
}

- (void)setNotifyValueWithPeripheral:(CBPeripheral *)peripheral isNotify:(BOOL)isNotify forCharacteristic:(CBCharacteristic *)characteristic complete:(void(^)(BOOL success,CBCharacteristic *c,NSError *error))complete {
    
    [self.ggCentralManager notifyValueWithPeripheral:peripheral isNotify:isNotify forCharacteristic:characteristic];
    // callback for write data
    [self.ggCentralManager setDidUpdateValueForCharacteristicNotification:^(CBPeripheral * _Nonnull peripheralForCallback, CBCharacteristic * _Nonnull characteristicForCallback, NSError * _Nullable error) {
        if ([peripheralForCallback.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            if ([characteristicForCallback.UUID.UUIDString isEqualToString:characteristic.UUID.UUIDString]) {
                complete(YES,characteristicForCallback,nil);
            }
        }
    }];
}


/// Write data with callback
/// @param data <#data description#>
/// @param peripheral <#peripheral description#>
/// @param characteristic <#characteristic description#>
/// @param complete <#complete description#>
- (void)setWriteData:(NSData *)data forPeripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic complete:(void(^)(BOOL success,CBCharacteristic *c,NSError *error))complete
{
    @GGWeakObjc(self);
    if(complete){
        @GGStrongObjc(self);
        [self.ggCentralManager writeData:data forPeripheral:peripheral characteristic:characteristic callback:^(BOOL success, NSError * _Nonnull error) {
            if (error) return;
        }];
        // callback for write data
        [self.ggCentralManager setDidUpdateValueForCharacteristicNotification:^(CBPeripheral * _Nonnull peripheralForCallback, CBCharacteristic * _Nonnull characteristicForCallback, NSError * _Nullable error) {
            if ([peripheralForCallback.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
                if ([characteristicForCallback.UUID.UUIDString isEqualToString:characteristic.UUID.UUIDString]) {
                    complete(YES,characteristicForCallback,nil);
                }
            }
        }];
    }
}


#pragma mark-  Manual mode

- (GGBluetooth *(^)(BOOL onMainThread,void(^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary<NSString *, id> *advertisementData,NSNumber *RSSI)))setupAndScan {
    @GGWeakObjc(self);
    return ^GGBluetooth *(BOOL onMainThread,void(^callback)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary<NSString *, id> *advertisementData,NSNumber *RSSI)){
        @GGStrongObjc(self);
        [self.ggCentralManager openServiceWithOnMainThread:onMainThread bleOptions:nil complete:^(CBCentralManager *central,NSString *logMsg) {
            if (central.state == GGBLEPoweredOnState) {
                self.ggCentralManager.scanEnable = YES;
                [self.ggCentralManager scanPeripherals];
                [self setScanPeripheralsCallback:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary<NSString *,id> *advertisementData, NSNumber *RSSI) {
                    callback(central,peripheral,advertisementData,RSSI);
                }];
            }
        }];
        return manager;
    };
}

/**
 * Stop scan peripherals
 */
- (GGBluetooth *(^)(void))doStopScan {
    @GGWeakObjc(self);
    return ^GGBluetooth *(void){
        @GGStrongObjc(self);
        [self.ggCentralManager stopScanPeripheral];
        return manager;
    };
}

/**
 * connect
 */
- (GGBluetooth *(^)(CBPeripheral *peripheral,void(^)(CBCentralManager *central,BOOL success,NSError *error)))doConnect {
    @GGWeakObjc(self);
    return ^GGBluetooth *(CBPeripheral *peripheral, void(^callback)(CBCentralManager *central,BOOL success,NSError *error)){
        if (callback) {
            @GGStrongObjc(self);
            [self.ggCentralManager connectPeripheral:peripheral complete:^(CBCentralManager *central, CBPeripheral *peripheral, BOOL success, NSError *error) {
                callback(central,success,error);
            }];
        }
        return manager;
    };
}


///disconnect
- (GGBluetooth *(^)(CBPeripheral *peripheral, void(^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error)))doDisconnect {
    @GGWeakObjc(self);
    return ^GGBluetooth *(CBPeripheral *peripheral,void (^callback)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error)){
        if (callback) {
            @GGStrongObjc(self);
            [self.ggCentralManager disConnectPeripherial:peripheral];
            [self.ggCentralManager setDisconnectNotification:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
                callback(central,peripheral,error);
            }];
        }
        return manager;
    };
}

/// discoverServices
- (GGBluetooth *(^)(CBPeripheral *peripheral,GGUUIDs *serviceUUIDs,void(^)(CBPeripheral *peripheral,GGServices *services,NSError *error)))doDiscoverServices {
    @GGWeakObjc(self);
    return ^GGBluetooth *(CBPeripheral *peripheral,GGUUIDs *serviceUUIDs,void(^callback)(CBPeripheral *peripheral,GGServices *services,NSError *error)){
        if (callback) {
            @GGStrongObjc(self);
            [self.ggCentralManager discoverServicesWithPeripheral:peripheral serviceUUIDs:serviceUUIDs];
            [self.ggCentralManager setDiscoverServicesNotification:^(CBPeripheral *peripheral, GGServices *services, NSError *error) {
                callback(peripheral,services,error);
            }];
        }
        return manager;
    };
}

/// discoverCharateristics
- (GGBluetooth *(^)(CBPeripheral *peripheral,GGUUIDs *characteristicUUIDs,CBService *service, void(^)(CBPeripheral *peripheral,GGCharacteristics *characteristics,NSError *error)))doDiscoverCharateristics {
    @GGWeakObjc(self);
    return ^GGBluetooth *(CBPeripheral *peripheral,GGUUIDs *characteristicUUIDs,CBService *service,void(^callback)(CBPeripheral *peripheral,GGCharacteristics *characteristics,NSError *error)){
        if (callback) {
            @GGStrongObjc(self);
            [self.ggCentralManager discoverCharacteristicsWithPeripheral:peripheral characteristicsUUIDs:characteristicUUIDs forService:service];
            [self.ggCentralManager setDiscoverCharacteristicsNotificaiton:^(CBPeripheral *peripheral, GGCharacteristics *characteristics, NSError *error) {
                callback(peripheral,characteristics,error);
            }];
        }
        return manager;
    };
}

/// didUpdateValueForCharacteritic [default mode]
- (GGBluetooth *(^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,void(^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error)))doDidUpdateValueForCharacteritic {
    @GGWeakObjc(self);
    return ^GGBluetooth *(CBPeripheral *peripheral,CBCharacteristic *characteristic,void(^callback)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error)){
        if (callback) {
            @GGStrongObjc(self);
            if ((characteristic.properties & CBCharacteristicPropertyRead) != 0) {
                [self.ggCentralManager readValueWithPeripheral:peripheral forCharacteristic:characteristic];
                [self.ggCentralManager setDidUpdateValueForCharacteristicNotification:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
                    callback(peripheral,characteristic,error);
                }];
            }
            else if ((characteristic.properties & CBCharacteristicPropertyNotify) != 0) {
                [self.ggCentralManager notifyValueWithPeripheral:peripheral isNotify:YES forCharacteristic:characteristic];
                [self.ggCentralManager setDidUpdateValueForCharacteristicNotification:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
                    callback(peripheral,characteristic,error);
                }];
            }else{
                GGError *error = [[GGError alloc] initWithBLEErrorCode:GGEC_InvalidCharacteristicPropertyTypeForDefaultMode
                userInfo: @{
                            GGErroUserInfoDescriptionKey:@"InvalidCharacteristicPropertyTypeForDefaultMode",
                            GGErroUserInfoReasonKey:[NSString stringWithFormat:@"invalid characteristic type, %lu.",characteristic.properties],
                            GGErroUserInfoSuggestionKey:@"please use `CBCharacteristicPropertyRead` or `CBCharacteristicPropertyNotify` instead.",
                }];
                GGLog(@"%@",error);
            }
        }
        return manager;
    };
}



#pragma mark- callback

// callback: searched peripherals
- (void)setScanPeripheralsCallback:(void(^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary<NSString *, id> *advertisementData,NSNumber *RSSI))callback {
    if (callback) {
        [self.ggCentralManager setScanNofication:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary<NSString *,id> *advertisementData, NSNumber *RSSI) {
            callback(central,peripheral,advertisementData,RSSI);
        }];
    }
}
// callback: connected peripheral
- (void)setConnectPeripheralCallback:(void(^)(CBCentralManager * _Nonnull central, CBPeripheral * _Nonnull peripheral, BOOL success, NSError * _Nullable error))callback {
    if (callback) {
        [self.ggCentralManager setConnectNotification:^(CBCentralManager * _Nonnull central, CBPeripheral * _Nonnull peripheral, BOOL success, NSError * _Nullable error) {
            callback(central,peripheral,success,error);
        }];
    }
}

/// callback: disconnnect peripheral
/// @param callback callback(central,peripheral,error)
- (void)setDisconnectPeripheralCallback:(void(^)(CBCentralManager * _Nonnull central, CBPeripheral * _Nonnull peripheral, NSError * _Nullable error))callback {
    if(callback) {
        [self.ggCentralManager setDisconnectNotification:^(CBCentralManager * _Nonnull central, CBPeripheral * _Nonnull peripheral, NSError * _Nullable error) {
            callback(central,peripheral,error);
        }];
    }
}

// calllback: discover services
- (void)setDiscoverServicesCallback:(void(^)(CBPeripheral * _Nonnull peripheral, GGServices * _Nonnull services, NSError * _Nullable error))callback {
    [self.ggCentralManager setDiscoverServicesNotification:^(CBPeripheral * _Nonnull peripheral, GGServices * _Nonnull services, NSError * _Nullable error) {
        callback(peripheral,services,error);
    }];
}
// callback: discover characteriscs
- (void)setDiscoverCharacteristicsCallback:(void(^)(CBPeripheral * _Nonnull peripheral, GGCharacteristics * _Nonnull characteristics, NSError * _Nullable error))callback {
    [self.ggCentralManager setDiscoverCharacteristicsNotificaiton:^(CBPeripheral * _Nonnull peripheral, GGCharacteristics * _Nonnull characteristics, NSError * _Nullable error) {
        callback(peripheral,characteristics,error);
    }];
}


// callback: update value for characteristic
- (void)setUpdateValueForCharacteristicCallback:(void(^)(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error))callback {
    if (callback) {
        [self.ggCentralManager setDidUpdateValueForCharacteristicNotification:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
            callback(peripheral,characteristic,error);
        }];
    }
}

#pragma mark- Tool method
- (NSArray *)GG_getAllConnectedPeripherals {
   return [self.ggCentralManager getPeripheralsForDidConnected];
}

- (void)GG_disconnectAllPeripherals {
    [self.ggCentralManager disconnectAllPeripherals];
}


#pragma mark- private methods
- (void)__resetGGCentralManagerState {
    self.ggCentralManager.scanEnable = NO;
    self.ggCentralManager.connectEnable = NO;
    self.ggCentralManager.discoverServicesEnable = NO;
    self.ggCentralManager.discoverCharacteristicsEnable = NO;
    self.ggCentralManager.readValueEnable = NO;
    self.ggCentralManager.notifyValueEnable = NO;
}

- (void)__setGGBLECentralManagerStates
{
    if (manager ->_scanEnable) {
        self.ggCentralManager.scanEnable = YES;
    }
    if (manager ->_connectEnable) {
        self.ggCentralManager.connectEnable = YES;
        
    }
    if (manager->_discoverServicesEnable) {
        self.ggCentralManager.discoverServicesEnable = YES;
    }
    if (manager->_discoverCharacteristicsEnable) {
        self.ggCentralManager.discoverCharacteristicsEnable = YES;
    }
    if (manager->_readValueEnable) {
        self.ggCentralManager.readValueEnable = YES;
    }
    
    if (manager ->_notifyValueEnable) {
        self.ggCentralManager.notifyValueEnable = YES;
    }
    
    if (manager ->_discoverDesciptorsEnable) {
        self.ggCentralManager.onceReadValueForDescriptorsEnable = YES;
    }

    if (manager ->_discoverCharacteristicsEnable) {
        self.ggCentralManager.discoverDescriptorsCharacteristicEnable = YES;
    }
    if (manager ->_readValuesForDesciptorsEnable) {
        self.ggCentralManager.readValueForDescriptorsEnable = YES;
    }
}

- (void)__verifyGGBLECentralManangerStates
{
    NSMutableArray *expArray = [NSMutableArray array];
    if (manager ->_readValuesForDesciptorsEnable && !manager ->_discoverDesciptorsEnable) {
        NSString *reason = @"`discoverDesciptors()` must be excute before `readValueForDescriptors()`";
        [expArray addObject:reason];
    }
    
    if (manager ->_discoverDesciptorsEnable && !manager ->_discoverServicesEnable) {
        NSString *reason = @"`discoverServices()` must be excute before `discoverDesciptors()`";
        [expArray addObject:reason];
    }
    
    if ((manager->_readValueEnable || manager ->_notifyValueEnable) && !manager ->_discoverCharacteristicsEnable) {
        NSString *reason = @"`discoverCharacteristics()` must be excute before `readValue()` or `notifyValue()`";
        [expArray addObject:reason];
    }
    if (manager->_discoverCharacteristicsEnable && !manager->_discoverServicesEnable) {
        NSString *reason = @"`discoverServices()` must be excute before `discoverCharacteristics()`";
        [expArray addObject:reason];
    }
    if (manager->_discoverServicesEnable && !manager ->_connectEnable) {
        NSString *reason = @"`connect()` must be excute before `discoverServices()`";
        [expArray addObject:reason];
    }
    
    if (manager ->_connectEnable && !manager->_scanEnable) {
        NSString *reason = @"`scan()` must be excute before `connect()`";
        [expArray addObject:reason];
    }
    
    if (expArray.lastObject) {
        @throw [NSException exceptionWithName:@"GGBluetooth error for using function syntactic sugar" reason:expArray.lastObject userInfo:nil];
    }
}


#pragma mark *****************************************************  Peripheral Mode   *****************************************************


- (GGBluetooth *(^)(BOOL onMainTread, GGPeripheralOptions *peripheralOptions))openPeripheralService {
    return ^GGBluetooth *(BOOL onMainTread, GGPeripheralOptions *peripheralOptions) {
        self.ggPeripheralManager.openService(onMainTread,peripheralOptions);
        return self;
    };
}

- (GGBluetooth *(^)(void))startAdvertising {
    return ^GGBluetooth *{
        self.ggPeripheralManager.startAdvertising();
        return self;
    };
}

- (GGBluetooth *(^)(void))stopAdvertising {
    return ^GGBluetooth *{
        self.ggPeripheralManager.stopAdvertising();
        return self;
    };
}

- (GGBluetooth *(^)(NSData *data,NSString *uuidString))sendData {
    return ^GGBluetooth *(NSData *data,NSString *uuidString){
        self.ggPeripheralManager.sendDataWithRespond(data,uuidString,^(CBATTRequest *respond,NSError *error){

        });
        return self;
    };
}

- (GGBluetooth *(^)(NSData *data,NSString *characteristicUUIDString,void(^)(CBATTRequest *respond,NSError *error)))sendDataWithRespond {
    
    return ^GGBluetooth *(NSData *data,NSString *characteristicUUIDString,void(^block)(CBATTRequest *respond,NSError *error)) {
        self.ggPeripheralManager.sendDataWithRespond(data,characteristicUUIDString,^(CBATTRequest *respond,NSError *error){
            block(respond,error);
        });
        return self;
    };
}


#pragma mark- notification
- (void)setDidStartAdvertisingCallback:(GGPeripheralMgrDidStartAdvertising)callback {
    if (callback) {
        [self.ggPeripheralManager setDidStartAdvertisingCallback:^(CBPeripheralManager *pMgr, NSError *error) {
            callback(pMgr,error);
        }];
    }
}
- (void)setDidAddServiceCallback:(GGPeripheralMgrDidAddService)callback {
    if (callback) {
        [self.ggPeripheralManager setDidAddServiceCallback:^(CBPeripheralManager *pMgr, CBService *service, NSError *error) {
            callback(pMgr,service,error);
        }];
    }
}
- (void)setDidSubscribeToCharacteristicCallback:(GGPeripheralMgrDidSubscribe)callback {
    if (callback) {
        [self.ggPeripheralManager setDidSubscribeToCharacteristicCallback:^(CBPeripheralManager *pMgr, CBCentral *central, CBCharacteristic *characteristic) {
            callback(pMgr,central,characteristic);
        }];
    }
}
- (void)setDidUnsubscribeFromCharacteristicCallback:(GGPeripheralMgrDidUnsubscribe)callback {
    if (callback) {
        [self.ggPeripheralManager setDidUnsubscribeFromCharacteristicCallback:^(CBPeripheralManager *pMgr, CBCentral *central, CBCharacteristic *characteristic) {
            callback(pMgr,central,characteristic);
        }];
    }
}
- (void)setDidReceiveReadRequestCallback:(GGPeripheralMgrDidReceiveReadRequest)callback {
    if (callback) {
        [self.ggPeripheralManager setDidReceiveReadRequestCallback:^(CBPeripheralManager *pMgr, CBATTRequest *request) {
            callback(pMgr,request);
        }];
    }
}
- (void)setDidReceiveWriteRequests:(GGPeripheralMgrDidReceiveWriteRequests)callback {
    if (callback) {
        [self.ggPeripheralManager setDidReceiveWriteRequests:^(CBPeripheralManager *pMgr, NSArray<CBATTRequest *> *requests) {
            callback(pMgr,requests);
        }];
    }
}
- (void)setIsReadyToUpdateSubscribers:(GGPeripheralMgrIsReadyToUpdateSubscribers)callback {
    if (callback) {
        [self.ggPeripheralManager setIsReadyToUpdateSubscribers:^(CBPeripheralManager *pMgr) {
            callback(pMgr);
        }];
    }
}
@end
