//
//  GGDataConversion.h
//  GGBluetooth
//
//  Created by marsung on 18/6/13.
//  Copyright © 2018 com.marsung. All rights reserved.
//
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
