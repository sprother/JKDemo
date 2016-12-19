//
//  DMWristBandManager.h
//  JKDemo
//
//  Created by jackyjiao on 12/14/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMPeripheral.h"

typedef NS_ENUM (NSInteger, DMAlertLevelType) {
    DMAlertLevelTypeNoAlert  = 0,
    DMAlertLevelTypeMidAlert = 1
};

typedef void (^DMWristBandWriteResultHandler)(NSError *);
typedef void (^DMWristBandWriteResultHandler)(NSError *);

@interface DMWristBandManager : NSObject

@property (atomic, assign, readonly) BOOL isConnect;

+ (instancetype)sharedManager;

- (void)connectToDmperepheral:(DMPeripheral *)dmPeripheral;
- (void)cancelPeripheralConnection;

- (void)writeAlertLevelWithType:(DMAlertLevelType)type withCallback:(DMPeripheralWriteResultHandler)callback;
- (void)readTxPowerLevelWithCallback:(DMPeripheralReadResultHandler)callback;

@end
