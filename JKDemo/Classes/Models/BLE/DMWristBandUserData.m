//
//  DMWristBandUserData.m
//  JKDemo
//
//  Created by jackyjiao on 12/20/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "DMWristBandUserData.h"

#define DMWristBandUserDataLength 9

@implementation DMWristBandUserData

+ (id)fromData:(NSData *)data {
    if ([data length] == DMWristBandUserDataLength) {
        return [[[self alloc] init] fromData:data];
    }
    return nil;
}

- (id)fromData:(NSData *)data {
    if ([data length] == DMWristBandUserDataLength) {
        uint8_t getBytes[DMWristBandUserDataLength];
        [data getBytes:getBytes range:NSMakeRange(0, DMWristBandUserDataLength)];
        self.sex = (DMUserDataSex)getBytes[0];
        self.age = getBytes[1];
        self.stepLength = getBytes[2];
        Byte offset;
        uint16_t height = 0;//获取身高
        offset = 2;
        for (int i = 0; i < sizeof(uint16_t); i++) {
            height = height | (uint16_t)getBytes[offset+i]<<(8*i);
        }
        self.height = height;
        uint16_t weight = 0;//获取体重
        offset = 4;
        for (int i = 0; i < sizeof(uint16_t); i++) {
            weight = weight | (uint16_t)getBytes[offset+i]<<(8*i);
        }
        self.weight = weight;
        uint16_t longSit = 0;//获取久坐时间
        offset = 6;
        for (int i = 0; i < sizeof(uint16_t); i++) {
            longSit = longSit | (uint16_t)getBytes[offset+i]<<(8*i);
        }
        self.longSitTime = longSit;
        return self;
    }
    return nil;
}

- (NSData *)toData {
    NSMutableData *mDataTmp;
    NSData *tmp;
    //添加性别
    uint8_t sex = self.sex;
    mDataTmp = [NSMutableData dataWithBytes:&sex length:sizeof(uint8_t)];
    //添加年龄
    uint8_t age = self.age;
    tmp = [NSData dataWithBytes:&age length:sizeof(uint8_t)];
    [mDataTmp appendData:tmp];
    //添加步长
    uint8_t stepLength = self.stepLength;
    tmp = [NSData dataWithBytes:&stepLength length:sizeof(uint8_t)];
    [mDataTmp appendData:tmp];
    //添加身高
    uint16_t height = self.height;
    tmp = [NSData dataWithBytes:&height length:sizeof(uint16_t)];
    [mDataTmp appendData:tmp];
    //添加体重
    uint16_t weight = self.weight;
    tmp = [NSData dataWithBytes:&weight length:sizeof(uint16_t)];
    [mDataTmp appendData:tmp];
    //添加久坐时间
    uint16_t longSit = self.longSitTime;
    tmp = [NSData dataWithBytes:&longSit length:sizeof(uint16_t)];
    [mDataTmp appendData:tmp];
    return [mDataTmp copy];
}

@end
