//
//  DMPullToRefreshControl.h
//  DeviceManager
//
//  Created by jayceyang on 16/8/11.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "DMPullToRefreshControl.h"

#import "WCGraintCircleLayer.h"

@interface DMPullToRefreshControl ()
@property (nonatomic, strong) WCGraintCircleLayer *frontCircleLayer;
@end

@implementation DMPullToRefreshControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _frontCircleLayer = [[WCGraintCircleLayer alloc] initGraintCircleWithBounds:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) Position:CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame)) FromColor:[UIColor colorWithRed:78/255.0 green:219/255.0 blue:102/255.0 alpha:1] ToColor:DEFAULT_BACKGROUND_COLOR LineWidth:2.0];
        [self.layer addSublayer:_frontCircleLayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    //self.center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds));

    self.frontCircleLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));;
}

#pragma mark - INSAnimatable

- (void)startAnimating {
    NSTimeInterval animationDuration = 1;
    CAMediaTimingFunction *linearCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue = 0;
    animation.toValue = [NSNumber numberWithFloat:M_PI*2];
    animation.duration = animationDuration;
    animation.timingFunction = linearCurve;
    animation.removedOnCompletion = NO;
    animation.repeatCount = INFINITY;
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = NO;
    
    [self.frontCircleLayer addAnimation:animation forKey:@"rotateAnimation"];
}

- (void)stopAnimating {
    [self.frontCircleLayer removeAnimationForKey:@"rotateAnimation"];
}

@end
