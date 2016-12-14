//
//  DMWristBandManager.h
//  JKDemo
//
//  Created by jackyjiao on 12/14/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMPeripheral.h"

typedef void (^DMWristBandWriteResultHandler)(NSError *);
typedef void (^DMWristBandWriteResultHandler)(NSError *);

@interface DMWristBandManager : NSObject

@property (nonatomic, strong) DMPeripheral *dmPeripheral;
@property (nonatomic, assign, readonly) BOOL isConnect;

+ (instancetype)sharedManager;


@end
