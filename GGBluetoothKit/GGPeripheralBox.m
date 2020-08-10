//
//  GGPeripheralBox.m
//  GGBluetooth
//
//  Created by marsung on 18/6/13.
//  Copyright © 2018 com.marsung. All rights reserved.
//

#import "GGPeripheralBox.h"

@implementation GGPeripheralBox

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral adData:(NSDictionary <NSString* ,id> *)adData rssi:(NSNumber *)rssi
{
    if (self == [super init]) {
        _peripheral = peripheral;
        _advertisementData = adData;
        _RSSI = rssi;
        
        if ([self __filterAdDataKeys:[adData allKeys] filterKey:@"kCBAdvDataLocalName"]) {
            _localName = adData[@"kCBAdvDataLocalName"];
        }
        if ([self __filterAdDataKeys:[adData allKeys] filterKey:@"kCBAdvDataManufacturerData"]) {
            _mac = [self __getMacAddressWithAdvertisementData:(NSData *)adData[@"kCBAdvDataManufacturerData"]];
        }
    }
    return self;
}

- (BOOL)__filterAdDataKeys:(NSArray *)keys filterKey:(NSString *)filterKey
{
    BOOL flag = NO;
    for (NSString *key in keys) {
        if ([key isEqualToString:filterKey]) {
            flag = YES;
        }
    }
    return flag;
}

- (NSString *)__getMacAddressWithAdvertisementData:(NSData *)advertisementData
{
    if (advertisementData.length != 8) {
        return @"00:00:00:00:00:00";
    }
    NSData *macData = [advertisementData subdataWithRange:NSMakeRange(2, 6)];
    Byte *bytes = (Byte *)macData.bytes;
    NSMutableString *macID = [NSMutableString string];
    for (int i = 0; i < macData.length; i ++) {
        Byte byte = bytes[i] & 0xFF;
        if ((byte & 0xF0)>>4 == 0) {
            [macID appendString:@"0"];
        }
        [macID appendFormat:@"%2X",byte];
        if (i != macData.length-1) {
            [macID appendString:@":"];
        }
    }
    return [macID stringByReplacingOccurrencesOfString:@" " withString:@""];
}
- (NSString *)description{
    return [NSString stringWithFormat:@"<%@:%p> peripheral:%@ name:%@ mac:%@  rssi:%@",[self class],self,_peripheral,_localName,_mac,_RSSI];
}
@end
