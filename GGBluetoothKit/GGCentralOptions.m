//
//  GGCentralOptions.m
//  GGBluetooth
//
//  Created by marsung on 18/6/13.
//  Copyright © 2018 com.marsung. All rights reserved.
//
#import "GGCentralOptions.h"
#import <CoreBluetooth/CBCentralManager.h>
#import "GGError.h"
#import "GGMarcos.h"

BOOL __verifyUUID(NSString *uuidString) {
    NSString *regex = @"^[a-fA-F0-9]+$";
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex] evaluateWithObject:uuidString];
}
@implementation GGCentralCharacterUUID
- (GGCentralCharacterUUID *)initWithhUUIDString:(NSString *)uuidString type:(GGUUIDsType)type {
    if (self == [super init]) {
        if (!__verifyUUID(uuidString)) {
            @throw [NSException exceptionWithName:@"Error for invalid character uuid format" reason:[NSString stringWithFormat:@"[%@] is not hexString",uuidString] userInfo:nil];
        }
        _UUID = [CBUUID UUIDWithString:uuidString];
        _type = type;
    }
    return self;
}

+ (GGCentralCharacterUUID *)setWithUUIDString:(NSString *)uuidString type:(GGUUIDsType)type {
   return [[GGCentralCharacterUUID alloc] initWithhUUIDString:uuidString type:type];
}


@end

@implementation GGCentralOptions
- (instancetype)init{
    if (self == [super init]) {
        self.scanOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey: [NSNumber numberWithBool:NO]};
        self.connectOptions = @{CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]};
    }
    return self;
}


- (void)setConfigOptions:(NSDictionary<NSString *,NSArray<GGCentralCharacterUUID*>*> *)configOptions{
    _configOptions = configOptions;
    for (NSString *key in configOptions.allKeys) {
        if (!__verifyUUID(key)) {
            @throw [NSException exceptionWithName:@"Error for invalid service uuid format" reason:[NSString stringWithFormat:@"[%@] is not hexString",key] userInfo:nil];
        }
    }
    if ([self __configOptionsVerify]){
        NSMutableArray *serviceUUIDs = [NSMutableArray array];
        [configOptions enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSArray<GGCentralCharacterUUID *> * _Nonnull obj, BOOL * _Nonnull stop) {
            [serviceUUIDs addObject:[CBUUID UUIDWithString:key]];
        }];
        _servicesUUIDs = serviceUUIDs;
    }
}

- (nullable NSArray<CBUUID *> *)getCharacteristicsAllUUIDsWithServiceUUID:(NSString *)sUUID
{
    NSArray *characteriscUUIDs = _configOptions[sUUID];
    
    NSMutableArray *chrArray = [NSMutableArray array];
    for (GGCentralCharacterUUID *uuid in characteriscUUIDs) {
        [chrArray addObject:uuid.UUID];
    }
    return (NSArray <CBUUID*> *)chrArray;
}

- (nullable NSArray<CBUUID *> *)getCharacteristicsUUIDsWithServiceUUID:(NSString *)sUUID forUUIDsType:(GGUUIDsType)type
{
    NSArray *characteriscUUIDs = _configOptions[sUUID];
    NSMutableArray *chrArray = [NSMutableArray array];
    for (GGCentralCharacterUUID *uuid in characteriscUUIDs) {
        if (uuid.type ==GGUUIDsTypeReadAndNotify) {
            [chrArray addObject:uuid.UUID];
        }else if (uuid.type == GGUUIDsTypeRead){
            [chrArray addObject:uuid.UUID];
        }else if (uuid.type == GGUUIDsTypeNotify){
            [chrArray addObject:uuid.UUID];
        }
    }
    return (NSArray <CBUUID*> *)chrArray;
}

- (BOOL)__configOptionsVerify
{
    BOOL pass = YES;
    NSArray *valuesArray = [_configOptions allValues];
    for (GGCentralCharacterUUID *cUUID in valuesArray) {
        if (cUUID.type == GGUUIDsTypeUnkown) {
            pass = NO;
            @throw [NSException exceptionWithName:@"Invalid <configOptions> arguments GGUUIDsType name" reason:@"current GGUUIDsType is GGUUIDsTypeUnkown!" userInfo:nil];
        }
    }
    return pass;
}
@end
