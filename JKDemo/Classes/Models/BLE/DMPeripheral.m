//
//  DMPeripheral.m
//  JKDemo
//
//  Created by jackyjiao on 12/14/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "DMPeripheral.h"
#import "DMBLECentralManager.h"

#define DMCharacteristicReadWriteTimeout 4

#define DMBLEReadDefaultCallback ^(NSData *data, NSError *error){}
#define DMBLEWriteDefaultCallback ^(NSError *error){}

@interface DMPeripheral () <CBPeripheralDelegate>

@property (nonatomic, strong) dispatch_queue_t bleQueue;
@property (nonatomic, strong) NSMutableDictionary<CBUUID *, DMPeripheralReadResultHandler> *readHandles;
@property (nonatomic, strong) NSMutableDictionary<CBUUID *, DMPeripheralWriteResultHandler> *writeHandles;

@end

@implementation DMPeripheral

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary <NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    if (self = [super init]) {
        self.peripheral        = peripheral;
        self.advertisementData = advertisementData;
        self.RSSI              = RSSI;
        self.bleQueue          = [DMBLECentralManager sharedManager].bleQueue;
        self.readHandles       = [NSMutableDictionary new];
        self.writeHandles      = [NSMutableDictionary new];
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

#pragma mark - discover(Non-bleQueue)
- (void)discoverServices {
    self.peripheral.delegate = self;
    dispatch_async(self.bleQueue, ^{
        [self.peripheral discoverServices:nil];
    });
    
}

- (void)discoverCharacteristicsForService:(CBService *)service {
    dispatch_async(self.bleQueue, ^{
        [self.peripheral discoverCharacteristics:nil forService:service];
    });
}

#pragma mark - read&write(Non-bleQueue)
- (void)readValueForCharacteristicWithUUID:(NSString *)cUUID ofServiceWithUUID:(NSString *)sUUID callback:(DMPeripheralReadResultHandler)callback {
    dispatch_async(self.bleQueue, ^{
        [self readValueActionForCharacteristicWithUUID:cUUID ofServiceWithUUID:sUUID callback:callback];
    });
}

- (void)writeValue:(NSData *)data type:(CBCharacteristicWriteType)type ForCharacteristicWithUUID:(NSString *)cUUID ofServiceWithUUID:(NSString *)sUUID callback:(DMPeripheralWriteResultHandler)callback {
    dispatch_async(self.bleQueue, ^{
        [self writeValueAction:data type:type ForCharacteristicWithUUID:cUUID ofServiceWithUUID:sUUID callback:callback];
    });
}

- (void)readFailCallback:(DMPeripheralReadResultHandler)callback WithReason:(NSString *)reason {
    if (callback) {
        callback(nil, [NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey:reason}]);
    }
}

- (void)writeFailCallback:(DMPeripheralWriteResultHandler)callback WithReason:(NSString *)reason {
    if (callback) {
        callback([NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey:reason}]);
    }
}

#pragma mark - read&write(bleQueue)
- (void)readValueActionForCharacteristicWithUUID:(NSString *)cUUID ofServiceWithUUID:(NSString *)sUUID callback:(DMPeripheralReadResultHandler)callback {
    CBCharacteristic *chara = [self findCharacteristicWithUUID:cUUID ofServiceUUID:sUUID];
    if (chara == nil) {
        MAIN(^{
            [self readFailCallback:callback WithReason:@"Did not find characteristic."];
        });
        return;
    }
    if (self.readHandles[chara.UUID]) {
        MAIN(^{
            [self readFailCallback:callback WithReason:@"unfinished."];
        });
        return;
    }
    if (callback == nil) {
        callback = DMBLEReadDefaultCallback;
    }
    self.readHandles[chara.UUID] = callback;
    [self readTimeoutWithUUID:chara.UUID callback:callback];
    [self.peripheral readValueForCharacteristic:chara];
}

- (void)writeValueAction:(NSData *)data type:(CBCharacteristicWriteType)type ForCharacteristicWithUUID:(NSString *)cUUID ofServiceWithUUID:(NSString *)sUUID callback:(DMPeripheralWriteResultHandler)callback {
    CBCharacteristic *chara = [self findCharacteristicWithUUID:cUUID ofServiceUUID:sUUID];
    if (chara == nil) {
        MAIN(^{
            [self writeFailCallback:callback WithReason:@"Did not find characteristic."];
        });
        return;
    }
    if (self.writeHandles[chara.UUID]) {
        MAIN(^{
            [self writeFailCallback:callback WithReason:@"unfinished."];
        });
        return;
    }
    if (callback == nil) {
        callback = DMBLEWriteDefaultCallback;
    }
    if (type == CBCharacteristicWriteWithResponse) {
        self.writeHandles[chara.UUID] = callback;
        [self writeTimeoutWithUUID:chara.UUID callback:callback];
    }
    else {
        MAIN(^{
            callback(nil);
        });
    }
    [self.peripheral writeValue:data forCharacteristic:chara type:type];
}

- (CBCharacteristic *)findCharacteristicWithUUID:(NSString *)cUUID ofServiceUUID:(NSString *)sUUID {
    for (CBService *service in self.peripheral.services) {
        if ([sUUID isEqualToString:service.UUID.UUIDString]) {
            for (CBCharacteristic *chara in service.characteristics) {
                if ([cUUID isEqualToString:chara.UUID.UUIDString]) {
                    return chara;
                }
            }
        }
    }
    return nil;
}

- (void)readTimeoutWithUUID:(CBUUID *)UUID callback:(DMPeripheralReadResultHandler)callback {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DMCharacteristicReadWriteTimeout * NSEC_PER_SEC)), self.bleQueue, ^{
        if (self.readHandles[UUID] == nil) {
            return;
        }
        if (![self.readHandles[UUID] isEqual:callback]) {
            return;
        }
        [self.readHandles removeObjectForKey:UUID];
        MAIN(^{
            [self readFailCallback:callback WithReason:@"timeout."];
        });
    });
}

