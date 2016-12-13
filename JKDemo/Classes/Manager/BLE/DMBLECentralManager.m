//
//  DMBLECentralManager.m
//  DeviceManager
//
//  Created by hth on 11/27/15.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import "DMBLECentralManager.h"

@interface DMBLECentralManager () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) dispatch_queue_t bleQueue;
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral     *connectedPeripheral;
@property (nonatomic, strong) NSMutableArray   *uuidArray;

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
        self.centralManager      = nil;
        self.connectedPeripheral = nil;
        self.periArray           = [NSArray new];
        self.periInfo            = [NSArray new];
        self.uuidArray           = [NSMutableArray new];
    }
    return self;
}

#pragma mark - scan
- (void)startScan {
    if (self.centralManager) {
        if ([self.centralManager isScanning]) {
            JLog(@"GATT is being scanning.");
        } else {
            [self.centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(NO)}];
        }
    } else {
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:self.bleQueue options:@{CBCentralManagerOptionShowPowerAlertKey:@(YES),
                                                                                                  CBCentralManagerOptionRestoreIdentifierKey:                                                                                           @"myCentralManagerIdentifier"}];
    }
}

- (void)stopScan {
    if ([self.centralManager isScanning]) {
        [self.centralManager stopScan];
    }
}

- (void)connectPeripheral:(CBPeripheral *)peripheral; {
    if (self.centralManager && self.connectedPeripheral == nil) {
        self.connectedPeripheral = peripheral;
        [self.centralManager connectPeripheral:self.connectedPeripheral options:nil];
        JLog(@"1.0 connect to Peripheral:%@", self.connectedPeripheral);
    }
}

- (void)cancelPeripheralConnection {
    if (self.centralManager && self.connectedPeripheral) {
        [self.centralManager cancelPeripheralConnection:self.connectedPeripheral];
        self.connectedPeripheral = nil;
        self.periInfo = nil;
        JLog(@"======cancelPeripheralConnection to Peripheral:%@", self.connectedPeripheral);
    }
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
    case CBCentralManagerStatePoweredOn: {
        [self startScan];
    } break;
    case CBCentralManagerStatePoweredOff: {
        [self stopScan];
        [self cancelPeripheralConnection];
    } break;
    case CBCentralManagerStateUnknown:
        break;
    case CBCentralManagerStateResetting:
        break;
    case CBCentralManagerStateUnsupported:
        break;
    case CBCentralManagerStateUnauthorized:
        break;
    default:
        break;
    }
    if (central.state != CBCentralManagerStatePoweredOn) {
        JLog(@"central state unexpected!");
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary <NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    NSUUID *tmpUUID = peripheral.identifier;
    if (tmpUUID == nil || [self.uuidArray containsObject:tmpUUID]) {
        return;
    }
    [self.uuidArray addObject:tmpUUID.copy];
    JLog(@"didDiscoverPeripheral %@", peripheral);
    
    NSMutableArray *mTmpPeriArray = [NSMutableArray arrayWithArray:self.periArray];
    NSDictionary *tmpDict = @{JKBLEKEYPeripheral : peripheral, JKBLEKEYAdvertiseData : advertisementData, JKBLEKEYPeripheralRSSI : RSSI};
    
    NSUInteger tmpIndex;
    for (tmpIndex = 0; tmpIndex < [mTmpPeriArray count]; tmpIndex++) {
        NSDictionary *iDict = [mTmpPeriArray objectAtIndex:tmpIndex];
        NSNumber *iRSSI = iDict[JKBLEKEYPeripheralRSSI];
        if (RSSI > iRSSI) {//降序
            break;
        }
    }
    [mTmpPeriArray insertObject:tmpDict atIndex:tmpIndex];
    self.periArray = [mTmpPeriArray copy];
    
    MAIN(^{
        [[NSNotificationCenter defaultCenter] postNotificationName:JKPeriListUpdateNotification object:nil];
    });
}

