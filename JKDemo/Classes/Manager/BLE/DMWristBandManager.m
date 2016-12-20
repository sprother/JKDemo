//
//  DMWristBandManager.m
//  JKDemo
//
//  Created by jackyjiao on 12/14/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "DMWristBandManager.h"
#import "DMBLECentralManager.h"

#define DMServiceUUIDKey        @"DMServiceUUIDKey"
#define DMCharacteristicUUIDKey @"DMCharacteristicUUIDKey"

#define DMAlertLevel            @"DMAlertLevel"
#define DMTxPowerLevel          @"DMTxPowerLevel"
#define DMBatteryLevel          @"DMBatteryLevel"
#define DMHardwareRevision      @"DMHardwareRevision"
#define DMSoftwareRevision      @"DMSoftwareRevision"
#define DMManufacture           @"DMManufacture"
#define DMRSCUserData           @"DMRSCUserData"
#define DMRSCTimeSync           @"DMRSCTimeSync"
#define DMRSCMeasurement        @"DMRSCMeasurement"
#define DMRSCHistoryData        @"DMRSCHistoryData"
#define DMRSCTelephone          @"DMRSCTelephone"
#define DMRSCClockAlarm         @"DMRSCClockAlarm"
#define DMRSCMessageTip         @"DMRSCMessageTip"
#define DMRSCFindPhone          @"DMRSCFindPhone"
#define DMRSCiOSIncall          @"DMRSCiOSIncall"

@interface DMWristBandManager () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (atomic, assign) BOOL isConnect;
@property (nonatomic, strong) DMPeripheral *dmPeripheral;
@property (nonatomic, copy) NSDictionary<NSString *, NSDictionary *>*bandCharacteristicDict;

@end

@implementation DMWristBandManager

+ (instancetype)sharedManager {
    static DMWristBandManager *_instance = nil;
    static dispatch_once_t     onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[DMWristBandManager alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isConnect = NO;
        [self buildServiceData];
    }
    return self;
}

- (void)buildServiceData {
    self.bandCharacteristicDict = @{DMAlertLevel:        @{DMServiceUUIDKey:@"1802", DMCharacteristicUUIDKey:@"2A06"},//1.只写无响应
                                    DMTxPowerLevel:      @{DMServiceUUIDKey:@"1804", DMCharacteristicUUIDKey:@"2A07"},//2.只读
                                    DMBatteryLevel:      @{DMServiceUUIDKey:@"180F", DMCharacteristicUUIDKey:@"2A19"},//3.只读，通知；电量
                                    DMHardwareRevision:  @{DMServiceUUIDKey:@"180A", DMCharacteristicUUIDKey:@"2A27"},//4.
                                    DMSoftwareRevision:  @{DMServiceUUIDKey:@"180A", DMCharacteristicUUIDKey:@"2A28"},
                                    DMManufacture:       @{DMServiceUUIDKey:@"180A", DMCharacteristicUUIDKey:@"2A29"},
                                    DMRSCUserData:       @{DMServiceUUIDKey:@"1814", DMCharacteristicUUIDKey:@"1523"},//5.
                                    DMRSCTimeSync:       @{DMServiceUUIDKey:@"1814", DMCharacteristicUUIDKey:@"1524"},
                                    DMRSCMeasurement:    @{DMServiceUUIDKey:@"1814", DMCharacteristicUUIDKey:@"2A53"},
                                    DMRSCHistoryData:    @{DMServiceUUIDKey:@"1814", DMCharacteristicUUIDKey:@"1525"},
                                    DMRSCTelephone:      @{DMServiceUUIDKey:@"1814", DMCharacteristicUUIDKey:@"1526"},
                                    DMRSCClockAlarm:     @{DMServiceUUIDKey:@"1814", DMCharacteristicUUIDKey:@"1527"},
                                    DMRSCMessageTip:     @{DMServiceUUIDKey:@"1814", DMCharacteristicUUIDKey:@"1528"},
                                    DMRSCFindPhone:      @{DMServiceUUIDKey:@"1814", DMCharacteristicUUIDKey:@"1529"},
                                    DMRSCiOSIncall:      @{DMServiceUUIDKey:@"1814", DMCharacteristicUUIDKey:@"1530"},
                                    };
}

