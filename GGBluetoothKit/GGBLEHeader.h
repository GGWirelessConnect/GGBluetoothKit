//
//  GGBLEHeader.h
//  GGBluetooth
//
//  Created by marsung on 2020/7/28.
//  Copyright © 2020 marsung. All rights reserved.
//

#ifndef GGBLEHeader_h
#define GGBLEHeader_h

#import "GGMarcos.h"
#import "GGEnumMarcos.h"

#define GG_ENUM(GG) \
GG(GG_CBManagerStateUnknown, = 0) \
GG(GG_CBManagerStateResetting,) \
GG(GG_CBManagerStateUnsupported,) \
GG(GG_CBManagerStateUnauthorized,) \
GG(GG_CBManagerStatePoweredOff,) \
GG(GG_CBManagerStatePoweredOn,) \

#define GG_CENTRAL_ENUM(GG) \
GG(GG_CBCentralManagerStateUnknown, = GG_CBManagerStateUnknown)\
GG(GG_CBCentralManagerStateResetting,= GG_CBManagerStateResetting)\
GG(GG_CBCentralManagerStateUnsupported,= GG_CBManagerStateUnsupported)\
GG(GG_CBCentralManagerStateUnauthorized, = GG_CBManagerStateUnauthorized)\
GG(GG_CBCentralManagerStatePoweredOff, = GG_CBManagerStatePoweredOff)\
GG(GG_CBCentralManagerStatePoweredOn, = GG_CBManagerStatePoweredOn)\

#define GG_PERIPHERAL_ENUM(GG) \
GG(GG_CBPeripheralManagerStateUnknown, = GG_CBManagerStateUnknown)\
GG(GG_CBPeripheralManagerStateResetting,= GG_CBManagerStateResetting)\
GG(GG_CBPeripheralManagerStateUnsupported,= GG_CBManagerStateUnsupported)\
GG(GG_CBPeripheralManagerStateUnauthorized, = GG_CBManagerStateUnauthorized)\
GG(GG_CBPeripheralManagerStatePoweredOff, = GG_CBManagerStatePoweredOff)\
GG(GG_CBPeripheralManagerStatePoweredOn, = GG_CBManagerStatePoweredOn)\

#endif /* GGBLEHeader_h */
