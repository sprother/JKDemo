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