#pragma mark - connect
- (void)connectToDmperepheral:(DMPeripheral *)dmPeripheral {
    self.dmPeripheral = dmPeripheral;
    [DMBLECentralManager sharedManager].delegate = self;
    [[DMBLECentralManager sharedManager] connectPeripheral:self.dmPeripheral.peripheral];
}

- (void)cancelPeripheralConnection {
    [[DMBLECentralManager sharedManager] cancelPeripheralConnection:self.dmPeripheral.peripheral];
    [DMBLECentralManager sharedManager].delegate = nil;
    self.dmPeripheral = nil;
}

#pragma mark - interface
- (void)writeAlertLevelWithType:(DMAlertLevelType)type withCallback:(DMPeripheralWriteResultHandler)callback {
    uint8_t uiType = type;
    NSData *sendDataTmp = [NSData dataWithBytes:&uiType length:sizeof(uint8_t)];
    NSDictionary *charaInfoDict = self.bandCharacteristicDict[DMAlertLevel];
    [self.dmPeripheral writeValue:sendDataTmp type:CBCharacteristicWriteWithoutResponse ForCharacteristicWithUUID:charaInfoDict[DMCharacteristicUUIDKey] ofServiceWithUUID:charaInfoDict[DMServiceUUIDKey] callback:callback];
}

#pragma mark 读取信号强度
- (void)readTxPowerLevelWithCallback:(DMWristBandReadTxPowerLevelResultHandler)callback {
    NSDictionary *charaInfoDict = self.bandCharacteristicDict[DMTxPowerLevel];
    [self.dmPeripheral readValueForCharacteristicWithUUID:charaInfoDict[DMCharacteristicUUIDKey] ofServiceWithUUID:charaInfoDict[DMServiceUUIDKey] callback:^(NSData *data, NSError *error) {
        if (error) {
            callback(0, error);
            return;
        }
        int8_t getBytes[1];
        [data getBytes:getBytes range:NSMakeRange(0, 1)];
        int8_t level = getBytes[0];
        callback(level, nil);
    }];
}

#pragma mark 读取手环电量
- (void)readBatteryLevelWithCallback:(DMWristBandReadBatteryLevelResultHandler)callback {
    NSDictionary *charaInfoDict = self.bandCharacteristicDict[DMBatteryLevel];
    [self.dmPeripheral readValueForCharacteristicWithUUID:charaInfoDict[DMCharacteristicUUIDKey] ofServiceWithUUID:charaInfoDict[DMServiceUUIDKey] callback:^(NSData *data, NSError *error) {
        if (error) {
            callback(0, error);
            return;
        }
        uint8_t getBytes[1];
        [data getBytes:getBytes range:NSMakeRange(0, 1)];
        uint8_t level = getBytes[0];
        callback(level, nil);
    }];
}

#pragma mark 读取手环的信息
- (void)readManufacturerNameForDeviceInfoWithCallback:(DMWristBandReadDeviceInfoResultHandler)callback {
    NSDictionary *charaInfoDict = self.bandCharacteristicDict[DMManufacture];
    [self.dmPeripheral readValueForCharacteristicWithUUID:charaInfoDict[DMCharacteristicUUIDKey] ofServiceWithUUID:charaInfoDict[DMServiceUUIDKey] callback:^(NSData *data, NSError *error) {
        if (error) {
            callback(nil, error);
            return;
        }
        NSString *info = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        callback(info, nil);
    }];
}

- (void)readHardwareRevisionForDeviceInfoWithCallback:(DMWristBandReadDeviceInfoResultHandler)callback {
    NSDictionary *charaInfoDict = self.bandCharacteristicDict[DMHardwareRevision];
    [self.dmPeripheral readValueForCharacteristicWithUUID:charaInfoDict[DMCharacteristicUUIDKey] ofServiceWithUUID:charaInfoDict[DMServiceUUIDKey] callback:^(NSData *data, NSError *error) {
        if (error) {
            callback(nil, error);
            return;
        }
        NSString *info = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        callback(info, nil);
    }];
}

