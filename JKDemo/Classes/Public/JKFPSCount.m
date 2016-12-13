//
//  JKFPSCount.m
//  JKDemo
//
//  Created by jackyjiao on 12/12/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "JKFPSCount.h"

@interface JKFPSCount ()

@property (nonatomic, strong) CADisplayLink  *displayLink;
@property (nonatomic, assign) CFTimeInterval startTime;

@end

@implementation JKFPSCount

+ (instancetype)sharedInstance {
    static JKFPSCount *_instance = nil;

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _instance = [[JKFPSCount alloc] init];
    });

    return _instance;
}

- (void)dealloc {
    if (_displayLink) {
        [_displayLink invalidate];
    }
    _displayLink = nil;
}

- (instancetype)init {
    if ([super init]) {
        _startTime = 0;
    }
    return self;
}

#pragma mark - Calc FPS
- (void)displayLinkDidDraw:(CADisplayLink *)displayLink {
    double endTime = CACurrentMediaTime();

    if (self.startTime < 1) {
        return;
    }
    int fps = (int)(60.0/(endTime-self.startTime));
    if (fps > 60) {
        fps = 60;
    } else if (fps < 0) {
        fps = 0;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:JKFPSNotification object:[NSNumber numberWithInteger:fps]];
    self.startTime = endTime;
}

- (void)start {
    if (_displayLink) {
        JLog(@"JKFPSCount has start.");
        return;
    }
    __weak typeof(self) weakSelf = self;
    _displayLink                 = [CADisplayLink displayLinkWithTarget:weakSelf selector:@selector(displayLinkDidDraw:)];
    _displayLink.frameInterval   = 60;
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.startTime = CACurrentMediaTime();
}

- (void)stop {
    if (_displayLink) {
        [_displayLink invalidate];
    }
    _displayLink = nil;
}

@end
