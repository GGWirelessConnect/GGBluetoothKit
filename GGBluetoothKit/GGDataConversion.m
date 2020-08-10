//
//  GGDataConversion.m
//  GGBluetooth
//
//  Created by marsung on 18/6/13.
//  Copyright © 2018 com.marsung. All rights reserved.
//

#import "GGDataConversion.h"

NSData* convertShortArrayToData(NSArray<NSNumber *> *shortArray)
{
    unsigned char byteSize = 2;
    long count = shortArray.count;
    long byteLength = byteSize*count;
    unsigned char charArray[byteLength];
    for (NSInteger i = 0; i < count; i++) {
        short value = ((NSNumber *)shortArray[i]).shortValue;
        unsigned char *pValue = (unsigned char*)&value;
        for (NSInteger j = 0; j < byteSize; j++) {
            charArray[i*byteSize+j] = *(pValue+byteSize-j-1);
        }
    }
    return [NSData dataWithBytes:charArray length:byteLength];
}


NSArray<NSNumber *>* covertDataToShortArray(NSData *data)
{
    unsigned char byteSize = 2;
    unsigned char *bytes = (unsigned char *)[data bytes];
    unsigned long length = data.length;
    
    NSMutableArray *result = [NSMutableArray array];
    for(NSUInteger i = 0; i <length; i+= byteSize){
        short value;
        unsigned char *pValue = (unsigned char *)&value;
        for (NSInteger j = 0; j < byteSize; j++) {
            *(pValue+j) = *(bytes+i+byteSize-j-1);
        }
        [result addObject:[NSNumber numberWithShort:value]];
    }
    return result;
}


NSData* convertFloatArrayToData(NSArray<NSNumber *> *floatArray)
{
    unsigned char byteSize = 4;
    long count = floatArray.count;
    long length = byteSize*count;
    unsigned char charArray[length];
    for (NSInteger i = 0; i < count; i++) {
        float value = ((NSNumber *)floatArray[i]).floatValue;
        unsigned char *pValue = (unsigned char*)&value;
        for (unsigned char j = 0; j < byteSize; j++) {
            charArray[i*byteSize+j] = *(pValue+byteSize-j-1);
        }
    }
    return [NSData dataWithBytes:charArray length:length];
}



NSArray<NSNumber *>* covertDataToFloatArray(NSData *data)
{
    unsigned char byteSize = 4;
    unsigned char *bytes = (unsigned char *)[data bytes];
    unsigned long length = data.length;
    
    NSMutableArray *result = [NSMutableArray array];
    for(NSUInteger i = 0; i <length; i+= byteSize){
        float floatValue;
        unsigned char *pValue = (unsigned char *)&floatValue;
        for (unsigned char j = 0; j < byteSize; j++) {
            *(pValue+j) = *(bytes+i+byteSize-j-1);
        }
        [result addObject:[NSNumber numberWithFloat:floatValue]];
    }
    return result;
}

@implementation GGDataConversion

+ (NSData *)converStringToData:(NSString *)string encoding:(NSStringEncoding)encoding{
    return [string dataUsingEncoding:encoding allowLossyConversion:NO];
}

+ (NSString *)converDataToString:(NSData *)data encoding:(NSStringEncoding)encoding{
    return [[NSString alloc] initWithData:data encoding:encoding];
}


+ (NSData *)convertHexStringToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0,2);
    } else {
        range = NSMakeRange(0,1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}


+ (NSString *)converHexDataToString:(NSData *)data {
    Byte *bytes = (Byte *)[data bytes];
    NSString *string = @"";
    for (NSInteger i =0; i < data.length; i++) {
        string = [NSString stringWithFormat:@"%d",bytes[i]&0XFF];
    }
    return string;
}

+ (NSString *)converHexDataToString:(NSData *)data numberType:(NumberType)numberType
{
    Byte *bytes = (Byte *)[data bytes];
    NSString *string = @"";
    for (NSInteger i =0; i < data.length; i++) {
        if (numberType == OctalType) {
            string = [NSString stringWithFormat:@"%o",bytes[i]&0XFF];
        }
        else if (numberType == DecimalType){
            string = [NSString stringWithFormat:@"%d",bytes[i]&0XFF];
        }
        else {
           string = [NSString stringWithFormat:@"%x",bytes[i]&0XFF];
        }
    }
    return string;
}

+ (NSData *)convertStringToData:(NSString *)str
{
    NSData *datatemp =[str dataUsingEncoding:NSUTF8StringEncoding];
    int datatemplength =CFSwapInt32BigToHost((uint32_t)datatemp.length);  //大小端不一样，需要转化
    NSData *data = [NSData dataWithBytes: &datatemplength length: sizeof(datatemplength)];
    NSMutableData *result=[[NSMutableData alloc]init];
    [result appendData:data];
    [result appendData:datatemp];
    return result;
}

+ (NSData *) convertShortArrayToData:(NSArray <NSNumber *>*)shortArray
{
    return convertShortArrayToData(shortArray);
}

+ (NSArray <NSNumber *>*) convertDataToShortArray:(NSData *)data
{
    return covertDataToShortArray(data);
}



+ (NSData *) convertFloatArrayToData:(NSArray <NSNumber *>*)floatArray
{
    return convertFloatArrayToData(floatArray);
}


+ (NSArray <NSNumber *>*) convertDataToFloatArray:(NSData *)data
{
    return covertDataToFloatArray(data);
}


+ (NSData *)convertFloatToDataWithFloatValue:(float)floatValue
{
    unsigned char charArray[4];
    
    unsigned char *pdata = (unsigned char*)&floatValue;
    
    for(unsigned char i=0; i<4; i++) charArray[i] = *pdata++;
    
    return [NSData dataWithBytes:charArray length:sizeof(charArray)];
}

+ (float) convertDataToFloatWithNSData:(NSData *)data
{
    unsigned char *bytes = (unsigned char *)[data bytes];
    
    float floatValue;
    
    unsigned char *pf = (unsigned char *)&floatValue;
    
    for (unsigned char i = 0; i < 4; i++)  *(pf+i) = bytes[i];// *(pf+i) = *(bytes+i);
    
    return floatValue;
}

@end
