//
//  JKMemoTest.h
//  JKDemo
//
//  Created by jackyjiao on 2018/5/2.
//  Copyright © 2018年 jackyjiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKMemoTest : NSObject

+ (instancetype)sharedInstance;

- (void)start;
- (void)stop;

@end
