//
//  DMWristBandManager.h
//  JKDemo
//
//  Created by jackyjiao on 12/14/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMPeripheral.h"
#import "DMWristBandUserData.h"
#import "NSDate+WristBand.h"

typedef NS_ENUM (NSInteger, DMAlertLevelType) {
    DMAlertLevelTypeNoAlert  = 0,
    DMAlertLevelTypeMidAlert = 1
};

@protocol DMWristBandDelegate <NSObject>
@optional
- (void)bandDidUpdateBatteryLevel:(uint8_t)level;

@end

typedef void (^DMWristBandReadTxPowerLevelResultHandler)(int8_t level, NSError *error);
typedef void (^DMWristBandReadBatteryLevelResultHandler)(uint8_t level, NSError *error);
typedef void (^DMWristBandReadDeviceInfoResultHandler)(NSString *info, NSError *error);
typedef void (^DMWristBandReadRSCUserDataResultHandler)(DMWristBandUserData *info, NSError *error);
typedef void (^DMWristBandReadRSCDateResultHandler)(NSDate *date, NSError *error);

@interface DMWristBandManager : NSObject

@property (atomic, assign, readonly) BOOL isConnect;
@property (nonatomic, weak) id<DMWristBandDelegate> delegate;

+ (instancetype)sharedManager;

- (void)connectToDmperepheral:(DMPeripheral *)dmPeripheral;
- (void)cancelPeripheralConnection;

//设置警告级别, 0为NoAlert; 1为MidAlert
- (void)writeAlertLevelWithType:(DMAlertLevelType)type withCallback:(DMPeripheralWriteResultHandler)callback;
//读取信号强度
- (void)readTxPowerLevelWithCallback:(DMWristBandReadTxPowerLevelResultHandler)callback;
//读取手环电量
- (void)readBatteryLevelWithCallback:(DMWristBandReadBatteryLevelResultHandler)callback;
//读取手环的信息(制造商,软件版本,硬件版本)
- (void)readManufacturerNameForDeviceInfoWithCallback:(DMWristBandReadDeviceInfoResultHandler)callback;
- (void)readHardwareRevisionForDeviceInfoWithCallback:(DMWristBandReadDeviceInfoResultHandler)callback;
- (void)readSoftwareRevisionForDeviceInfoWithCallback:(DMWristBandReadDeviceInfoResultHandler)callback;
//读取RSC信息-UserData
- (void)writeRSCUserDataWithType:(DMWristBandUserData *)userData withCallback:(DMPeripheralWriteResultHandler)callback;
- (void)readRSCUserDataWithCallback:(DMWristBandReadRSCUserDataResultHandler)callback;
//读取RSC信息-Date
- (void)writeRSCDateWithType:(NSDate *)date withCallback:(DMPeripheralWriteResultHandler)callback;
- (void)readRSCDateWithCallback:(DMWristBandReadRSCDateResultHandler)callback;
//读取RSC信息-测量
//- (void)writeRSCDateWithType:(NSDate *)date withCallback:(DMPeripheralWriteResultHandler)callback;
//- (void)readRSCDateWithCallback:(DMWristBandReadRSCDateResultHandler)callback;
@end
