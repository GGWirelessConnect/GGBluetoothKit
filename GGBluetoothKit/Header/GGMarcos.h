//
//  GGMarcos.h
//
//
//  Created by marsung on 16/1/16.
//  Copyright © 2016 com.marsung. All rights reserved.
//

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
