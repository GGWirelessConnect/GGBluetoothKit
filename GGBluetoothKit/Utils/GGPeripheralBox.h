//
//  GGPeripheralBox.h
//  GGBluetooth
//
//  Created by marsung on 18/6/13.
//  Copyright © 2018 com.marsung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CBPeripheral.h>
NS_ASSUME_NONNULL_BEGIN

@interface GGPeripheralBox : NSObject
/// peripheral
@property (nonatomic, strong, readonly) CBPeripheral *peripheral;
/// advertisementData
@property (nonatomic, strong, readonly) NSDictionary<NSString *, id> *advertisementData;
/// RSSI
@property (nonatomic, strong, readonly) NSNumber *RSSI;
/// localName
@property (nonatomic, copy, readonly) NSString *localName;
/// mac adress
@property (nonatomic, copy, readonly) NSString *mac;

/// init method for custom
/// @param peripheral <#peripheral description#>
/// @param adData <#adData description#>
/// @param rssi <#rssi description#>
- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral adData:(NSDictionary <NSString* ,id> *)adData rssi:(NSNumber *)rssi;
@end

NS_ASSUME_NONNULL_END
