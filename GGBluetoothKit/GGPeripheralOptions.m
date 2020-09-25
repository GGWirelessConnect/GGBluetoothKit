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

#import "GGPeripheralOptions.h"
#import <CoreBluetooth/CBUUID.h>
#import <CoreBluetooth/CBService.h>
#import <CoreBluetooth/CBDescriptor.h>
@implementation GGPeripheralCharacteristic

- (instancetype)initWithUUIDString:(NSString *)uuidString
                        properties:(CBCharacteristicProperties)properties
                              data:(NSData *)data
                       permissions:(CBAttributePermissions)permissions
                       strsForDescriptor:(NSString *_Nullable)strsForDescriptor {
    if (self == [super init]) {
        _properties = properties;
        _data = data;
        _permissions = permissions;
        
        if (uuidString) {
            _UUID = [CBUUID UUIDWithString:uuidString];
        }
        
        if (strsForDescriptor) {
            CBUUID *desUUID = [CBUUID UUIDWithString:CBUUIDCharacteristicUserDescriptionString];
            CBMutableDescriptor *descriptor = [[CBMutableDescriptor alloc]initWithType: desUUID value:strsForDescriptor];
            _descriptors = @[descriptor];
        }
    }
    return self;
}

+ (GGPeripheralCharacteristic *)setWithUUIDString:(NSString *)uuidString
                                       properties:(CBCharacteristicProperties)properties
                                             data:(NSData *)data
                                      permissions:(CBAttributePermissions)permissions
                                      strsForDescriptor:(NSString * _Nullable)descriptor{
    
    return [[GGPeripheralCharacteristic alloc] initWithUUIDString:uuidString
                                                       properties:properties
                                                             data:data
                                                      permissions:permissions
                                                      strsForDescriptor:descriptor];
}

@end

@implementation GGPeripheralOptions
- (instancetype)init {
    if (self == [super init]) {
        
    }
    return self;
}

@synthesize services = _services;
- (GGMultiServices *)services {
    NSDictionary *dic =_configOptions;
    NSArray *serviceKeys = [dic allKeys];
    
    NSMutableArray *services = [NSMutableArray array];
    for (NSString *serviceKey in serviceKeys) {
        CBMutableService *service = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:serviceKey] primary:YES];
        NSArray *ggCharacteristics = dic[serviceKey];
        
        NSMutableArray *chrArray = [NSMutableArray array];
        for (GGPeripheralCharacteristic *ggChr in ggCharacteristics) {
            CBMutableCharacteristic *c = [[CBMutableCharacteristic alloc] initWithType:ggChr.UUID properties:ggChr.properties value:ggChr.data permissions:ggChr.permissions];
            NSArray *desArray = @[ggChr.descriptors.lastObject];
            [c setDescriptors:desArray];
            [chrArray addObject:c];
        }
        service.characteristics = chrArray;
        [services addObject:service];
    }
    return (NSArray *)services;
}

- (CBMutableCharacteristic *)getCharacteristicWithUUIDString:(NSString *)uuidString {
    
    if (!uuidString) return nil;
    for (CBMutableService *service in self.services) {
        for (CBMutableCharacteristic *c in service.characteristics) {
            if ([c.UUID isEqual:[CBUUID UUIDWithString:uuidString]]) {
                return c;
            }
        }
    }
    return nil;
}
@end
