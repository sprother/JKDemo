//
//  DMWristBandManager.m
//  JKDemo
//
//  Created by jackyjiao on 12/14/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "DMWristBandManager.h"

@interface DMWristBandManager () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, assign) BOOL isConnect;

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
    }
    return self;
}


#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {//无需响应
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    self.dmPeripheral.peripheralDelegate = self;
    [self.dmPeripheral discoverServices];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    [MBProgressHUD tc_showBottomIndicatorMessage:@"Connect Fail"];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    [MBProgressHUD tc_showBottomIndicatorMessage:@"Disconnect"];
}


#pragma mark - CBPeripheralDelegate
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral {
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray<CBService *> *)invalidatedServices {
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error {
}

#pragma mark 发现服务后的回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    for (CBService *service in peripheral.services) {
        JLog(@"3.0 discoverCharacteristics of Service found with UUID: %@, service %@ .", service.UUID, service);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(nullable NSError *)error {

}

#pragma mark 发现特性后的回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
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
