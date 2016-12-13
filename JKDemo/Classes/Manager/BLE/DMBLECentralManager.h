//
//  DMBLECentralManager.h
//  DeviceManager
//
//  Created by hth on 11/27/15.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

#define JKPeriListUpdateNotification    @"JKPeriListUpdateNotification"
#define JKPeripheralUpdateNotification  @"JKPeripheralUpdateNotification"

#define JKBLEKEYPeripheral              @"JKBLEKEYPeripheral"
#define JKBLEKEYAdvertiseData           @"JKBLEKEYAdvertiseData"
#define JKBLEKEYPeripheralRSSI          @"JKBLEKEYPeripheralRSSI"
#define JKBLEKEYService                 @"JKBLEKEYService"
#define JKBLEKEYCharacteristics         @"JKBLEKEYCharacteristics"

@interface DMBLECentralManager : NSObject
+ (instancetype)sharedManager;

@property (atomic, strong) NSArray<NSDictionary *>  *periArray;
@property (atomic, copy) NSArray<NSDictionary *>    *periInfo;

- (void)startScan;
- (void)stopScan;
- (void)connectPeripheral:(CBPeripheral *)peripheral;
- (void)cancelPeripheralConnection;

@end
