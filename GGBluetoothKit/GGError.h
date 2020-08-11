//
//  GGError.h
//  GGWirelessConnect
//
//  Created by marsung on 18/6/13.
//  Copyright © 2018 com.marsung. All rights reserved.ed.
//

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
