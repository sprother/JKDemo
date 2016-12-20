//
//  DMWristBandUserData.h
//  JKDemo
//
//  Created by jackyjiao on 12/20/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, DMUserDataSex) {
    DMUserDataMale   = 0,
    DMUserDataFemale = 1
};

@interface DMWristBandUserData : NSObject

@property (nonatomic, assign) DMUserDataSex sex;
@property (nonatomic, assign) uint8_t       age;
@property (nonatomic, assign) uint8_t       stepLength;
@property (nonatomic, assign) uint16_t      height;
@property (nonatomic, assign) uint16_t      weight;
@property (nonatomic, assign) uint16_t      longSitTime;

+ (id)fromData:(NSData *)data;
- (id)fromData:(NSData *)data;
- (NSData *)toData;

@end
