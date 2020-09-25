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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GGBLEErrorCode)
{
    GGEC_Unknown = 0,//default
    GGEC_CBManagerState,
    GGEC_PeripherlIsNil,
    /// GGBLEOptions config error 
    GGEC_InvalidOptionsConfiguration,
    /**
     *  Characteristic property type error
     * @seealso `doDidUpdateValueForCharacteritic()` from GGBluettoht.h
     */
    GGEC_InvalidCharacteristicPropertyTypeForDefaultMode,
    /**
     * Characteristic property write type error
     * @seealso  `- (void)writeData:forPeripheral:characteristic:callback:(void (^)(BOOL success,NSError *error))` from GGBLECentralManager.h
     */
    GGEC_InvalidCharacteristicPropertyWriteType,
    
    GGEC_PerpheralMgrRespondWriteNotPermitted
};

typedef NSString *GGErroUserInfoKey;
extern GGErroUserInfoKey const GGErroUserInfoDescriptionKey;
extern GGErroUserInfoKey const GGErroUserInfoReasonKey;
extern GGErroUserInfoKey const GGErroUserInfoSuggestionKey;

@interface GGError : NSError
- (instancetype)initWithBLEErrorCode:(GGBLEErrorCode)code userInfo:(nullable NSDictionary<NSErrorUserInfoKey, id> *)dict;
@end

NS_ASSUME_NONNULL_END
