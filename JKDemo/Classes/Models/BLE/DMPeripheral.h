//
//  DMPeripheral.h
//  JKDemo
//
//  Created by jackyjiao on 12/14/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef void (^DMPeripheralReadResultHandler)(NSData *, NSError *);
typedef void (^DMPeripheralWriteResultHandler)(NSError *);

@interface DMPeripheral : NSObject

@property (nonatomic, strong) CBPeripheral               *peripheral;
@property (nonatomic, copy) NSDictionary<NSString *, id> *advertisementData;
@property (nonatomic, strong) NSNumber                   *RSSI;
@property (nonatomic, weak) id<CBPeripheralDelegate>     peripheralDelegate;

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary <NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI;

- (void)discoverServices;
- (void)discoverCharacteristicsForService:(CBService *)service;

- (void)readValueForCharacteristicWithUUID:(NSString *)uuid ofServiceWithUUID:(NSString *)sUUID callback:(DMPeripheralReadResultHandler)callback;
- (void)writeValue:(NSData *)data type:(CBCharacteristicWriteType)type ForCharacteristicWithUUID:(NSString *)uuid ofServiceWithUUID:(NSString *)sUUID callback:(DMPeripheralWriteResultHandler)callback;

@end
