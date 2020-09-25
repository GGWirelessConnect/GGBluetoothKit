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

#ifndef GGMarcos_h
#define GGMarcos_h

// API Version
#define API_13_0 __IPHONE_13_0
#define API_12_0 __IPHONE_12_0
#define API_11_0 __IPHONE_11_0
#define API_10_3 __IPHONE_10_3
#define API_10_0 __IPHONE_10_0
#define API_9_0  __IPHONE_9_0
#define API_8_0  __IPHONE_8_0
#define API_7_0  __IPHONE_7_0


#define GGAPIAvailable(ios,macos) @available(iOS ios,macOS macos, *)

#define GGBLEPoweredOnState \
(GGAPIAvailable(10, 10.13)) ? (CBManagerStatePoweredOn):(CBCentralManagerStatePoweredOn)

#ifdef DEBUG
    #define GGLog(fmt, ...) NSLog((@"GGLog-> %s[row:%d] " fmt),__FUNCTION__,__LINE__,##__VA_ARGS__);
#else
   #define  GGLog(...)
#endif

#define GGWeakObjc(objc) autoreleasepool{} __weak typeof(&*objc) weak_##objc = objc
#define GGStrongObjc(objc) autoreleasepool{} __strong typeof(&*objc) objc = weak_##objc

#endif /* GGMarcos_h */
