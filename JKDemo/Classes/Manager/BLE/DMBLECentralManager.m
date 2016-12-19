//
//  DMBLECentralManager.m
//  DeviceManager
//
//  Created by hth on 11/27/15.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import "DMBLECentralManager.h"

@interface DMBLECentralManager () <CBCentralManagerDelegate>

@property (nonatomic, strong) dispatch_queue_t bleQueue;
@property (nonatomic, strong) CBCentralManager *centralManager;

@end

@implementation DMBLECentralManager

+ (instancetype)sharedManager {
    static DMBLECentralManager *_instance = nil;
    static dispatch_once_t     onceToken;

    dispatch_once(&onceToken, ^{
        _instance = [[DMBLECentralManager alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.periArray = [NSArray new];
    }
    return self;
}

#pragma mark - scan(Non-bleQueue)
- (void)startScan {
    if ([self.centralManager isScanning]) {
        JLog(@"GATT is being scanning.");
    } else {
//        [self.centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(NO)}];
        [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"0000180A-0000-1000-8000-00805F9B34FB"]] options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(NO)}];
    }
}

- (void)stopScan {
    if ([self.centralManager isScanning]) {
        [self.centralManager stopScan];
    }
}

#pragma mark - Interface(Non-bleQueue)
- (void)connectPeripheral:(CBPeripheral *)peripheral {
    if (self.centralManager && peripheral.state == CBPeripheralStateDisconnected) {
        dispatch_async(self.bleQueue, ^{
            [self.centralManager connectPeripheral:peripheral options:nil];
        });
    }
}

- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral {
    if (self.centralManager && peripheral.state == CBPeripheralStateConnected) {
        dispatch_async(self.bleQueue, ^{
            [self.centralManager cancelPeripheralConnection:peripheral];
        });
    }
}

#pragma mark - CBCentralManagerDelegate(bleQueue)
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
    case CBCentralManagerStatePoweredOn: {
        [self startScan];
    } break;
    case CBCentralManagerStatePoweredOff: {
        [self stopScan];
    } break;
    case CBCentralManagerStateUnauthorized: {
        JLog(@"central state unexpected!");
    }
    break;
    case CBCentralManagerStateUnknown: {
        JLog(@"central state unexpected!");
    }
    break;
    case CBCentralManagerStateResetting: {
        JLog(@"central state unexpected!");
    }
    break;
    case CBCentralManagerStateUnsupported: {
        JLog(@"central state unexpected!");
    }
    break;
    default:
        break;
    }
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict {
    JLog(@"willRestoreState %@", dict);
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary <NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    DMPeripheral *dmPeripheral = [[DMPeripheral alloc] initWithPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];

    if ([self.periArray containsObject:dmPeripheral]) {
        return;
    }
//    if (![peripheral.name containsString:@"Pace"]) {
//        return;
//    }
    JLog(@"didDiscoverPeripheral %@, (%@)", peripheral, advertisementData);
    NSMutableArray *mTmpPeriArray = [NSMutableArray arrayWithArray:self.periArray];
    [mTmpPeriArray addObject:dmPeripheral];
    [mTmpPeriArray sortedArrayUsingSelector:@selector(compare:)];
    self.periArray = [mTmpPeriArray sortedArrayUsingSelector:@selector(compare:)];

    MAIN(^{
        [[NSNotificationCenter defaultCenter] postNotificationName:JKPeriListUpdateNotification object:nil];
        if (self.delegate && [self.delegate respondsToSelector:@selector(centralManager:didDiscoverPeripheral:advertisementData:RSSI:)]) {
            [self.delegate centralManager:central didDiscoverPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
        }
    });
}

#pragma mark - Connect(bleQueue)
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    JLog(@"didConnectPeripheral: %@", peripheral);
    MAIN(^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(centralManager:didConnectPeripheral:)]) {
            [self.delegate centralManager:central didConnectPeripheral:peripheral];
        }
    });
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    JLog(@"didFailToConnectPeripheral: %@  error: %@", peripheral, error);
    MAIN(^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(centralManager:didFailToConnectPeripheral:error:)]) {
            [self.delegate centralManager:central didFailToConnectPeripheral:peripheral error:error];
        }
    });

}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    JLog(@"didDisconnectPeripheral: %@  error: %@", peripheral, error);
    MAIN(^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(centralManager:didDisconnectPeripheral:error:)]) {
            [self.delegate centralManager:central didDisconnectPeripheral:peripheral error:error];
        }
    });

}

#pragma mark - centralManager
- (CBCentralManager *)centralManager {
    if (_centralManager == nil) {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:self.bleQueue options:@{CBCentralManagerOptionShowPowerAlertKey:@(YES),
                                                                                                        CBCentralManagerOptionRestoreIdentifierKey:                                                                                           @"myCentralManagerIdentifier"}];
    }
    return _centralManager;
}

#pragma mark - bleQueue
- (dispatch_queue_t)bleQueue {
    @synchronized (self) {
        if (_bleQueue == nil) {
            _bleQueue = dispatch_queue_create("com.tencent.dm.bleQueue", DISPATCH_QUEUE_SERIAL);
        }
        return _bleQueue;
    }
}

@end
