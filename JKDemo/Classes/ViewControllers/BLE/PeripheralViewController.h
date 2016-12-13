//
//  PeripheralViewController.h
//  JKDemo
//
//  Created by jackyjiao on 12/7/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "JKBaseViewController.h"
#import "DMBLECentralManager.h"

@interface PeripheralViewController : JKBaseViewController

@property (nonatomic, strong) CBPeripheral *peripheral;

@end