- (void)writeTimeoutWithUUID:(CBUUID *)UUID callback:(DMPeripheralWriteResultHandler)callback {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DMCharacteristicReadWriteTimeout * NSEC_PER_SEC)), self.bleQueue, ^{
        if (self.writeHandles[UUID] == nil) {
            return;
        }
        if (![self.writeHandles[UUID] isEqual:callback]) {
            return;
        }
        [self.writeHandles removeObjectForKey:UUID];
        MAIN(^{
            [self writeFailCallback:callback WithReason:@"timeout."];
        });
    });
}

#pragma mark - read&write callback(bleQueue)
- (void)writeResultForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (characteristic == nil) {
        return;
    }
    if (self.writeHandles[characteristic.UUID] == nil) {
        return;
    }
    DMPeripheralWriteResultHandler callback = self.writeHandles[characteristic.UUID];
    [self.writeHandles removeObjectForKey:characteristic.UUID];
    MAIN(^{
        callback(error);
    });
}

- (void)readResultForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (characteristic == nil) {
        return;
    }
    if (self.readHandles[characteristic.UUID] == nil) {
        return;
    }
    DMPeripheralReadResultHandler callback = self.readHandles[characteristic.UUID];
    [self.readHandles removeObjectForKey:characteristic.UUID];
    if (error) {
        MAIN(^{
            callback(nil, error);
        });
        return;
    }
    MAIN(^{
        callback(characteristic.value, error);
    });
}

#pragma mark - CBPeripheralDelegate(bleQueue)
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral {
    MAIN(^{
        if (self.peripheralDelegate && [self.peripheralDelegate respondsToSelector:@selector(peripheralDidUpdateName:)]) {
            [self.peripheralDelegate peripheralDidUpdateName:peripheral];
        }
    });
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray<CBService *> *)invalidatedServices {
    MAIN(^{
        if (self.peripheralDelegate && [self.peripheralDelegate respondsToSelector:@selector(peripheral:didModifyServices:)]) {
            [self.peripheralDelegate peripheral:peripheral didModifyServices:invalidatedServices];
        }
    });
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error {
    MAIN(^{
        if (self.peripheralDelegate && [self.peripheralDelegate respondsToSelector:@selector(peripheral:didReadRSSI:error:)]) {
            [self.peripheralDelegate peripheral:peripheral didReadRSSI:RSSI error:error];
        }
    });
}

#pragma mark 发现服务后的回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    MAIN(^{
        if (self.peripheralDelegate && [self.peripheralDelegate respondsToSelector:@selector(peripheral:didDiscoverServices:)]) {
            [self.peripheralDelegate peripheral:peripheral didDiscoverServices:error];
        }
    });
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(nullable NSError *)error {
    MAIN(^{
        if (self.peripheralDelegate && [self.peripheralDelegate respondsToSelector:@selector(peripheral:didDiscoverIncludedServicesForService:error:)]) {
            [self.peripheralDelegate peripheral:peripheral didDiscoverIncludedServicesForService:service error:error];
        }
    });
}

#pragma mark 发现特性后的回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    MAIN(^{
        if (self.peripheralDelegate && [self.peripheralDelegate respondsToSelector:@selector(peripheral:didDiscoverCharacteristicsForService:error:)]) {
            [self.peripheralDelegate peripheral:peripheral didDiscoverCharacteristicsForService:service error:error];
        }
    });
}

#pragma mark 读特性/订阅成功后特性发生任何改变 的回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    [self readResultForCharacteristic:characteristic error:error];
    MAIN(^{
        if (self.peripheralDelegate && [self.peripheralDelegate respondsToSelector:@selector(peripheral:didUpdateValueForCharacteristic:error:)]) {
            [self.peripheralDelegate peripheral:peripheral didUpdateValueForCharacteristic:characteristic error:error];
        }
    });
}

#pragma mark 写特性后的回调
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    [self writeResultForCharacteristic:characteristic error:error];
    MAIN(^{
        if (self.peripheralDelegate && [self.peripheralDelegate respondsToSelector:@selector(peripheral:didWriteValueForCharacteristic:error:)]) {
            [self.peripheralDelegate peripheral:peripheral didWriteValueForCharacteristic:characteristic error:error];
        }
    });
}

#pragma mark 订阅特性后的回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    MAIN(^{
        if (self.peripheralDelegate && [self.peripheralDelegate respondsToSelector:@selector(peripheral:didUpdateNotificationStateForCharacteristic:error:)]) {
            [self.peripheralDelegate peripheral:peripheral didUpdateNotificationStateForCharacteristic:characteristic error:error];
        }
    });
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    MAIN(^{
        if (self.peripheralDelegate && [self.peripheralDelegate respondsToSelector:@selector(peripheral:didDiscoverDescriptorsForCharacteristic:error:)]) {
            [self.peripheralDelegate peripheral:peripheral didDiscoverDescriptorsForCharacteristic:characteristic error:error];
        }
    });
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
    MAIN(^{
        if (self.peripheralDelegate && [self.peripheralDelegate respondsToSelector:@selector(peripheral:didUpdateValueForDescriptor:error:)]) {
            [self.peripheralDelegate peripheral:peripheral didUpdateValueForDescriptor:descriptor error:error];
        }
    });
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
    MAIN(^{
        if (self.peripheralDelegate && [self.peripheralDelegate respondsToSelector:@selector(peripheral:didWriteValueForDescriptor:error:)]) {
            [self.peripheralDelegate peripheral:peripheral didWriteValueForDescriptor:descriptor error:error];
        }
    });
}

@end
