//
//  GGPeripheralOptions.m
//  GGBluetoothDemo
//
//  Created by marsung on 2020/7/28.
//  Copyright © 2020 marsung. All rights reserved.
//

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
