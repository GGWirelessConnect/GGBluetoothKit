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
