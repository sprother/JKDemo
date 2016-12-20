//
//  NSDate+WristBand.h
//  JKDemo
//
//  Created by jackyjiao on 12/20/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (WristBand)

+ (id)fromData:(NSData *)data;
- (NSData *)toData;

@end
