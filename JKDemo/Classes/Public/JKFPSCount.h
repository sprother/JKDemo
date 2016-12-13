//
//  JKFPSCount.h
//  JKDemo
//
//  Created by jackyjiao on 12/12/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JKFPSNotification @"JKFPSNotification"

@interface JKFPSCount : NSObject

+ (instancetype)sharedInstance;

- (void)start;
- (void)stop;

@end