#pragma mark - Connect
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    JLog(@"1.2 didConnectPeripheral: %@", peripheral);

    [self.connectedPeripheral setDelegate:self];
    [self.connectedPeripheral discoverServices:nil];
    JLog(@"==========2.0 discoverServices.");
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    JLog(@"didFailToConnectPeripheral: %@  error: %@", peripheral, error);
    self.connectedPeripheral = nil;

}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    JLog(@"didDisconnectPeripheral: %@  error: %@", peripheral, error);
    self.connectedPeripheral = nil;

}

#pragma mark - CBPeripheralDelegate methods
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral {
    JLog(@"peripheralDidUpdateName: %@", peripheral);
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray <CBService *> *)invalidatedServices {
    JLog(@"didModifyServices: %@", invalidatedServices);
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    JLog(@"peripheralDidUpdateRSSI: %@, error : %@", peripheral, error);
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error {
    JLog(@"didReadRSSI: %@, error : %@", RSSI, error);
}

#pragma mark didDiscoverServices
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    JLog(@"2.1 didDiscoverServices: %@, error : %@, peripheral : %@", peripheral.services, error, peripheral);

    //判断服务是否为空，为空提示忘记连接
    if ([peripheral.services count] == 0) {
        JLog(@"services 为空，请在设置中忘记之前的连接");
    }
    
    for (CBService *service in peripheral.services) {
        JLog(@"3.0 discoverCharacteristics of Service found with UUID: %@, service %@ .", service.UUID, service);
        NSDictionary *tmpDict = @{JKBLEKEYService : service};
        NSMutableArray *mTmpArray = [NSMutableArray arrayWithArray:self.periInfo];
        [mTmpArray addObject:tmpDict];
        self.periInfo = [mTmpArray copy];
        [peripheral discoverCharacteristics:nil forService:service];
    }
    MAIN(^{
        [[NSNotificationCenter defaultCenter] postNotificationName:JKPeripheralUpdateNotification object:nil];
    });
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(nullable NSError *)error {
    JLog(@"didDiscoverIncludedServicesForService: %@, error : %@", service, error);
}

#pragma mark didDiscoverCharacteristics
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    JLog(@"3.1 didDiscoverCharacteristics: %@, error : %@", service.characteristics, error);

    NSMutableDictionary *mTmpDict = nil;
    for (NSDictionary *dict in self.periInfo) {
        CBService *tmpService = dict[JKBLEKEYService];
        if ([tmpService.UUID.UUIDString isEqualToString:service.UUID.UUIDString]) {
            NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self.periInfo];
            [tmpArray removeObject:dict];
            self.periInfo = tmpArray;
            mTmpDict = [dict mutableCopy];
            break;
        }
    }
    if (mTmpDict == nil) {
        return;
    }
    mTmpDict[JKBLEKEYCharacteristics] = service.characteristics;
    NSMutableArray *mTmpArray = [NSMutableArray arrayWithArray:self.periInfo];
    [mTmpArray addObject:[mTmpDict copy]];
    self.periInfo = [mTmpArray copy];
    MAIN(^{
        [[NSNotificationCenter defaultCenter] postNotificationName:JKPeripheralUpdateNotification object:nil];
    });
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    JLog(@"didUpdateValueForCharacteristic: %@, error : %@", characteristic, error);
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    JLog(@"=====didWriteValueForCharacteristic: %@, error : %@", characteristic, error);

}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    JLog(@"didUpdateNotificationStateForCharacteristic: %@, error : %@", characteristic, error);


}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    JLog(@"didDiscoverDescriptorsForCharacteristic: %@, error : %@", characteristic, error);


}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
    JLog(@"didUpdateValueForDescriptor: %@, error : %@", descriptor, error);


}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
    JLog(@"didWriteValueForDescriptor: %@, error : %@", descriptor, error);


}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary <NSString *, id> *)dict {
    JLog(@"willRestoreState: %@", dict);
}


#pragma mark - peripheral data exchange
- (void)readDataFromConnectedPeripheral {
    
}

- (void)writeDataToConnectedPeripheral:(NSData *)data {
    
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
