//
//  MainThreadWatchdog.h
//  miniStation
//
//  Created by jayceyang on 16/4/14.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainThreadWatchdog : NSObject

+ (instancetype)sharedWatchdog;

- (void)startWithHandler:(void (^)(void))handler;

- (void)stop;

@end
