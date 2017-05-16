//
//  NSDictionary+Tencent.h
//  JKDemo
//
//  Created by jackyjiao on 5/16/17.
//  Copyright © 2017 jackyjiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Tencent)

- (NSString *)toJsonString;
+ (instancetype)fromString:(NSString *)jsonString;

@end
