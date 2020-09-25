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
