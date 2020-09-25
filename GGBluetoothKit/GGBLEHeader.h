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
