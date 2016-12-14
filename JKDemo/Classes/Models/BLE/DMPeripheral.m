//
//  DMPeripheral.m
//  JKDemo
//
//  Created by jackyjiao on 12/14/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "DMPeripheral.h"

@interface DMPeripheral () <CBPeripheralDelegate>

@end

@implementation DMPeripheral

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary <NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    if (self = [super init]) {
        self.peripheral        = peripheral;
        self.advertisementData = advertisementData;
        self.RSSI              = RSSI;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[self class]]) {
        DMPeripheral *dmObject = (DMPeripheral *)object;
        return [self.peripheral isEqual:dmObject.peripheral];
    }
    return NO;
}

- (NSComparisonResult)compare:(DMPeripheral *)dmPeripheral {
    NSComparisonResult result = [self.RSSI compare:dmPeripheral.RSSI];

    return result == NSOrderedAscending;  // 降序
}

#pragma mark - discover
- (void)discoverServices {
    self.peripheral.delegate = self;
    [self.peripheral discoverServices:nil];
}

- (void)discoverCharacteristicsForService:(CBService *)service {
    [self.peripheral discoverCharacteristics:nil forService:service];
}

#pragma mark - CBPeripheralDelegate
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral {
    if (self.peripheralDelegate && [self.peripheralDelegate respondsToSelector:@selector(peripheralDidUpdateName:)]) {
        [self.peripheralDelegate peripheralDidUpdateName:peripheral];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray<CBService *> *)invalidatedServices {
    if (self.peripheralDelegate && [self.peripheralDelegate respondsToSelector:@selector(peripheral:didModifyServices:)]) {
        [self.peripheralDelegate peripheral:peripheral didModifyServices:invalidatedServices];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error {
    if (self.peripheralDelegate && [self.peripheralDelegate respondsToSelector:@selector(peripheral:didReadRSSI:error:)]) {
        [self.peripheralDelegate peripheral:peripheral didReadRSSI:RSSI error:error];
    }
}

#pragma mark 发现服务后的回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    if (self.peripheralDelegate && [self.peripheralDelegate respondsToSelector:@selector(peripheral:didDiscoverServices:)]) {
        [self.peripheralDelegate peripheral:peripheral didDiscoverServices:error];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(nullable NSError *)error {
    if (self.peripheralDelegate && [self.peripheralDelegate respondsToSelector:@selector(peripheral:didDiscoverIncludedServicesForService:error:)]) {
        [self.peripheralDelegate peripheral:peripheral didDiscoverIncludedServicesForService:service error:error];
    }
}

#pragma mark 发现特性后的回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    if (self.peripheralDelegate && [self.peripheralDelegate respondsToSelector:@selector(peripheral:didDiscoverCharacteristicsForService:error:)]) {
        [self.peripheralDelegate peripheral:peripheral didDiscoverCharacteristicsForService:service error:error];
    }
}

#pragma mark 读特性/订阅成功后特性发生任何改变 的回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (self.peripheralDelegate && [self.peripheralDelegate respondsToSelector:@selector(peripheral:didUpdateValueForCharacteristic:error:)]) {
        [self.peripheralDelegate peripheral:peripheral didUpdateValueForCharacteristic:characteristic error:error];
    }
}

#pragma mark 写特性后的回调
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (self.peripheralDelegate && [self.peripheralDelegate respondsToSelector:@selector(peripheral:didWriteValueForCharacteristic:error:)]) {
        [self.peripheralDelegate peripheral:peripheral didWriteValueForCharacteristic:characteristic error:error];
    }
}

#pragma mark 订阅特性后的回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (self.peripheralDelegate && [self.peripheralDelegate respondsToSelector:@selector(peripheral:didUpdateNotificationStateForCharacteristic:error:)]) {
        [self.peripheralDelegate peripheral:peripheral didUpdateNotificationStateForCharacteristic:characteristic error:error];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (self.peripheralDelegate && [self.peripheralDelegate respondsToSelector:@selector(peripheral:didDiscoverDescriptorsForCharacteristic:error:)]) {
        [self.peripheralDelegate peripheral:peripheral didDiscoverDescriptorsForCharacteristic:characteristic error:error];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
    if (self.peripheralDelegate && [self.peripheralDelegate respondsToSelector:@selector(peripheral:didUpdateValueForDescriptor:error:)]) {
        [self.peripheralDelegate peripheral:peripheral didUpdateValueForDescriptor:descriptor error:error];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
    if (self.peripheralDelegate && [self.peripheralDelegate respondsToSelector:@selector(peripheral:didWriteValueForDescriptor:error:)]) {
        [self.peripheralDelegate peripheral:peripheral didWriteValueForDescriptor:descriptor error:error];
    }
}

@end
