//
//  NSDictionary+Tencent.m
//  JKDemo
//
//  Created by jackyjiao on 5/16/17.
//  Copyright © 2017 jackyjiao. All rights reserved.
//

#import "NSDictionary+Tencent.h"

@implementation NSDictionary (Tencent)

- (NSString *)toJsonString {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if(error){
        return [NSString stringWithFormat:@"{code : 3, desc : \"System error:%@\" }", error.domain];
    }
    NSString *jsonString =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (instancetype)fromString:(NSString *)jsonString {
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        return nil;
    }
    return dict;
}

@end
