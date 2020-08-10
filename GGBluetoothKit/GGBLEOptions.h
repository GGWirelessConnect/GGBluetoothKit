//
//  GGBLEOptions.h
//  GGBluetoothDemo
//
//  Created by marsung on 2020/7/28.
//  Copyright © 2020 marsung. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CBService,CBMutableService,CBCharacteristic,CBUUID,CBDescriptor;

typedef NSArray<CBUUID*> GGUUIDs;
typedef NSArray<CBService*> GGServices;
typedef NSArray<CBMutableService*> GGMultiServices;
typedef NSArray<CBCharacteristic*> GGCharacteristics;
typedef NSArray<CBDescriptor *> GGDescriptors;
typedef NSArray<NSString *> GGStringsForDescriptors;
@interface GGBLEOptions : NSObject

@end

NS_ASSUME_NONNULL_END
