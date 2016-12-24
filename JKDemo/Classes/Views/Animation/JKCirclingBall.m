//
//  JKCirclingBall.m
//  JKDemo
//
//  Created by jackyjiao on 12/24/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "JKCirclingBall.h"
#import "JKEllipseView.h"
#import <math.h>

#define JKCirclingBallRadiu 10
#define JKCirclingRadiu     100
#define JKCirclingBallSpeed 2.0

@interface JKCirclingBall () <CAAnimationDelegate>

@property (nonatomic, strong) JKEllipseView *ballView;
@property (nonatomic, strong) CALayer       *circleLayer;
@property (nonatomic, assign) CGFloat       circlingRadiu;

@end

@implementation JKCirclingBall

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.circlingRadiu   = JKCirclingRadiu;
        [self addSubview:self.ballView];
        [self.layer addSublayer:self.circleLayer];
    }
    return self;
}

#pragma mark - ballView
- (JKEllipseView *)ballView {
    if (_ballView == nil) {
        _ballView = [[JKEllipseView alloc] initWithFrame:CGRectMake(0, 0, 2*JKCirclingBallRadiu, 2*JKCirclingBallRadiu) color:RANDOM_COLOR];
    }
    return _ballView;
}

#pragma mark - circleLayer
- (CAShapeLayer *)circleLayer {
    CAShapeLayer     *solidLine = [CAShapeLayer layer];
    CGMutablePathRef solidPath  = CGPathCreateMutable();

    solidLine.lineWidth   = 1.0f;
    solidLine.strokeColor = RANDOM_COLOR.CGColor;
    solidLine.fillColor   = [UIColor clearColor].CGColor;
    CGPathAddEllipseInRect(solidPath, nil, CGRectMake(self.tcWidth/2.0-self.circlingRadiu, self.tcHeight/2.0-self.circlingRadiu, 2*self.circlingRadiu, 2*self.circlingRadiu));
    solidLine.path = solidPath;
    CGPathRelease(solidPath);
    return solidLine;
}

#pragma mark - 能量守恒旋转效果
- (void)stopCirclingAnimation {
    [self.ballView.layer removeAllAnimations];
}

- (void)startCirclingAnimation {
    CAKeyframeAnimation *positionAnimation = [self positionCirclingAnimationFromPoint];

    [self.ballView.layer addAnimation:positionAnimation forKey:@"circlingAnimation"];
}

- (CAKeyframeAnimation *)positionCirclingAnimationFromPoint {
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];

    positionAnimation.duration            = JKCirclingBallSpeed;
    positionAnimation.removedOnCompletion = NO;
    positionAnimation.fillMode            = kCAFillModeForwards;
    positionAnimation.delegate            = self;
    positionAnimation.values              = [self animationCirclingValue];
    positionAnimation.autoreverses        = NO;
    positionAnimation.repeatCount         = HUGE_VALF;
    return positionAnimation;
}

- (NSArray *)animationCirclingValue {
    CGFloat        omegaInit   = 0.05;//初角速度
    CGFloat        gWeight     = 9.8;
    CGPoint        centerPoint = CGPointMake(self.tcWidth/2.0, self.tcHeight/2.0);
    CGFloat        deltaTime   = 0.1;
    CGFloat        theta       = 0;
    CGFloat        omega       = 0;
    NSMutableArray *mArray     = [NSMutableArray new];

    while (theta < 3.14159*2) {
        NSValue *point = [NSValue valueWithCGPoint:CGPointMake(centerPoint.x + self.circlingRadiu*sin(theta), centerPoint.y - self.circlingRadiu*cos(theta))];
        [mArray addObject:point];
        omega = sqrt(omegaInit*omegaInit + gWeight*2/self.circlingRadiu*(1-cos(theta)));//
        theta = theta + omega*deltaTime;
    }
    return [mArray copy];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    JLog(@"CirclingAnimation DidStop");
}

@end
