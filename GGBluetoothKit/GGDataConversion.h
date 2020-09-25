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


/// Data covert
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,NumberType){
    OctalType,
    DecimalType,
    HexType
};

@interface GGDataConversion : NSObject
+ (NSData *)converStringToData:(NSString *)string encoding:(NSStringEncoding)encoding;
+ (NSString *)converDataToString:(NSData *)data encoding:(NSStringEncoding)encoding;
+ (NSData *)convertHexStringToData:(NSString *)string;
+ (NSString *)converHexDataToString:(NSData *)data;

/**
 Cover hex data to string

 @param data <#data description#>
 @param numberType <#numberType description#>
 @return <#return value description#>
 */
+ (NSString *)converHexDataToString:(NSData *)data numberType:(NumberType)numberType;

/// Cover decimal data to decimal string
+ (NSData *)convertStringToData:(NSString *)string;

/**
 Cover short array to data
 
 @param shortArray NSArray <NSNumber *> *shortArray
 @return return value description
 */
+ (NSData *) convertShortArrayToData:(NSArray <NSNumber *>*)shortArray;
/**
 Cover data to short array
 
 @param data data description
 @return return value description
 */
+ (NSArray <NSNumber *>*) convertDataToShortArray:(NSData *)data;

/**
 Cover float array to data
 
 @param floatArray NSArray <NSNumber *> *floatArray NSNumber为float类型
 @return return value description
 */
+ (NSData *) convertFloatArrayToData:(NSArray <NSNumber *>*)floatArray;

/**
 Cover data to float array
 
 @param data <#data description#>
 @return <#return value description#>
 */
+ (NSArray <NSNumber *>*) convertDataToFloatArray:(NSData *)data;
@end
