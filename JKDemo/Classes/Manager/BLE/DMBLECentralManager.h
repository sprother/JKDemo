//
//  DMBLECentralManager.h
//  DeviceManager
//
//  Created by hth on 11/27/15.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "DMPeripheral.h"

#define JKPeriListUpdateNotification @"JKPeriListUpdateNotification"

@interface DMBLECentralManager : NSObject

@property (atomic, strong) NSArray<DMPeripheral *>       *periArray;
@property (nonatomic, weak) id<CBCentralManagerDelegate> delegate;

+ (instancetype)sharedManager;

- (void)startScan;
- (void)stopScan;
- (void)connectPeripheral:(CBPeripheral *)peripheral;
- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral;

@end
