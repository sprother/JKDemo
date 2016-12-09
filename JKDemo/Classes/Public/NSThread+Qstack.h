//
//  NSThread+Qstack.h
//  TabDemo
//
//  Created by jackyjiao on 5/14/15.
//  Copyright (c) 2015 jackyjiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <objc/runtime.h>

@interface NSThread (Qstack)

+ (void)printCallStack;
+ (void)saveMethodDict;

@end
