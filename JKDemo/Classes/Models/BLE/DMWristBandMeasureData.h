//
//  DMWristBandMeasureData.h
//  JKDemo
//
//  Created by jackyjiao on 12/20/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, DMWristBandRunState) {
    DMWristBandRunStateWalk         = 0,//步行
    DMWristBandRunStateFastWalk     = 1,//快走
    DMWristBandRunStateRun          = 2,//快走
    DMWristBandRunStateRest         = 3,//快走
    DMWristBandRunStateUnsleep      = 4,//快走
    DMWristBandRunStateShallowSleep = 5,//快走
    DMWristBandRunStateDeepSleep    = 6//快走
};

@interface DMWristBandMeasureData : NSObject

@property (nonatomic, assign) DMWristBandRunState runState;
@property (nonatomic, assign) uint8_t             speed;
@property (nonatomic, assign) uint16_t            stepCount;
@property (nonatomic, assign) uint16_t            distance;
@property (nonatomic, assign) uint16_t            calorie;
@property (nonatomic, assign) uint16_t            runDuration;
@property (nonatomic, assign) uint16_t            deepSleepDuration;
@property (nonatomic, assign) uint16_t            shallowSleepDuration;
@property (nonatomic, assign) uint16_t            restDuration;
@property (nonatomic, assign) uint8_t             heartRate;
@property (nonatomic, assign) uint8_t             bloodOxygen;

//+ (id)fromData:(NSData *)data;
//- (id)fromData:(NSData *)data;
//- (NSData *)toData;

@end
