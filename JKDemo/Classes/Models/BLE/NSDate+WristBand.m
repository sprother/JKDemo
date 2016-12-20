//
//  NSDate+WristBand.m
//  JKDemo
//
//  Created by jackyjiao on 12/20/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "NSDate+WristBand.h"

#define DMWristBandDateLength 7

@implementation NSDate (WristBand)

+ (id)fromData:(NSData *)data {
    if ([data length] == DMWristBandDateLength) {
        uint8_t getBytes[DMWristBandDateLength];
        [data getBytes:getBytes range:NSMakeRange(0, DMWristBandDateLength)];
        uint16_t year = 0;//获取年
        for (int i = 0; i < sizeof(uint16_t); i++) {
            year = year | (uint16_t)getBytes[0+i]<<(8*i);
        }
        NSCalendar       *gregorian  = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setYear:year];
        [components setMonth:getBytes[2]];
        [components setDay:getBytes[3]];
        [components setHour:getBytes[4]];
        [components setMinute:getBytes[5]];
        [components setSecond:getBytes[6]];
        return [gregorian dateFromComponents:components];
    }
    return nil;
}

- (NSData *)toData {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSMutableData *mDataTmp;
    NSData *tmp;
    //添加年
    uint16_t year = [components year];
    mDataTmp = [NSMutableData dataWithBytes:&year length:sizeof(uint16_t)];
    //添加月
    uint8_t month = [components month];
    tmp = [NSData dataWithBytes:&month length:sizeof(uint8_t)];
    [mDataTmp appendData:tmp];
    //添加日
    uint8_t day = [components day];
    tmp = [NSData dataWithBytes:&day length:sizeof(uint8_t)];
    [mDataTmp appendData:tmp];
    //添加时
    uint16_t hour = [components hour];
    tmp = [NSData dataWithBytes:&hour length:sizeof(uint8_t)];
    [mDataTmp appendData:tmp];
    //添加分
    uint16_t minute = [components minute];
    tmp = [NSData dataWithBytes:&minute length:sizeof(uint8_t)];
    [mDataTmp appendData:tmp];
    //添加秒
    uint16_t second = [components second];
    tmp = [NSData dataWithBytes:&second length:sizeof(uint8_t)];
    [mDataTmp appendData:tmp];
    return [mDataTmp copy];
}

@end