- (void)readSoftwareRevisionForDeviceInfoWithCallback:(DMWristBandReadDeviceInfoResultHandler)callback {
    NSDictionary *charaInfoDict = self.bandCharacteristicDict[DMSoftwareRevision];
    [self.dmPeripheral readValueForCharacteristicWithUUID:charaInfoDict[DMCharacteristicUUIDKey] ofServiceWithUUID:charaInfoDict[DMServiceUUIDKey] callback:^(NSData *data, NSError *error) {
        if (error) {
            callback(nil, error);
            return;
        }
        NSString *info = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        callback(info, nil);
    }];
}

#pragma mark 读取RSC信息-UserData
- (void)writeRSCUserDataWithType:(DMWristBandUserData *)userData withCallback:(DMPeripheralWriteResultHandler)callback {
    NSDictionary *charaInfoDict = self.bandCharacteristicDict[DMRSCUserData];
    [self.dmPeripheral writeValue:[userData toData] type:CBCharacteristicWriteWithResponse ForCharacteristicWithUUID:charaInfoDict[DMCharacteristicUUIDKey] ofServiceWithUUID:charaInfoDict[DMServiceUUIDKey] callback:callback];
}

- (void)readRSCUserDataWithCallback:(DMWristBandReadRSCUserDataResultHandler)callback {
    NSDictionary *charaInfoDict = self.bandCharacteristicDict[DMRSCUserData];
    [self.dmPeripheral readValueForCharacteristicWithUUID:charaInfoDict[DMCharacteristicUUIDKey] ofServiceWithUUID:charaInfoDict[DMServiceUUIDKey] callback:^(NSData *data, NSError *error) {
        if (error) {
            callback(nil, error);
            return;
        }
        callback([DMWristBandUserData fromData:data], nil);
    }];
}

#pragma mark 读取RSC信息-Date
- (void)writeRSCDateWithType:(NSDate *)date withCallback:(DMPeripheralWriteResultHandler)callback {
    NSDictionary *charaInfoDict = self.bandCharacteristicDict[DMRSCTimeSync];
    [self.dmPeripheral writeValue:[date toData] type:CBCharacteristicWriteWithResponse ForCharacteristicWithUUID:charaInfoDict[DMCharacteristicUUIDKey] ofServiceWithUUID:charaInfoDict[DMServiceUUIDKey] callback:callback];
}

- (void)readRSCDateWithCallback:(DMWristBandReadRSCDateResultHandler)callback {
    NSDictionary *charaInfoDict = self.bandCharacteristicDict[DMRSCTimeSync];
    [self.dmPeripheral readValueForCharacteristicWithUUID:charaInfoDict[DMCharacteristicUUIDKey] ofServiceWithUUID:charaInfoDict[DMServiceUUIDKey] callback:^(NSData *data, NSError *error) {
        if (error) {
            callback(nil, error);
            return;
        }
        callback([NSDate fromData:data], nil);
    }];
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {//无需响应
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    if (peripheral != self.dmPeripheral.peripheral) {
        return;
    }
    self.isConnect = YES;
    self.dmPeripheral.peripheralDelegate = self;
    [self.dmPeripheral discoverServices];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    [MBProgressHUD tc_showBottomIndicatorMessage:@"Connect Fail"];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    [MBProgressHUD tc_showBottomIndicatorMessage:@"Disconnect"];
    self.isConnect = NO;
}

#pragma mark - CBPeripheralDelegate
#pragma mark 发现服务后的回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    for (CBService *service in peripheral.services) {
        JLog(@"3.0 discoverCharacteristics of Service found with UUID: %@, service %@ .", service.UUID, service);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

#pragma mark 发现特性后的回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
}

- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral {
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray<CBService *> *)invalidatedServices {
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error {
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(nullable NSError *)error {

}

#pragma mark 读特性/订阅成功后特性发生任何改变 的回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (characteristic == nil || characteristic.value == nil) {
        return;
    }
    if ([self.bandCharacteristicDict[DMBatteryLevel][DMCharacteristicUUIDKey] isEqualToString:characteristic.UUID.UUIDString]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(bandDidUpdateBatteryLevel:)]) {
            uint8_t getBytes[1];
            [characteristic.value getBytes:getBytes range:NSMakeRange(0, 1)];
            uint8_t level = getBytes[0];
            [self.delegate bandDidUpdateBatteryLevel:level];
        }
        return;
    }
    
}

#pragma mark 写特性后的回调
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
}

#pragma mark 订阅特性后的回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
}

@end
