//
//  NSString+IMSDK.h
//  JKDemo
//
//  Created by jackyjiao on 3/20/17.
//  Copyright © 2017 jackyjiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IMSDK)

+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary;
+ (NSString *)jsonStringWithArray:(NSArray *)array;
+ (NSString *)jsonStringWithString:(NSString *)string;
+ (NSString *)jsonStringWithObject:(id) object;

@end
